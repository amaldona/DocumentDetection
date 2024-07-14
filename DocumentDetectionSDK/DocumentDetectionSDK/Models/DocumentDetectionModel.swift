//
//  DocumentDetectionModel.swift
//  DocumentDetectionSDK
//
//  Created by Alejandro Maldonado on 13/07/24.
//

import Foundation

public enum DocumentDetectionError: Error {
    case ImageNotFound
    case CropFailed
    case TransformFailed
}

public typealias CompletionCallback = ((_ image: UIImage?, _ error: DocumentDetectionError?) -> Void)

//*************************************************************************

class DocumentDetectionModel {
    
    private var corners: [CGPoint] = []
    private var image: CIImage?
    
    //*************************************************************************
    
    func saveSnapshotToFile() {
        Task {
            await image?.saveAsPngFile()
        }
    }
    
    //*************************************************************************
    
    func detectDocumentFrom(image: CIImage?, completion:((_ corners:[CGPoint], _ imageSize:CGSize) -> Void)) {
        // Check if there is a valid image
        guard image != nil else {
            completion([], CGSize.zero)
            return
        }
        
        let result = OpenCVWrapper.findDocumentCorners(image!) as! [CGPoint]

        if (!result.isEmpty) {
            self.image = image
            self.corners = CGPoint.sortCorners(corners: result)
            completion(self.corners, image!.extent.size)
        }
    }
    
    //*************************************************************************
    
    func generateCroppedImage(_ completion: @escaping CompletionCallback) {

        // Check if there is a valid image
        guard image != nil else {
            completion(nil, .ImageNotFound)
            return
        }
        
        // Generate transformed image
        guard let croppedImage = image?.cropEnclosedIn(corners: corners) else {
            completion(nil, .CropFailed)
            return
        }

        // Submit
        completion(croppedImage, nil)

    }
    
    //*************************************************************************
    
    func generateCorrectedImage(_ completion: @escaping CompletionCallback) {
        
        // Check if there is a valid image
        guard image != nil else {
            completion(nil, .ImageNotFound)
            return
        }
        
        // Generate transformed image
        guard let correctedImage = image?.perspectiveCorrection(corners: corners) else {
            completion(nil, .TransformFailed)
            return
        }

        // Submit
        completion(correctedImage, nil)
        
    }

    
}
