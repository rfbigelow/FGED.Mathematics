//
//  Matrix3D.swift
//  
//
//  Created by Robert Bigelow on 6/27/20.
//

import RealModule

struct Matrix3D<Vector: Vector3>: Matrix3x3, Equatable where Vector: Equatable {
    let c0: Vector
    let c1: Vector
    let c2: Vector
    
    init() {
        self.init(Vector.zero, Vector.zero, Vector.zero)
    }
    
    init(_ c0: Vector, _ c1: Vector, _ c2: Vector) {
        self.c0 = c0; self.c1 = c1; self.c2 = c2
    }
    
    init(_ a00: Scalar, _ a01: Scalar, _ a02: Scalar, _ a10: Scalar, _ a11: Scalar, _ a12: Scalar, _ a20: Scalar, _ a21: Scalar, _ a22: Scalar) {
        self.c0 = Vector(a00, a10, a20)
        self.c1 = Vector(a01, a11, a21)
        self.c2 = Vector(a02, a12, a22)
    }
    
    init(_ a: [Scalar]) {
        precondition(a.count == 9)
        self.init(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8])
    }
}

