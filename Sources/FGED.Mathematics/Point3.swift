//
//  Point3.swift
//  
//
//  Created by Robert Bigelow on 7/18/20.
//

protocol Point3: Vector3 {
    associatedtype Vector: Vector3 where Vector.Scalar == Scalar
    
    static func + (left: Self, right: Vector) -> Self
    static func - (left: Self, right: Self) -> Vector
    
    func asVector() -> Vector
}

extension Point3 {
    static func + (left: Self, right: Vector) -> Self {
        return Self(left.storage + right.storage)
    }
    
    static func - (left: Self, right: Self) -> Vector {
        return Vector(left.storage - right.storage)
    }
}
