//
//  CIImage+Helper.swift
//  DocumentDetectionSDK
//
//  Created by Alejandro Maldonado on 11/07/24.
//

import Foundation
import UIKit

extension CIImage {
    
    func saveAsPngFile() async {
        let image = UIImage(ciImage: self)
        if let data = image.pngData() {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = paths[0].appendingPathComponent("snapshot-\(Date().timeIntervalSince1970).png")
            try? data.write(to: filename)
            print("Image saved to '\(filename)'")
        }
    }
    
    //*************************************************************************
    
    func cropEnclosedIn(corners:[CGPoint]) -> UIImage? {
        // It needs at least 4 corners
        guard corners.count >= 4 else {
            return nil;
        }
        // Build the path to crop
        let path = UIBezierPath()
        path.move(to: corners.first!)
        for i in 1..<corners.count {
            path.addLine(to: corners[i])
        }
        path.close()
        
        let image = UIImage(ciImage: self)
        let r: CGRect = path.cgPath.boundingBox
        UIGraphicsBeginImageContextWithOptions(r.size, false, image.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -r.origin.x, y: -r.origin.y)
            context.addPath(path.cgPath)
            context.clip()
        }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return croppedImage

        
    }
    
    //*************************************************************************
    
    func perspectiveCorrection(corners:[CGPoint]) -> UIImage? {
        
        // It needs at least 4 corners
        guard corners.count >= 4 else {
            return nil;
        }
        
        let cornersSorted = CGPoint.sortCorners(corners: corners)

        guard let filter = CIFilter(name: "CIPerspectiveCorrection") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(self, forKey: kCIInputImageKey)
        filter.setValue(cornersSorted[0].toCartesian(extent: self.extent).ciVector(), forKey: "inputTopLeft")
        filter.setValue(cornersSorted[1].toCartesian(extent: self.extent).ciVector(), forKey: "inputBottomLeft")
        filter.setValue(cornersSorted[2].toCartesian(extent: self.extent).ciVector(), forKey: "inputBottomRight")
        filter.setValue(cornersSorted[3].toCartesian(extent: self.extent).ciVector(), forKey: "inputTopRight")
        
        if let outputImage = filter.outputImage {
            guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return nil }
            return UIImage(cgImage: cgImage)
        }
        

        return nil
    }
    
    //*************************************************************************
    
}
