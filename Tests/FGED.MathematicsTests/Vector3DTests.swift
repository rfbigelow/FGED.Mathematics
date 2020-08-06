import XCTest
@testable import FGED_Mathematics

final class Vector3Tests: XCTestCase {
    func testDefaultInitializer() {
        let v = Vector3D<Float>()
        XCTAssertEqual(v.x, Float(0.0))
        XCTAssertEqual(v.y, Float(0.0))
        XCTAssertEqual(v.z, Float(0.0))
    }
    
    func testInitializer() {
        let a = Float(1.0), b = Float(2.0), c = Float(3.0)
        let v = Vector3D<Float>(a, b, c)
        XCTAssertEqual(v.x, a)
        XCTAssertEqual(v.y, b)
        XCTAssertEqual(v.z, c)
    }
    
    func testOnes() {
        let v = Vector3D<Double>.one
        XCTAssertEqual(v.x, 1.0)
        XCTAssertEqual(v.y, 1.0)
        XCTAssertEqual(v.z, 1.0)
    }
    
    func testZeroes() {
        let v = Vector3D<Double>.zero
        XCTAssertEqual(v.x, 0.0)
        XCTAssertEqual(v.y, 0.0)
        XCTAssertEqual(v.z, 0.0)
    }
    
    func testScalarMultiplication() {
        let v = Vector3D<Double>.one * 2.0
        XCTAssertEqual(v.x, 2.0)
        XCTAssertEqual(v.y, 2.0)
        XCTAssertEqual(v.z, 2.0)
    }
    
    func testScalarDivision() {
        let v = Vector3D<Double>.one / 2.0
        XCTAssertEqual(v.x, 0.5)
        XCTAssertEqual(v.y, 0.5)
        XCTAssertEqual(v.z, 0.5)
    }
    
    func testPrefixUnaryMinus() {
        let u = Vector3D(1.0, 2.0, 3.0)
        let v = -u
        let expected = u * -1.0
        XCTAssertEqual(v, expected)
    }
    
    func testMagnitude()  {
        let x = 1.0, y = 2.0, z = 3.0
        let v = Vector3D(x, y, z)
        XCTAssertEqual(v.magnitude(), sqrt(x * x + y * y + z * z))
    }
    
    func testNormalize() {
        let v = Vector3D(3.0, 3.0, 3.0).normalize()
        XCTAssertEqual(v.magnitude(), 1.0)
    }
    
    func testVectorAddition() {
        let u = Vector3D(1.0, 2.0, 3.0)
        let v = Vector3D(4.0, 5.0, 6.0)
        XCTAssertEqual(u + v, Vector3D(u.x + v.x, u.y + v.y, u.z + v.z))
        XCTAssertEqual(u - u, Vector3D.zero)
    }
    
    func testVectorSubstraction() {
        let u = Vector3D(1.0, 2.0, 3.0)
        let v = Vector3D(4.0, 5.0, 6.0)
        XCTAssertEqual(u - v, Vector3D(u.x - v.x, u.y - v.y, u.z - v.z))
        XCTAssertEqual(u + u, u * 2.0)
        XCTAssertEqual(u + u, 2.0 * u)
    }
    
    func testDotProduct() {
        let u = Vector3D(1.0, 2.0, 3.0)
        let v = Vector3D(2.0, 3.0, 4.0)
        let result = u.dot(v)
        XCTAssertEqual(result, 20.0)
    }
    
    func testCrossProduct() {
        let u = Vector3D(1.0, 2.0, 3.0)
        let v = Vector3D(2.0, 3.0, 4.0)
        let result = u.cross(v)
        XCTAssertEqual(result, Vector3D(u.y * v.z - u.z * v.y,
                                       u.z * v.x - u.x * v.z,
                                       u.x * v.y - u.y * v.x))
    }
    
    func testDotAndCrossProducts() {
        let a = Vector3D(1.0, 2.0, 3.0)
        let b = Vector3D(2.0, 3.0, 4.0)
        let result1 = a.dot(a.cross(b))
        let result2 = b.dot(a.cross(b))
        XCTAssertEqual(result1, 0.0)
        XCTAssertEqual(result1, result2)
    }
    
    func testCrossProductMagnitude() {
        let a = Vector3D(2.0, 0.0, 0.0)
        let b = Vector3D(0.0, 2.0, 0.0)
        XCTAssertEqual(a.cross(b).magnitude(), a.magnitude() * b.magnitude() * sin(Double.pi / 2))
    }
    
    func testCrossProductAnticommutivaty() {
        let a = Vector3D(1.0, 2.0, 3.0)
        let b = Vector3D(2.0, 3.0, 4.0)
        XCTAssertEqual(a.cross(b), -b.cross(a))
    }
    
    func testVectorTripleProduct() {
        let a = Vector3D(1.0, 2.0, 3.0)
        let b = Vector3D(2.0, 3.0, 4.0)
        let c = Vector3D(5.0, 4.0, 3.0)
        XCTAssertEqual(a.cross(b.cross(c)), b * a.dot(c) - c * a.dot(b))
    }
    
    func testScalarTripleProduct() {
        let a = Vector3D(1.0, 2.0, 3.0)
        let b = Vector3D(2.0, 3.0, 4.0)
        let c = Vector3D(5.0, 4.0, 3.0)
        let result = scalarTripleProduct(a, b, c)
        XCTAssertEqual(result, b.cross(c).dot(a))
    }
    
    func testProjection() {
        let v = Vector3D(2.0, 3.0, 4.0)
        let px = v.project(onto: Vector3D<Double>.i)
        let py = v.project(onto: Vector3D<Double>.j)
        let pz = v.project(onto: Vector3D<Double>.k)
        XCTAssertEqual(px + py + pz, v)
    }
    
    func testRejection() {
        let a = Vector3D(2.0, 3.0, 4.0)
        let b = Vector3D(3.0, 4.0, 5.0)
        let rejection = a.reject(from: b)
        XCTAssertNotEqual(a.dot(b), 0.0)
        XCTAssertEqual(rejection.dot(b), 0.0)
    }
    
    func testNormalTransform() {
        let v1a = Vector3D(1, 0, 0)
        let v2a = Vector3D(0, 1, 0)
        let m = Matrix3D.makeScale(sx: 2, sy: 1, sz: 1)
        let v1b = m * v1a
        let v2b = m * v2a
        let nb = v1b.cross(v2b)
               
        let h = Transform4D(m, Point3D(SIMD3<Double>()))
        let na = nb * h

        let mInv = m.inverse
        let naExpected = Vector3D(nb.dot(mInv[0]!), nb.dot(mInv[1]!), nb.dot(mInv[2]!))
        XCTAssertEqual(na, naExpected)
    }
    
    static var allTests = [
        ("testDefaultInitializer", testDefaultInitializer),
        ("testInitializer", testInitializer)
    ]
}
