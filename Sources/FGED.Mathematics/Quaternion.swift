//
//  File.swift
//  
//
//  Created by Robert Bigelow on 7/23/20.
//

import RealModule

struct Quaternion<T: Real & SIMDScalar & ExpressibleByFloatLiteral>: Equatable {
    var storage: SIMD4<T>
    
    var x: T { return storage.x }
    var y: T { return storage.y }
    var z: T { return storage.z }
    var w: T { return storage.w }
    
    var conjugate: Quaternion {
        return Quaternion(-self.x, -self.y, -self.z, self.w)
    }
    
    var magnitude: T {
        var result = (self.storage * self.storage).sum()
        result.formSquareRoot()
        return result
    }
    
    var rotationMatrix: Matrix3D<T> {
        get {
            let v = self.storage[SIMD3<Int>(0, 1, 2)]
            let v2 = v * v
            let xxy = v[SIMD3<Int>(0, 0, 1)]
            let yzz = v[SIMD3<Int>(1, 2, 2)]
            let xxyyzz = xxy * yzz
            let vw = v * w
            return Matrix3D<T>(
                T(1) - T(2) * (v2.y + v2.z), T(2) * (xxyyzz[0] - vw.z), T(2) * (xxyyzz[1] + vw.y),
                T(2) * (xxyyzz[0] + vw.z), T(1) - T(2) * (v2.x + v2.z), T(2) * (xxyyzz[2] - vw.x),
                T(2) * (xxyyzz[1] - vw.y), T(2) * (xxyyzz[2] + vw.x), T(1) - T(2) * (v2.x + v2.y))
        }
        set {
            let diag = SIMD3<T>(newValue[0, 0]!, newValue[1, 1]!, newValue[2, 2]!)
            let sum = diag.sum()
            
            if sum > T(0) {
                storage.w = (sum + T(1)).squareRoot() * 0.5
                let f = 0.25 / w
                storage.x = (newValue[2, 1]! - newValue[1, 2]!) * f
                storage.y = (newValue[0, 2]! - newValue[2, 0]!) * f
                storage.z = (newValue[1, 0]! - newValue[0, 1]!) * f
            }
            else if (diag.x > diag.y) && (diag.x > diag.z) {
                storage.x = (diag.x - diag.y - diag.z + T(1)).squareRoot() * 0.5
                let f = 0.25 / x
                storage.y = (newValue[1, 0]! + newValue[0, 1]!) * f
                storage.z = (newValue[0, 2]! + newValue[2, 0]!) * f
                storage.w = (newValue[2, 1]! - newValue[1, 2]!) * f
            }
            else if diag.y > diag.z {
                storage.y = (diag.y - diag.x - diag.z + T(1)).squareRoot() * 0.5
                let f = 0.25 / y
                storage.x = (newValue[1, 0]! + newValue[0, 1]!) * f
                storage.z = (newValue[2, 1]! + newValue[1, 2]!) * f
                storage.w = (newValue[0, 2]! - newValue[2, 0]!) * f
            }
            else {
                storage.z = (diag.z - diag.x - diag.y + T(1)).squareRoot() * 0.5
                let f = 0.25 / z
                storage.x = (newValue[0, 2]! + newValue[2, 0]!) * f
                storage.y = (newValue[2, 1]! + newValue[1, 2]!) * f
                storage.w = (newValue[1, 0]! - newValue[0, 1]!) * f
            }
        }
    }
    
    var vectorPart: Vector3D<T> {
        return Vector3D<T>(self.storage[SIMD3<Int>(0, 1, 2)])
    }
    
    init() {
        storage = SIMD4<T>()
    }
    
    init(_ x: T, _ y: T, _ z: T, _ w: T) {
        storage = SIMD4(x, y, z, w)
    }
    
    init(_ simd: SIMD4<T>) {
        storage = simd
    }
    
    init<Vector>(v: Vector, s: T) where Vector: Vector3, Vector.Scalar == T {
        storage = SIMD4(v.x, v.y, v.z, s)
    }
    
    static prefix func -(q: Quaternion) -> Quaternion {
        return Quaternion(-q.x, -q.y, -q.z, -q.w)
    }
    
    static func * (left: Quaternion, right: T) -> Quaternion {
        return Quaternion(left.storage * right)
    }
    
    static func - (left: Quaternion, right: Quaternion) -> Quaternion {
        return Quaternion(left.storage - right.storage)
    }

    static func + (left: Quaternion, right: Quaternion) -> Quaternion {
        return Quaternion(left.storage + right.storage)
    }

    static func * (left: Quaternion, right: Quaternion) -> Quaternion {
        let lwrxyzw = right.storage * left.w
        let lxrwzyx = right.storage.wzyx * left.x
        let lyrzwxy = right.storage.zwxy * left.y
        let lzryxwz = right.storage.yxwz * left.z
        let lxrwzyxAdd = lxrwzyx.replacing(with: 0, where: SIMDMask([false, true, false, true]))
        let lxrwzyxSub = lxrwzyx.replacing(with: 0, where: SIMDMask([true, false, true, false]))
        let lyrzwxyAdd = lyrzwxy.replacing(with: 0, where: SIMDMask([false, false, true, true]))
        let lyrzwxySub = lyrzwxy.replacing(with: 0, where: SIMDMask([true, true, false, false]))
        let lzryxwzAdd = lzryxwz.replacing(with: 0, where: SIMDMask([true, false, false, true]))
        let lzryxwzSub = lzryxwz.replacing(with: 0, where: SIMDMask([false, true, true, false]))
        var result = lwrxyzw
        result += lxrwzyxAdd
        result -= lxrwzyxSub
        result += lyrzwxyAdd
        result -= lyrzwxySub
        result += lzryxwzAdd
        result -= lzryxwzSub
        return Quaternion(result)
    }
}

extension Vector3D where T: ExpressibleByFloatLiteral {
    func transform(withQuaternion q: Quaternion<T>) -> Self {
        let b = q.vectorPart
        let b2 = (b.storage * b.storage).sum()
        let dot = self.dot(b)
        let cross = b.cross(self)
        let t1 = self * (q.w * q.w - b2)
        let t2 = b * (dot * T(2))
        let t3 = cross * (q.w * T(2))
        return (t1 + t2 + t3)
    }
}
