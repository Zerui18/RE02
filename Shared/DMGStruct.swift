//
//  DMGStruct.swift
//  RE02
//
//  Created by Zerui Chen on 7/9/20.
//

import Foundation

extension ReStruct {
    
    static let dmgStruct: ReStruct = .init(withSpecification: [
        ("Signature", .string(4)),
        ("Version", .uint32),
        ("HeaderSize", .uint32),
        ("Flags", .uint32),
        ("RunDataForkOffset", .uint64),
        ("DataForkOffset", .uint64),
        ("DataForkLength", .uint64),
        ("RsrcForkOffset", .uint64),
        ("RsrcForkLength", .uint64),
        ("SegmentNumber", .uint32),
        ("SegmentCount", .uint32),
        ("SegmentID", .uuid),
        ("DataChecksumType", .uint32),
        ("DataChecksumSize", .uint32),
        ("DataChecksum[32]", .array(.uint32, 32)),
        ("XMLOffset", .uint64),
        ("XMLLength", .uint64),
        ("Reserved1[64]", .reserved(64)),
        ("SigOffset", .uint64),
        ("SigLength", .uint64),
        ("Reserved2[40]", .reserved(40)),
        ("ChecksumType", .uint32),
        ("ChecksumSize", .uint32),
        ("Checksum[32]", .array(.uint32, 32)),
        ("ImageVariant", .uint32),
        ("SectorCount", .uint64),
        ("Reserved3[3]", .reserved(12)),
    ])
    
}
