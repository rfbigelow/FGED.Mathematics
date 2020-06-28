//
//  Matrix3DTests.swift
//  
//
//  Created by Robert Bigelow on 6/27/20.
//

import XCTest
@testable import FGED_Mathematics

final class Matrix3DTests: XCTestCase {
    func testDefaultInitializer() {
        let A = Matrix3D<Double>()
        
        for c in 0..<3 {
            for r in 0..<3 {
                XCTAssertEqual(A[r, c], 0.0)
            }
        }
        
        for c in 0..<3 {
            XCTAssertEqual(A[c], Vector3<Double>())
        }
    }
    
    func testArrayInitializer() {
        let expected = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
        let A = Matrix3D(expected)
        for r in 0..<3 {
            for c in 0..<3 {
                XCTAssertEqual(A[r, c], expected[r * 3 + c])
            }
        }
    }
    
    func testAddition() {
        let m1Data = Array((1...9).map({Double($0)}))
        let m2Data = Array((2...10).map({Double($0)}))
        let expected = zip(m1Data, m2Data).map({$0.0 + $0.1})
        
        let m1 = Matrix3D(m1Data)
        let m2 = Matrix3D(m2Data)
        let result = m1 + m2
        
        for r in 0..<3 {
            for c in 0..<3 {
                XCTAssertEqual(result[r, c], expected[r * 3 + c])
            }
        }
    }

    func testSubtraction() {
        let m1Data = Array((1...9).map({Double($0)}))
        let m2Data = Array((2...10).map({Double($0)}))
        let expected = zip(m1Data, m2Data).map({$0.0 - $0.1})
        
        let m1 = Matrix3D(m1Data)
        let m2 = Matrix3D(m2Data)
        let result = m1 - m2
        
        for r in 0..<3 {
            for c in 0..<3 {
                XCTAssertEqual(result[r, c], expected[r * 3 + c])
            }
        }
    }
    
    func testScalarMultiplication() {
        let data = Array((1...9).map({Double($0)}))
        let s = 3.0
        let expected = data.map({$0 * s})
        
        let m = Matrix3D(data)
        let result = m * s
        
        for r in 0..<3 {
            for c in 0..<3 {
                XCTAssertEqual(result[r, c], expected[r * 3 + c])
            }
        }
    }
    
    func testMatrixMultiplicationWithIdentity() {
        let m1 = Matrix3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
        let m2 = Matrix3D(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0)
        let result = m1 * m2
        XCTAssertEqual(result, m1)
    }
    
    func testMatrixVectorMultiplication() {
        let m = Matrix3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
        let v = Vector3(1.0, 2.0, 3.0)
        let result = m * v
        let expected = Vector3(m[0, 0] * v.x + m[0, 1] * v.y + m[0, 2] * v.z,
                               m[1, 0] * v.x + m[1, 1] * v.y + m[1, 2] * v.z,
                               m[2, 0] * v.x + m[2, 1] * v.y + m[2, 2] * v.z)
        XCTAssertEqual(result, expected)
    }
}
