//
//  Vector3D.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

import RealModule

struct Vector3D<T: Real & SIMDScalar>: Vector3, Equatable {
    typealias Matrix = Matrix3D<T>
    
    let storage: SIMD3<T>
    
    init() {
        storage = SIMD3.zero
    }
    
    init(_ simd: SIMD3<T>) {
        storage = simd
    }

    init(_ x: T, _ y: T, _ z: T) {
        storage = SIMD3<T>(x, y, z)
    }
    
    init<Vector>(_ v: Vector) where Vector:Vector3, Vector.Scalar == T {
        storage = v.storage
    }
}

func scalarTripleProduct<T: SIMDScalar & FloatingPoint>(_ a: Vector3D<T>, _ b: Vector3D<T>, _ c: Vector3D<T>) -> T {
    return a.cross(b).dot(c)
}

#if !(os(macOS) || os(iOS) && targetEnvironment(macCatalyst))
extension Float16 {
    static func * (s: Float16, v: Vector3D<Float16>) -> Vector3D<Float16> {
        return v * s
    }
}
#endif

extension Float32 {
    static func * (s: Float32, v: Vector3D<Float32>) -> Vector3D<Float32> {
        return v * s
    }
}

extension Float64 {
    static func * (s: Float64, v: Vector3D<Float64>) -> Vector3D<Float64> {
        return v * s
    }
}
