//
//  CGPoint+HelperTests.swift
//  DocumentDetectionSDKTests
//
//  Created by Alejandro Maldonado on 13/07/24.
//

import XCTest
@testable import DocumentDetectionSDK

final class CGPoint_HelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransformCoordinates() {
        let point = CGPoint(x: 314, y: 472)
        let from = CGSize(width: 1080, height: 1920)    // iPhone 11 camera resolution
        let to = CGSize(width: 414, height: 896)        // iPhone 11 screen resolution (in points)
        let expected = CGPoint(x: 101.53333333333333, y: 220.26666666666668)
        let result = point.transformCoordinates(from: from, to: to)
        XCTAssertEqual(result, expected)
    }
    
    func testCiVector() {
        let point = CGPoint(x: 314, y: 472)
        let expected = CIVector(x: 314, y: 472)
        let result = point.ciVector()
        XCTAssertEqual(result, expected)
    }
    
    func testToCartesian() {
        let point = CGPoint(x: 314, y: 472)
        let imageExtent = CGRect(x: 0, y: 0, width: 1080, height: 1920)
        let expected = CGPoint(x: 314, y: 1448)
        let result = point.toCartesian(extent: imageExtent)
        XCTAssertEqual(result, expected)
    }
    
    func testSortCorners() {
        let corners = [ CGPoint(x: 314, y: 472),
                        CGPoint(x: 851, y: 488),
                        CGPoint(x: 896, y: 1309),
                        CGPoint(x: 203, y: 1272) ]

        let expectedCorners = [ CGPoint(x: 314, y: 472),
                                CGPoint(x: 203, y: 1272),
                                CGPoint(x: 896, y: 1309),
                                CGPoint(x: 851, y: 488) ]
        
        let result = CGPoint.sortCorners(corners: corners)

        XCTAssertEqual(result, expectedCorners, "Corners are different")


    }
    

}
