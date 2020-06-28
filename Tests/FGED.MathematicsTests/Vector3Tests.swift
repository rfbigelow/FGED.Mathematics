import XCTest
@testable import FGED_Mathematics

final class Vector3Tests: XCTestCase {
    func testDefaultInitializer() {
        let v = Vector3<Float>()
        XCTAssertEqual(v.x, Float(0.0))
        XCTAssertEqual(v.y, Float(0.0))
        XCTAssertEqual(v.z, Float(0.0))
    }
    
    func testInitializer() {
        let a = Float(1.0), b = Float(2.0), c = Float(3.0)
        let v = Vector3<Float>(a, b, c)
        XCTAssertEqual(v.x, a)
        XCTAssertEqual(v.y, b)
        XCTAssertEqual(v.z, c)
    }
    
    func testOnes() {
        let v = Vector3<Double>.one
        XCTAssertEqual(v.x, 1.0)
        XCTAssertEqual(v.y, 1.0)
        XCTAssertEqual(v.z, 1.0)
    }
    
    func testZeroes() {
        let v = Vector3<Double>.zero
        XCTAssertEqual(v.x, 0.0)
        XCTAssertEqual(v.y, 0.0)
        XCTAssertEqual(v.z, 0.0)
    }
    
    func testScalarMultiplication() {
        let v = Vector3<Double>.one * 2.0
        XCTAssertEqual(v.x, 2.0)
        XCTAssertEqual(v.y, 2.0)
        XCTAssertEqual(v.z, 2.0)
    }
    
    func testScalarDivision() {
        let v = Vector3<Double>.one / 2.0
        XCTAssertEqual(v.x, 0.5)
        XCTAssertEqual(v.y, 0.5)
        XCTAssertEqual(v.z, 0.5)
    }
    
    func testPrefixUnaryMinus() {
        let u = Vector3(1.0, 2.0, 3.0)
        let v = -u
        let expected = u * -1.0
        XCTAssertEqual(v, expected)
    }
    
    func testMagnitude()  {
        let x = 1.0, y = 2.0, z = 3.0
        let v = Vector3(x, y, z)
        XCTAssertEqual(v.magnitude(), sqrt(x * x + y * y + z * z))
    }
    
    func testNormalize() {
        let v = Vector3(3.0, 3.0, 3.0).normalize()
        XCTAssertEqual(v.magnitude(), 1.0)
    }
    
    func testVectorAddition() {
        let u = Vector3(1.0, 2.0, 3.0)
        let v = Vector3(4.0, 5.0, 6.0)
        XCTAssertEqual(u + v, Vector3(u.x + v.x, u.y + v.y, u.z + v.z))
        XCTAssertEqual(u - u, Vector3.zero)
    }
    
    func testVectorSubstraction() {
        let u = Vector3(1.0, 2.0, 3.0)
        let v = Vector3(4.0, 5.0, 6.0)
        XCTAssertEqual(u - v, Vector3(u.x - v.x, u.y - v.y, u.z - v.z))
        XCTAssertEqual(u + u, u * 2.0)
        XCTAssertEqual(u + u, 2.0 * u)
    }
    
    func testDotProduct() {
        let u = Vector3(1.0, 2.0, 3.0)
        let v = Vector3(2.0, 3.0, 4.0)
        let result = u .* v
        XCTAssertEqual(result, 20.0)
    }
    
    static var allTests = [
        ("testDefaultInitializer", testDefaultInitializer),
        ("testInitializer", testInitializer)
    ]
}
