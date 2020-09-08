//
//  ReStruct.swift
//  RE02
//
//  Created by Zerui Chen on 7/9/20.
//

import Foundation

class ReStruct {
    
    typealias Specification = [(String, PropertyDescriptor)]
    
    enum PropertyDescriptor {
        case uint32, uint64, uuid
        case string(Int), reserved(Int)
        indirect case array(PropertyDescriptor, Int)
    }
    
    init(withSpecification specification: Specification) {
        self.specification = specification
    }
    
    private let specification: Specification
    
    private func parse(_ property: PropertyDescriptor, from data: Data, offset: inout Int) -> Any {
        switch property {
        case .string(let length):
            let string = String(data: data[offset..<offset+length], encoding: .utf8)!
            offset += length
            return string
        case .uuid:
            let uuidPtr = UnsafeMutablePointer<uuid_t>.allocate(capacity: 1)
            _ = data[offset..<offset+16].withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
                memcpy(uuidPtr, ptr.baseAddress!, 16)
            }
            offset += 16
            defer {
                uuidPtr.deallocate()
            }
            return UUID(uuid: uuidPtr.pointee)
        case .reserved(let length):
            offset += length
            return 0
        case .uint32:
            let int: UInt32 = data[offset..<offset+4].load()
            offset += 4
            return int
        case .uint64:
            let int: UInt64 = data[offset..<offset+8].load()
            offset += 8
            return int
        case let .array(containedProperty, count):
            return (1...count).map { _ in
                parse(containedProperty, from: data, offset: &offset)
            }
        }
    }
    
    
    func parse(_ data: Data) -> [String:Any] {
        var offset = data.startIndex
        return Dictionary(uniqueKeysWithValues: specification.map {
            ($0, parse($1, from: data, offset: &offset))
        })
    }
}

fileprivate extension Data {
    func load<IntType: BinaryInteger>() -> IntType {
        // Need to reverse bytes or data will be loaded in the big endian format.
        return reversed().withUnsafeBytes { dataPtr in
            var int = IntType()
            _ = Swift.withUnsafeMutableBytes(of: &int) { intPtr in
                dataPtr.copyBytes(to: intPtr)
            }
            return int
        }
    }
}
