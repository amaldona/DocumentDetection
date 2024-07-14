//
//  DocumentDetectionModelTests.swift
//  DocumentDetectionSDKTests
//
//  Created by Alejandro Maldonado on 13/07/24.
//

import XCTest
@testable import DocumentDetectionSDK

final class DocumentDetectionModelTests: XCTestCase {

    let model: DocumentDetectionModel = DocumentDetectionModel()
    static var imageWithoutDocument: CIImage?
    static var imageWithDocument1: CIImage?
    static var imageWithDocument2: CIImage?
    
    override class func setUp() {
        // This is the setUp() class method.
        // XCTest calls it before calling the first test method.
        // Set up any overall initial state here.
        guard let url = Bundle.main.url(forResource:"imageWithoutDocument", withExtension:"png") else { return }
        imageWithoutDocument = CIImage(contentsOf: url)

        guard let url = Bundle.main.url(forResource:"imageWithDocument1", withExtension:"png") else { return }
        imageWithDocument1 = CIImage(contentsOf: url)
        
        guard let url = Bundle.main.url(forResource:"imageWithDocument2", withExtension:"png") else { return }
        imageWithDocument2 = CIImage(contentsOf: url)
    }

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testDetectCornersInImageWithoutDocument() {
        model.detectDocumentFrom(image: DocumentDetectionModelTests.imageWithoutDocument) { corners, imageSize in
            XCTAssertTrue(corners.isEmpty, "Corners should not be detected")
            XCTAssertEqual(imageSize, CGSize.zero, "imageSize should be zero")
        }
    }

    func testDetectCornersInImageWithDocument1() {
        model.detectDocumentFrom(image: DocumentDetectionModelTests.imageWithDocument1) { corners, imageSize in
            XCTAssertFalse(corners.isEmpty, "Corners not detected")
            XCTAssertNotEqual(imageSize, CGSize.zero, "imageSize must be non-zero")
            
            let expectedCorners = [ CGPoint(x: 314, y: 472),
                                    CGPoint(x: 203, y: 1272),
                                    CGPoint(x: 896, y: 1309),
                                    CGPoint(x: 851, y: 488) ]
            XCTAssertEqual(corners, expectedCorners, "Corners are different")
            
            let expectedImageSize = CGSize(width: 1080, height: 1920)
            XCTAssertEqual(imageSize, expectedImageSize, "imageSize is different")

            model.generateCorrectedImage { image, error in
                XCTAssertNotNil(image, "Image not found")
                XCTAssertNil(error, "Error generating image: \(String(describing: error))")
            }
            
        }
    }

    func testDetectCornersInImageWithDocument2() {
        model.detectDocumentFrom(image: DocumentDetectionModelTests.imageWithDocument2) { corners, imageSize in
            XCTAssertFalse(corners.isEmpty, "Corners not detected")
            XCTAssertNotEqual(imageSize, CGSize.zero, "imageSize must be non-zero")

            let expectedCorners = [ CGPoint(x: 292, y: 466),
                                    CGPoint(x: 124, y: 1352),
                                    CGPoint(x: 931, y: 1414),
                                    CGPoint(x: 870, y: 492) ]
            XCTAssertEqual(corners, expectedCorners, "Corners are different")
            
            let expectedImageSize = CGSize(width: 1080, height: 1920)
            XCTAssertEqual(imageSize, expectedImageSize, "imageSize is different")

            model.generateCroppedImage { image, error in
                XCTAssertNotNil(image, "Image not found")
                XCTAssertNil(error, "Error generating image: \(String(describing: error))")
            }
            
        }
    }



}
