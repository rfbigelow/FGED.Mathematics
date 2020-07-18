//
//  Point3D.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

import RealModule

struct Point3D<T: Real & SIMDScalar>: Point3, Equatable {
    typealias Scalar = T
    typealias Vector = Vector3D<T>
    typealias Matrix = Matrix3D<Self>
    
    static var zero: Point3D<T> { return Self(SIMD3.zero) }
    
    let storage: SIMD3<T>
    
    init(_ simd: SIMD3<T>) {
        storage = simd
    }
    
    init(_ x: T, _ y: T, _ z: T) {
        storage = SIMD3<T>(x, y, z)
    }
}
