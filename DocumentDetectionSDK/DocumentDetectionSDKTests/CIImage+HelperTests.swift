//
//  CIImage+HelperTests.swift
//  DocumentDetectionSDKTests
//
//  Created by Alejandro Maldonado on 13/07/24.
//

import XCTest
@testable import DocumentDetectionSDK

final class CIImage_HelperTests: XCTestCase {

    static var imageWithDocument1: CIImage?
    static var imageWithDocument2: CIImage?
    static var imageCorrected1: UIImage?
    static var imageCropped2: UIImage?

    override class func setUp() {
        // This is the setUp() class method.
        // XCTest calls it before calling the first test method.
        // Set up any overall initial state here.
        guard let url = Bundle.main.url(forResource:"imageWithDocument1", withExtension:"png") else { return }
        imageWithDocument1 = CIImage(contentsOf: url)
        
        guard let url = Bundle.main.url(forResource:"imageWithDocument2", withExtension:"png") else { return }
        imageWithDocument2 = CIImage(contentsOf: url)

        guard let url = Bundle.main.url(forResource:"imageCorrected1", withExtension:"png") else { return }
        imageCorrected1 = UIImage(ciImage:CIImage(contentsOf: url)!)

        guard let url = Bundle.main.url(forResource:"imageCropped2", withExtension:"png") else { return }
        imageCropped2 = UIImage(ciImage:CIImage(contentsOf: url)!)

    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testCropEnclosedIn() {
     
        let corners = [ CGPoint(x: 292, y: 466),
                        CGPoint(x: 870, y: 492),
                        CGPoint(x: 931, y: 1414),
                        CGPoint(x: 124, y: 1352) ]
        let expectedSize = CGSize(width: 807, height: 948)
        let croppedImage = CIImage_HelperTests.imageWithDocument2?.cropEnclosedIn(corners: corners)
        XCTAssertNotNil(croppedImage, "Cropped image not found")
        XCTAssertEqual(croppedImage?.size, expectedSize, "Image dimensions are different")
    }
    
    
    func testPerspectiveCorrection() {
        let corners = [ CGPoint(x: 314, y: 472),
                        CGPoint(x: 203, y: 1272),
                        CGPoint(x: 896, y: 1309),
                        CGPoint(x: 851, y: 488) ]
        let expectedSize = CGSize(width: 707, height: 1063)
        let transformedImage = CIImage_HelperTests.imageWithDocument1?.perspectiveCorrection(corners: corners)
        XCTAssertNotNil(transformedImage, "Transformed image not found")
        XCTAssertEqual(transformedImage?.size, expectedSize, "Image dimensions are different")
    }

}
