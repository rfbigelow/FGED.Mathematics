import XCTest
@testable import FGED_Mathematics

final class FGED_MathematicsTests: XCTestCase {
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
        let v = Vector3<Double>.ones()
        XCTAssertEqual(v.x, 1.0)
        XCTAssertEqual(v.y, 1.0)
        XCTAssertEqual(v.z, 1.0)
    }
    
    func testZeroes() {
        let v = Vector3<Double>.zeroes()
        XCTAssertEqual(v.x, 0.0)
        XCTAssertEqual(v.y, 0.0)
        XCTAssertEqual(v.z, 0.0)
    }
    
    func testScalarMultiplication() {
        let v = Vector3<Double>.ones() * 2.0
        XCTAssertEqual(v.x, 2.0)
        XCTAssertEqual(v.y, 2.0)
        XCTAssertEqual(v.z, 2.0)
    }
    
    func testScalarDivision() {
        let v = Vector3<Double>.ones() / 2.0
        XCTAssertEqual(v.x, 0.5)
        XCTAssertEqual(v.y, 0.5)
        XCTAssertEqual(v.z, 0.5)
    }
    
    func testMagnitude()  {
        let x = 1.0, y = 2.0, z = 3.0
        let v = Vector3(x, y, z)
        XCTAssertEqual(v.magnitude(), sqrt(x * x + y * y + z * z))
    }
    
    func testNormalize() {
        let v = Vector3(3.0, 3.0, 3.0).normalize()
        XCTAssertEqual(v.x, 1.0)
        XCTAssertEqual(v.y, 1.0)
        XCTAssertEqual(v.z, 1.0)
        XCTAssertEqual(v.magnitude(), 1.0)
    }
    
    static var allTests = [
        ("testDefaultInitializer", testDefaultInitializer),
        ("testInitializer", testInitializer)
    ]
}
