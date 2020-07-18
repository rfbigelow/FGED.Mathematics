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
