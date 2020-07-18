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

// transforms
extension Matrix3D {
    @inlinable
    static func makeRotationX(radians: Scalar) -> Matrix3D {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Matrix3D(
            Scalar(1), Scalar(0), Scalar(0),
            Scalar(0), c, -s,
            Scalar(0), s, c
        )
    }

    @inlinable
    static func makeRotationY(radians: Scalar) -> Matrix3D {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Matrix3D(
            c, Scalar(0), s,
            Scalar(0), Scalar(1), Scalar(0),
            -s, Scalar(0), c
        )
    }

    @inlinable
    static func makeRotationZ(radians: Scalar) -> Matrix3D {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Matrix3D(
            c, -s, Scalar(0),
            s, c, Scalar(0),
            Scalar(0), Scalar(0), Scalar(1)
        )
    }
    
    @inlinable
    static func makeRotation(radians: Scalar, a: Vector3D<Scalar>) -> Matrix3D {
        precondition(a.magnitude() == Scalar(1))
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        let d = Scalar(1) - c

        let ad = a * d
        let aad = a * ad
        let sa = a * s

        let axay = ad.x * a.y
        let axaz = ad.x * a.z
        let ayaz = ad.y * a.z
        
        
        return Matrix3D(
            c + aad.x, axay - sa.z, axaz + sa.y,
            axay + sa.z, c + aad.y, ayaz - sa.x,
            axaz - sa.y, ayaz + sa.x, c + aad.z
        )
    }
    
    @inlinable
    static func makeReflection(a: Vector3D<Scalar>) -> Matrix3D {
        precondition(a.magnitude() == Scalar(1))
        let minus2a = a * -Scalar(2)
        let minus2aSquared = a * minus2a
        let axay = minus2a.x * a.y
        let axaz = minus2a.x * a.z
        let ayaz = minus2a.y * a.z
        
        return Matrix3D(
            minus2aSquared.x + Scalar(1), axay, axaz,
            axay, minus2aSquared.y + Scalar(1), ayaz,
            axaz, ayaz, minus2aSquared.z + Scalar(1)
        )
    }

    @inlinable
    static func makeInvolution(a: Vector3D<Scalar>) -> Matrix3D {
        precondition(a.magnitude() == Scalar(1))
        let plus2a = a * Scalar(2)
        let plus2aSquared = a * plus2a
        let axay = plus2a.x * a.y
        let axaz = plus2a.x * a.z
        let ayaz = plus2a.y * a.z
        
        return Matrix3D(
            plus2aSquared.x - Scalar(1), axay, axaz,
            axay, plus2aSquared.y - Scalar(1), ayaz,
            axaz, ayaz, plus2aSquared.z - Scalar(1)
        )
    }
    
    @inlinable
    static func makeScale(sx: Scalar, sy: Scalar, sz: Scalar) -> Matrix3D {
        return Matrix3D(
        sx, Scalar(0), Scalar(0),
        Scalar(0), sy, Scalar(0),
        Scalar(0), Scalar(0), sz
        )
    }
        
    @inlinable
    static func makeScale(s: Scalar, a: Vector3D<Scalar>) -> Matrix3D {
        precondition(a.magnitude() == Scalar(1))
        let sMinus1 = s - Scalar(1)
        let sa = a * sMinus1
        let axay = sa.x * a.y
        let axaz = sa.x * a.z
        let ayaz = sa.y * a.z
        let sa2 = sa * a
        
        return Matrix3D(
            sa2.x + Scalar(1), axay, axaz,
            axay, sa2.y + Scalar(1), ayaz,
            axaz, ayaz, sa2.z + Scalar(1)
        )
    }

    @inlinable
    static func makeUniformScale(s: Scalar) -> Matrix3D {
        return makeScale(sx: s, sy: s, sz: s)
    }
    
    @inlinable
    static func makeSkew(radians: Scalar, a: Vector3D<Scalar>, b: Vector3D<Scalar>) -> Matrix3D {
        let tanScalarheta = Scalar.tan(radians)
        let aScalaranScalarheta = a * tanScalarheta
        let abx = aScalaranScalarheta * b.x
        let aby = aScalaranScalarheta * b.y
        let abz = aScalaranScalarheta * b.z
        
        return Matrix3D(
            abx.x + Scalar(1), aby.x, abz.x,
            abx.y, aby.y + Scalar(1), abz.y,
            abx.z, aby.z, abz.z + Scalar(1)
        )
    }
}
