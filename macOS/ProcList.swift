//
//  ProcList.swift
//  RE02
//
//  Created by Zerui Chen on 8/9/20.
//

import Foundation

struct Proc: Hashable {
    let name: String
    let pid: Int32
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pid)
    }
}

func getProcList() -> [Proc] {
    let procListPtr = UnsafeMutablePointer<UnsafePointer<kinfo_proc>>.allocate(capacity: 1)
    var length = 0
    getBSDProcessList(procListPtr, &length)
    let procList: [Proc] = UnsafeBufferPointer(start: procListPtr.pointee, count: length).map {
        var nameC = $0.kp_proc.p_comm
        let name = withUnsafeBytes(of: &nameC) { ptr in
            String(bytes: ptr, encoding: .ascii) ?? "??"
        }
        let pid = $0.kp_proc.p_pid
        return Proc(name: name, pid: pid)
    }
    return procList
}
