//
//  File.swift
//  
//
//  Created by Robert Bigelow on 7/19/20.
//

import XCTest
@testable import FGED_Mathematics

final class Transform4DDTests: XCTestCase {
    func testInverse(){
        let t = Transform4D(Matrix3D<Double>.identity, Point3D(1, 2, 3))
        let p = Point3D<Double>.zero
        let translatedP = t * p
        XCTAssertEqual(translatedP, Point3D(1, 2, 3))
        
        let inverseT = t.inverse
        let recoveredP = inverseT * translatedP
        XCTAssertEqual(p, recoveredP)
    }
}
