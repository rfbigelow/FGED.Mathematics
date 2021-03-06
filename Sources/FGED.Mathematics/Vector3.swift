import RealModule

protocol Vector3 {
    associatedtype Scalar: Real & SIMDScalar
    associatedtype Matrix: Matrix3x3 where Matrix.Vector.Scalar == Scalar
    
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
    init<T>(_ v: T) where T: Vector3, T.Scalar == Scalar
    
    subscript(index: Int) -> Scalar { get }
    
    func magnitude() -> Scalar
    func normalize() -> Self
    
    func dot<T>(_ other: T) -> Scalar where T: Vector3, T.Scalar == Scalar
    func cross<T>(_ other: T) -> Self where T: Vector3, T.Scalar == Scalar
    func outer<T>(_ other: T) -> Matrix where T: Vector3, T.Scalar == Scalar
    
    func project(onto v: Self) -> Self
    func reject(from v: Self) -> Self
    
    /// Multiplies all components of the vector by the given scalar.
    static func * (v: Self, s: Scalar) -> Self
    
    /// Divides all components of the vector by the given scalar.
    static func / (v: Self, s: Scalar) -> Self
    
    /// Negates the vector v.
    static prefix func - (v: Self) -> Self
    
    /// Pointwise addition.
    static func + (left: Self, right: Self) -> Self
    
    /// Pointwise subtraction.
    static func - (left: Self, right: Self) -> Self
    
    /// Pointwise multiplication.
    static func * (left: Self, right: Self) -> Self
    
    /// Transforms a normal vector from coordinate system B to coordinate system A using the homogeneous transform from A to B.
    ///
    /// Normal vectors are multiplied on the right, since they represent inverse distances. To transform a normal vector from coordinate
    /// system A to B, the inverse of the transform is required. This operator does not compute the inverse, so it goes in the opposite
    /// direction.
    static func * <T>(normal: Self, transform: T) -> Self where T: Transform4x4, T.Scalar == Scalar
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
    
    func dot<T>(_ other: T) -> Scalar where T: Vector3, T.Scalar == Scalar {
        return (self.storage * other.storage).sum()
    }

    func cross<T>(_ other: T) -> Self where T: Vector3, T.Scalar == Scalar {
        return Self(self.storage.yzx * other.storage.zxy - self.storage.zxy * other.storage.yzx)
    }
    
    func outer<T>(_ other: T) -> Matrix  where T: Vector3, T.Scalar == Scalar {
        return Matrix(Matrix.Vector(self * other.x), Matrix.Vector(self * other.y), Matrix.Vector(self * other.z))
    }
    
    func project(onto v: Self) -> Self {
        return v * (self.dot(v) / v.dot(v))
    }
    
    func reject(from v: Self) -> Self {
        return self - project(onto: v)
    }
    
    static func * (v: Self, s: Scalar) -> Self {
        return Self(v.storage * s)
    }
    
    static func / (v: Self, s: Scalar) -> Self {
        return Self(v.storage / s)
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
    
    static func * <T>(normal: Self, transform: T) -> Self where T: Transform4x4, T.Scalar == Scalar {
        let c0 = transform[0]!
        let c1 = transform[1]!
        let c2 = transform[2]!
        return Self(normal.dot(c0), normal.dot(c1), normal.dot(c2))
    }
}
