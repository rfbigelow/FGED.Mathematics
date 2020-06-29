import RealModule

public struct Vector3<T: SIMDScalar & FloatingPoint>: Equatable {
    var storage: SIMD3<T>
    
    @inlinable
    public static var one: Vector3 {
        return Vector3(T(1), T(1), T(1))
    }
    
    @inlinable
    public static var zero: Vector3 {
        return Vector3()
    }
    
    @inlinable
    public static var i: Vector3 {
        return Vector3(T(1), T(0), T(0))
    }
    
    @inlinable
    public static var j: Vector3 {
        return Vector3(T(0), T(1), T(0))
    }
    
    @inlinable
    public static var k: Vector3 {
        return Vector3(T(0), T(0), T(1))
    }

    public var x: T {
        get { storage.x }
        set { storage.x = newValue }
    }
    
    public var y: T {
        get { storage.y }
        set { storage.y = newValue }
    }
    
    public var z: T {
        get { storage.z }
        set { storage.z = newValue }
    }
    
    public init() {
        storage = SIMD3()
    }
    
    public init(_ x: T, _ y: T, _ z: T) {
        storage = SIMD3(x, y, z)
    }
    
    public init(_ simd: SIMD3<T>) {
        self.storage = simd
    }
    
    public subscript(index: Int) -> T {
        get {
            return storage[index];
        }
        set {
            storage[index] = newValue
        }
    }
    
    public func magnitude() -> T {
        return (storage * storage).sum().squareRoot()
    }
    
    @inlinable
    public func normalize() -> Vector3 {
        return self / magnitude()
    }
}

// scalar operators
extension Vector3 {
    public static func * (v: Vector3, s: T) -> Vector3 {
        return Vector3(v.storage * s)
    }
    
    @inlinable
    public static func / (v: Vector3, s: T) -> Vector3 {
        let inverse = T(1) / s
        return v * inverse
    }
}

// vector operators
extension Vector3 {
    public static func + (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(left.storage + right.storage)
    }
    
    public static func - (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(left.storage - right.storage)
    }
    
    public static prefix func - (v: Vector3) -> Vector3 {
        return Vector3(-v.storage)
    }
}

// vector multiplication
extension Vector3 {
    public func dotProduct(_ other: Vector3) -> T {
        return (self.storage * other.storage).sum()
    }

    @inlinable
    public func crossProduct(_ other: Vector3) -> Vector3 {
        return Vector3(SIMD3(y, z, x) * SIMD3(other.z, other.x, other.y) - SIMD3(z, x, y) * SIMD3(other.y, other.z, other.x))
    }
    
    public func outerProduct(_ other: Vector3) -> Matrix3D<T> {
        return Matrix3D([self.storage * other.x, self.storage * other.y, self.storage * other.z])
    }
}

public func scalarTripleProduct<T: SIMDScalar & FloatingPoint>(_ a: Vector3<T>, _ b: Vector3<T>, _ c: Vector3<T>) -> T {
    return a.crossProduct(b).dotProduct(c)
}

// vector projection
extension Vector3 {
    @inlinable
    public func project(onto v: Vector3) -> Vector3 {
        return v * (self.dotProduct(v) / v.dotProduct(v))
    }
    
    @inlinable
    public func reject(from v: Vector3) -> Vector3 {
        return self - project(onto: v)
    }
}

extension Float32 {
    @inlinable
    static func * (s: Float32, v: Vector3<Float32>) -> Vector3<Float32> {
        return v * s
    }
}

extension Float64 {
    @inlinable
    static func * (s: Float64, v: Vector3<Float64>) -> Vector3<Float64> {
        return v * s
    }
}
