import RealModule

struct Vector3<T: SIMDScalar & FloatingPoint> {
    var storage: SIMD3<T>
    
    var x: T {
        get { storage.x }
        set { storage.x = newValue }
    }
    
    var y: T {
        get { storage.y }
        set { storage.y = newValue }
    }
    
    var z: T {
        get { storage.z }
        set { storage.z = newValue }
    }
    
    init() {
        storage = SIMD3()
    }
    
    init(_ a: T, _ b: T, _ c: T) {
        storage = SIMD3(a, b, c)
    }
    
    init(_ simd: SIMD3<T>) {
        self.storage = simd
    }
    
    subscript(index: Int) -> T {
        get {
            return storage[index];
        }
        set {
            storage[index] = newValue
        }
    }
    
    func magnitude() -> T {
        return (storage * storage).sum().squareRoot()
    }
    
    func normalize() -> Vector3 {
        return self / magnitude()
    }
}

extension Vector3 {
    static func ones() -> Vector3 {
        return Vector3(T(1), T(1), T(1))
    }
    
    static func zeroes() -> Vector3 {
        return Vector3()
    }
}

extension Vector3 {
    static func * (v: Vector3, s: T) -> Vector3 {
        return Vector3(v.storage * s)
    }
    
    static func / (v: Vector3, s: T) -> Vector3 {
        let inverse = T(1) / s
        return Vector3(v.storage * inverse)
    }
}
