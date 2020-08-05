//
//  QuaternionTests.swift
//  
//
//  Created by Robert Bigelow on 7/25/20.
//

import XCTest
@testable import FGED_Mathematics

final class QuaternionTests: XCTestCase {
    func testingQuaternionMultiplication() {
        let q1 = Quaternion(1, 0, 0, 1)
        let q2 = Quaternion(0, 1, 0, 1)
        let result = q1 * q2
        XCTAssertEqual(result, Quaternion(1, 1, 1, 1))
    }
    
    func testingRotation() {
        let v = Vector3D(1, 0, 0)
        let q1 = Quaternion(0, 1, 0, 1)
        let result1 = v.transform(withQuaternion: q1)

        let v_q = Quaternion(v: v, s: 0)
        let sandwich = q1 * v_q * q1.conjugate
        XCTAssertEqual(result1, sandwich.vectorPart)
    }
    
    func testRotationMatrix() {
        let m = Matrix3D.makeRotationZ(radians: Double.pi / 2)
        var q = Quaternion<Double>()
        q.rotationMatrix = m
        let m1 = q.rotationMatrix
        for i in 0..<3 {
            for j in 0..<3 {
                XCTAssertEqual(m[i,j]!, m1[i,j]!, accuracy: Double.ulpOfOne)
            }
        }
        
        let v = Vector3D(1, 0, 0)
        let vRot = m * v
        let v1Rot = m1 * v
        for i in 0..<3 {
            XCTAssertEqual(vRot[i], v1Rot[i], accuracy: Double.ulpOfOne)
        }
    }
}
