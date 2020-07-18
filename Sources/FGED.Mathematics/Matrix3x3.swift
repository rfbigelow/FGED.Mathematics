//
//  Matrix3x3.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

protocol Matrix3x3 {
    associatedtype Vector: Vector3
    typealias Scalar = Vector.Scalar

    static var identity: Self { get }
    
    var inverse: Self { get }
    
    var c0: Vector { get }
    var c1: Vector { get }
    var c2: Vector { get }
    
    init(_ c0: Vector, _ c1: Vector, _ c2: Vector)
    init(_ a00: Scalar, _ a01: Scalar, _ a02: Scalar,
         _ a10: Scalar, _ a11: Scalar, _ a12: Scalar,
         _ a20: Scalar, _ a21: Scalar, _ a22: Scalar)
    
    subscript (row: Int, column: Int) -> Scalar? { get }
    subscript (index: Int) -> Vector? { get }
    
    static prefix func - (m: Self) -> Self
    
    static func * (left: Self, right: Scalar) -> Self
    
    static func + (left: Self, right: Self) -> Self
    static func - (left: Self, right: Self) -> Self
    
    static func * (left: Self, right: Self) -> Self
    
    static func * (left: Self, right: Vector) -> Vector
}

extension Matrix3x3 {
    static var identity: Self {
        return Self(Vector(1, 0, 0), Vector(0, 1, 0), Vector(0, 0, 1))
    }
    
    var inverse: Self {
        let r0 = c1.crossProduct(c2)
        let r1 = c2.crossProduct(c0)
        let r2 = c0.crossProduct(c1)
        
        let invDet = Scalar(1) / r2.dotProduct(c2)
        
        return Self(
            r0.x, r0.y, r0.z,
            r1.x, r1.y, r1.z,
            r2.x, r2.y, r2.z) * invDet
    }
    
    subscript (row: Int, column: Int) -> Scalar? {
        let c = self[column]
        return c?[row]
    }
    
    subscript (index: Int) -> Vector? {
        switch index {
        case 0: return c0
        case 1: return c1
        case 2: return c2
        default:
            return nil
        }
    }
    
    static prefix func - (m: Self) -> Self {
        return Self(-m.c0, -m.c1, -m.c2)
    }
    
    static func * (left: Self, right: Scalar) -> Self {
        return Self(left.c0 * right, left.c1 * right, left.c2 * right)
    }
    
    static func + (left: Self, right: Self) -> Self {
        return Self(left.c0 + right.c0, left.c1 + right.c1, left.c2 + right.c2)
    }

    static func - (left: Self, right: Self) -> Self {
        return Self(left.c0 - right.c0, left.c1 - right.c1, left.c2 - right.c2)
    }
    
    static func * (left: Self, right: Self) -> Self {
        let r0 = Vector(right.c0.x, right.c1.x, right.c2.x)
        let r1 = Vector(right.c0.y, right.c1.y, right.c2.y)
        let r2 = Vector(right.c0.z, right.c1.z, right.c2.z)
        let m0 = left.c0.outerProduct(r0)
        let m1 = left.c1.outerProduct(r1)
        let m2 = left.c2.outerProduct(r2)
        return (m0 + m1 + m2) as! Self
    }
    
    static func * (left: Self, right: Vector) -> Vector {
        let vx = left.c0 * right.x
        let vy = left.c1 * right.y
        let vz = left.c2 * right.z
        return vx + vy + vz
    }
}

// transforms
extension Matrix3x3 {
    @inlinable
    static func makeRotationX(radians: Scalar) -> Self {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Self(
            Scalar(1), Scalar(0), Scalar(0),
            Scalar(0), c, -s,
            Scalar(0), s, c
        )
    }

    @inlinable
    static func makeRotationY(radians: Scalar) -> Self {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Self(
            c, Scalar(0), s,
            Scalar(0), Scalar(1), Scalar(0),
            -s, Scalar(0), c
        )
    }

    @inlinable
    static func makeRotationZ(radians: Scalar) -> Self {
        let c = Scalar.cos(radians)
        let s = Scalar.sin(radians)
        return Self(
            c, -s, Scalar(0),
            s, c, Scalar(0),
            Scalar(0), Scalar(0), Scalar(1)
        )
    }
    
    @inlinable
    static func makeRotation(radians: Scalar, a: Vector) -> Self {
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
        
        
        return Self(
            c + aad.x, axay - sa.z, axaz + sa.y,
            axay + sa.z, c + aad.y, ayaz - sa.x,
            axaz - sa.y, ayaz + sa.x, c + aad.z
        )
    }
    
    @inlinable
    static func makeReflection(a: Vector) -> Self {
        precondition(a.magnitude() == Scalar(1))
        let minus2a = a * -Scalar(2)
        let minus2aSquared = a * minus2a
        let axay = minus2a.x * a.y
        let axaz = minus2a.x * a.z
        let ayaz = minus2a.y * a.z
        
        return Self(
            minus2aSquared.x + Scalar(1), axay, axaz,
            axay, minus2aSquared.y + Scalar(1), ayaz,
            axaz, ayaz, minus2aSquared.z + Scalar(1)
        )
    }

    @inlinable
    static func makeInvolution(a: Vector) -> Self {
        precondition(a.magnitude() == Scalar(1))
        let plus2a = a * Scalar(2)
        let plus2aSquared = a * plus2a
        let axay = plus2a.x * a.y
        let axaz = plus2a.x * a.z
        let ayaz = plus2a.y * a.z
        
        return Self(
            plus2aSquared.x - Scalar(1), axay, axaz,
            axay, plus2aSquared.y - Scalar(1), ayaz,
            axaz, ayaz, plus2aSquared.z - Scalar(1)
        )
    }
    
    @inlinable
    static func makeScale(sx: Scalar, sy: Scalar, sz: Scalar) -> Self {
        return Self(
        sx, Scalar(0), Scalar(0),
        Scalar(0), sy, Scalar(0),
        Scalar(0), Scalar(0), sz
        )
    }
        
    @inlinable
    static func makeScale(s: Scalar, a: Vector) -> Self {
        precondition(a.magnitude() == Scalar(1))
        let sMinus1 = s - Scalar(1)
        let sa = a * sMinus1
        let axay = sa.x * a.y
        let axaz = sa.x * a.z
        let ayaz = sa.y * a.z
        let sa2 = sa * a
        
        return Self(
            sa2.x + Scalar(1), axay, axaz,
            axay, sa2.y + Scalar(1), ayaz,
            axaz, ayaz, sa2.z + Scalar(1)
        )
    }

    @inlinable
    static func makeUniformScale(s: Scalar) -> Self {
        return makeScale(sx: s, sy: s, sz: s)
    }
    
    @inlinable
    static func makeSkew(radians: Scalar, a: Vector, b: Vector) -> Self {
        let tanScalarheta = Scalar.tan(radians)
        let aScalaranScalarheta = a * tanScalarheta
        let abx = aScalaranScalarheta * b.x
        let aby = aScalaranScalarheta * b.y
        let abz = aScalaranScalarheta * b.z
        
        return Self(
            abx.x + Scalar(1), aby.x, abz.x,
            abx.y, aby.y + Scalar(1), abz.y,
            abx.z, aby.z, abz.z + Scalar(1)
        )
    }
}
