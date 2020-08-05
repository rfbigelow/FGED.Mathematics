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

extension SIMD4 {
    var yxwz: SIMD4 { return self[SIMD4<Int>(1, 0, 3, 2)] }
    var zwxy: SIMD4 { return self[SIMD4<Int>(2, 3, 0, 1)] }
    var wzyx: SIMD4 { return self[SIMD4<Int>(3, 2, 1, 0)] }
}
