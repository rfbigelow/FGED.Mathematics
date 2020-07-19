//
//  Transform4D.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

import RealModule

struct Transform4D<T: Real & SIMDScalar>: Transform4x4, Equatable {
    typealias Matrix = Matrix3D<T>
    typealias Point = Point3D<T>
    
    let m: Matrix
    let translation: Point
    
    init(_ m: Matrix, _ p: Point) {
        self.m = m
        self.translation = p
    }
    
    init(_ a: Vector, _ b: Vector, _ c: Vector, _ p: Point) {
        self.m = Matrix(a, b, c)
        self.translation = p
    }
    
    init(_ a00: Scalar, _ a01: Scalar, _ a02: Scalar, _ a03: Scalar, _ a10: Scalar, _ a11: Scalar, _ a12: Scalar, _ a13: Scalar, _ a20: Scalar, _ a21: Scalar, _ a22: Scalar, _ a23: Scalar) {
        self.m = Matrix(a00, a01, a02,
                          a10, a11, a12,
                          a20, a21, a22)
        self.translation = Point(a03, a13, a23)
    }
}
