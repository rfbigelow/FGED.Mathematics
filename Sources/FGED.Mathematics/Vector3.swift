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
    
    public init(_ a: T, _ b: T, _ c: T) {
        storage = SIMD3(a, b, c)
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

extension Vector3 {
    public static func * (v: Vector3, s: T) -> Vector3 {
        return Vector3(v.storage * s)
    }
    
    @inlinable
    public static func / (v: Vector3, s: T) -> Vector3 {
        let inverse = T(1) / s
        return v * inverse
    }
    
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

extension Float32 {
    static func * (s: Float32, v: Vector3<Float32>) -> Vector3<Float32> {
        return v * s
    }
}

extension Float64 {
    static func * (s: Float64, v: Vector3<Float64>) -> Vector3<Float64> {
        return v * s
    }
}
