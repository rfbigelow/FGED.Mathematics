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
    
    func testIdentity() {
        let m = Matrix3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
        let i = Matrix3D<Double>.identity
        XCTAssertEqual(m * i, m)
    }
    
    func testInverse() {
        let m = Matrix3D(1.0, 0.0, 0.0, 4.0, 1.0, 0.0, 0.0, 5.0, 1.0)
        let mInverse = m.inverse
        let i = Matrix3D<Double>.identity
        let result1 = m * mInverse
        XCTAssertEqual(result1, i)
        
        let result2 = mInverse * m
        XCTAssertEqual(result2, i)
        
        XCTAssertEqual(i.inverse, i)
    }
    
    func testMatrixRotationX(){
        let v = Vector3(0.0, 2.0, 0.0)
        let rotX90 = Matrix3D.makeRotationX(radians: Double.pi / 2.0)
        let rotated = rotX90 * v
        XCTAssertEqual(rotated.z, v.y)
    }

    func testMatrixRotationY(){
        let v = Vector3(0.0, 0.0, 2.0)
        let rotX90 = Matrix3D.makeRotationY(radians: Double.pi / 2.0)
        let rotated = rotX90 * v
        XCTAssertEqual(rotated.x, v.z)
    }
    
    func testMatrixRotationZ(){
        let v = Vector3(2.0, 0.0, 0.0)
        let rotX90 = Matrix3D.makeRotationZ(radians: Double.pi / 2.0)
        let rotated = rotX90 * v
        XCTAssertEqual(rotated.y, v.x)
    }
    
    func testMatrixRotationArbitrary(){
        let theta = Double.pi
        let rotX = Matrix3D.makeRotationX(radians: theta)
        let rotY = Matrix3D.makeRotationY(radians: theta)
        let rotZ = Matrix3D.makeRotationZ(radians: theta)
        
        let resultX = Matrix3D.makeRotation(radians: theta, a: Vector3(1.0, 0.0, 0.0))
        XCTAssertEqual(resultX, rotX)
        
        let resultY = Matrix3D.makeRotation(radians: theta, a: Vector3(0.0, 1.0, 0.0))
        XCTAssertEqual(resultY, rotY)
        
        let resultZ = Matrix3D.makeRotation(radians: theta, a: Vector3(0.0, 0.0, 1.0))
        XCTAssertEqual(resultZ, rotZ)
    }
    
    func testReflection(){
        let a = Vector3(1.0, 0.0, 0.0)
        let v = Vector3(1.0, 0.0, 0.0)
        let reflection = Matrix3D.makeReflection(a: a)
        let reflected = reflection * v
        XCTAssertEqual(reflected, -v)
    }
    
    func testInvolution(){
        let a = Vector3(1.0, 0.0, 0.0)
        let reflection = Matrix3D.makeReflection(a: a)
        let involution = Matrix3D.makeInvolution(a: a)
        XCTAssertEqual(involution, -reflection)
        XCTAssertEqual(involution * involution, Matrix3D.identity)
    }
    
    func testScaling(){
        let sx = 2.0
        let sy = 3.0
        let sz = 4.0
        let expected = Matrix3D([Vector3(sx, 0, 0), Vector3(0, sy, 0), Vector3(0, 0, sz)])
        let scaling = Matrix3D.makeScale(sx: sx, sy: sy, sz: sz)
        XCTAssertEqual(scaling, expected)
    }
    
    func testUniformScaling(){
        let s = 2.0
        let expected = Matrix3D.identity * s
        let uniform = Matrix3D.makeUniformScale(s: s)
        XCTAssertEqual(uniform, expected)
    }
    
    func testScalingAlongVector(){
        let s = 3.0
        let v = Vector3(0.0, 1.0, 0.0)
        let expected = Matrix3D(1.0, 0.0, 0.0,
                                0.0, s, 0.0,
                                0.0, 0.0, 1.0)
        let scaling = Matrix3D.makeScale(s: s, a: v)
        XCTAssertEqual(scaling, expected)
    }
}
