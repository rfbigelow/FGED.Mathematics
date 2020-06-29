//
//  Matrix3D.swift
//  
//
//  Created by Robert Bigelow on 6/27/20.
//

public struct Matrix3D<T: SIMDScalar & FloatingPoint>: Equatable {
    let storage: [SIMD3<T>]
    
    @inlinable
    public static var identity: Matrix3D {
        return Matrix3D(
            T(1), T(0), T(0),
            T(0), T(1), T(0),
            T(0), T(0), T(1)
        )
    }
    
    public init() {
        storage = Array(repeating: SIMD3<T>(), count: 3)
    }
    
    public init(_ columns: [SIMD3<T>]) {
        precondition(columns.count == 3)
        self.storage = columns
    }
    
    public init(_ columns: [Vector3<T>]) {
        precondition(columns.count == 3)
        self.storage = [columns[0].storage, columns[1].storage, columns[2].storage]
    }
    
    public init(_ a00: T, _ a01: T, _ a02: T,
                _ a10: T, _ a11: T, _ a12: T,
                _ a20: T, _ a21: T, _ a22: T) {
        self.storage = [
            SIMD3(a00, a10, a20),
            SIMD3(a01, a11, a21),
            SIMD3(a02, a12, a22)
        ]
    }
    
    public init(_ rowMajor: [T]) {
        precondition(rowMajor.count == 9)
        self.storage = [
            SIMD3([rowMajor[0], rowMajor[3], rowMajor[6]]),
            SIMD3([rowMajor[1], rowMajor[4], rowMajor[7]]),
            SIMD3([rowMajor[2], rowMajor[5], rowMajor[8]])
        ]
    }
    
    public subscript(index: Int) -> Vector3<T> {
        return Vector3(storage[index])
    }
    
    public subscript(r: Int, c: Int) -> T {
        return storage[c][r]
    }
}

extension Matrix3D {
    static func + (left: Matrix3D, right: Matrix3D) -> Matrix3D {
        return Matrix3D([
            left.storage[0] + right.storage[0],
            left.storage[1] + right.storage[1],
            left.storage[2] + right.storage[2]
        ])
    }

    static func - (left: Matrix3D, right: Matrix3D) -> Matrix3D {
        return Matrix3D([
            left.storage[0] - right.storage[0],
            left.storage[1] - right.storage[1],
            left.storage[2] - right.storage[2]
        ])
    }
    
    static func * (m: Matrix3D, s: T) -> Matrix3D {
        return Matrix3D([m.storage[0] * s, m.storage[1] * s, m.storage[2] * s])
    }
    
    static func * (left: Matrix3D, right: Matrix3D) -> Matrix3D {
        return Matrix3D(
            left[0, 0] * right[0, 0] + left[0, 1] * right[1, 0] + left[0, 2] * right[2, 0],
            left[0, 0] * right[0, 1] + left[0, 1] * right[1, 1] + left[0, 2] * right[2, 1],
            left[0, 0] * right[0, 2] + left[0, 1] * right[1, 2] + left[0, 2] * right[2, 2],
            left[1, 0] * right[0, 0] + left[1, 1] * right[1, 0] + left[1, 2] * right[2, 0],
            left[1, 0] * right[0, 1] + left[1, 1] * right[1, 1] + left[1, 2] * right[2, 1],
            left[1, 0] * right[0, 2] + left[1, 1] * right[1, 2] + left[1, 2] * right[2, 2],
            left[2, 0] * right[0, 0] + left[2, 1] * right[1, 0] + left[2, 2] * right[2, 0],
            left[2, 0] * right[0, 1] + left[2, 1] * right[1, 1] + left[2, 2] * right[2, 1],
            left[2, 0] * right[0, 2] + left[2, 1] * right[1, 2] + left[2, 2] * right[2, 2]
        )
    }
    
    static func * (m: Matrix3D, v: Vector3<T>) -> Vector3<T> {
        return (m[0] * v.x) + (m[1] * v.y) + (m[2] * v.z)
    }
}
