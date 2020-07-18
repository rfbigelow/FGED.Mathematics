import RealModule

protocol Vector3 {
    associatedtype Scalar: Real & SIMDScalar
    associatedtype Matrix: Matrix3x3 where Matrix.Vector == Self
    
    static var zero: Self { get }
    static var one: Self { get }
    
    static var i: Self { get }
    static var j: Self { get }
    static var k: Self { get }
    
    var storage: SIMD3<Scalar> { get }
    
    var x: Scalar { get }
    var y: Scalar { get }
    var z: Scalar { get }
    
    init(_ simd: SIMD3<Scalar>)
    init(_ x: Scalar, _ y: Scalar, _ z: Scalar)
    
    subscript(index: Int) -> Scalar { get }
    
    func magnitude() -> Scalar
    func normalize() -> Self
    
    func dotProduct(_ other: Self) -> Scalar
    func crossProduct(_ other: Self) -> Self
    func outerProduct(_ other: Self) -> Matrix
    
    func project(onto v: Self) -> Self
    func reject(from v: Self) -> Self
    
    static func * (left: Self, right: Scalar) -> Self
    static func / (left: Self, right: Scalar) -> Self
    
    static prefix func - (v: Self) -> Self
    
    static func + (left: Self, right: Self) -> Self
    static func - (left: Self, right: Self) -> Self
    static func * (left: Self, right: Self) -> Self
}

extension Vector3 {
    static var zero: Self { return Self(SIMD3.zero) }
    static var one: Self { return Self(SIMD3.one) }
    
    static var i: Self { return Self(SIMD3<Scalar>(1, 0, 0)) }
    static var j: Self { return Self(SIMD3<Scalar>(0, 1, 0)) }
    static var k: Self { return Self(SIMD3<Scalar>(0, 0, 1)) }

    var x: Scalar { return storage.x }
    var y: Scalar { return storage.y }
    var z: Scalar { return storage.z }
    
    subscript(index: Int) -> Scalar { return storage[index] }
    
    func magnitude() -> Scalar {
        return (storage * storage).sum().squareRoot()
    }
    
    func normalize() -> Self {
        return Self(self.storage / self.magnitude())
    }
    
    func dotProduct(_ other: Self) -> Scalar {
        return (self.storage * other.storage).sum()
    }

    func crossProduct(_ other: Self) -> Self {
        return Self(self.storage.yzx * other.storage.zxy - self.storage.zxy * other.storage.yzx)
    }
    
    func outerProduct(_ other: Self) -> Matrix {
        return Matrix(self * other.x, self * other.y, self * other.z)
    }
    
    func project(onto v: Self) -> Self {
        return v * (self.dotProduct(v) / v.dotProduct(v))
    }
    
    func reject(from v: Self) -> Self {
        return self - project(onto: v)
    }
    
    static func * (left: Self, right: Scalar) -> Self {
        return Self(left.storage * right)
    }
    
    static func / (left: Self, right: Scalar) -> Self {
        return Self(left.storage / right)
    }
    
    static prefix func - (v: Self) -> Self {
        return Self(-v.storage)
    }
    
    static func + (left: Self, right: Self) -> Self {
        return Self(left.storage + right.storage)
    }
    
    static func - (left: Self, right: Self) -> Self {
        return Self(left.storage - right.storage)
    }

    static func * (left: Self, right: Self) -> Self {
        return Self(left.storage * right.storage)
    }
}
