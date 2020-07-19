//
//  Transform4x4.swift
//  
//
//  Created by Robert Bigelow on 7/19/20.
//

protocol Transform4x4 {
    associatedtype Matrix: Matrix3x3
    associatedtype Point: Point3 where Point.Vector == Vector

    typealias Vector = Matrix.Vector
    typealias Scalar = Vector.Scalar
    
    var inverse: Self { get }

    var m: Matrix { get }
    var translation: Point { get }
    
    init(_ m: Matrix, _ p: Point)
    init(_ a: Vector, _ b: Vector, _ c: Vector, _ p: Point)
    init(_ a00: Scalar, _ a01: Scalar, _ a02: Scalar, _ a03: Scalar,
         _ a10: Scalar, _ a11: Scalar, _ a12: Scalar, _ a13: Scalar,
         _ a20: Scalar, _ a21: Scalar, _ a22: Scalar, _ a23: Scalar)
    
    subscript (index: Int) -> Vector? { get }
    
    static func * (left: Self, right: Self) -> Self
    static func * (left: Self, right: Vector) -> Vector
    static func * (left: Self, right: Point) -> Point
}

extension Transform4x4 {
    
    var inverse: Self {
        let a = m[0]!
        let b = m[1]!
        let c = m[2]!
        let d = translation
        
        var s = a.cross(b)
        var t = c.cross(d)
        
        let invDet = Scalar(1) / s.dot(c)
        s = s * invDet
        t = t * invDet
        
        let v = c * invDet
        
        let r0 = b.cross(v)
        let r1 = v.cross(a)
        
        return Self(r0.x, r0.y, r0.z, -b.dot(t),
                    r1.x, r1.y, r1.z, a.dot(t),
                    s.x, s.y, s.z, -d.dot(s))
    }
    
    subscript (index: Int) -> Vector? {
        return m[index]
    }
    
    static func * (left: Self, right: Self) -> Self {
        let m = left.m * right.m
        let p = left.translation + (left.m * right.translation)
        
        return Self(m, p)
    }
    
    static func * (left: Self, right: Vector) -> Vector {
        return left.m * right
    }
    
    static func * (left: Self, right: Point) -> Point {
        left.translation + (left.m * right)
    }
}
