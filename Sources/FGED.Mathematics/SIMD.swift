//
//  SIMD.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

extension SIMD3 {
    var yzx: SIMD3 { return self[SIMD3<Int>(1, 2, 0)] }
    var zxy: SIMD3 { return self[SIMD3<Int>(2, 0, 1)] }
}
