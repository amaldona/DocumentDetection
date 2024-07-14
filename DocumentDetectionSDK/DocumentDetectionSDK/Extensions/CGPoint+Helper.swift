//
//  CGPoint+Helper.swift
//  DocumentDetection
//
//  Created by Alejandro Maldonado on 10/07/24.
//

import Foundation
import UIKit

extension CGPoint {
    
    func transformCoordinates(from: CGSize, to: CGSize) -> CGPoint {
        // Calculate for AVLayerVideoGravityResizeAspectFill (TODO: AspectFit support, but not required for this test)
        let aspectRatioCoord1 = from.height / from.width
        let aspectRatioCoord2 = to.height / to.width
        
        if (aspectRatioCoord1 < aspectRatioCoord2)
        {
            // 'from' width is bigger
            let width = (from.width * to.height) / from.height
            let height = to.height
            let xOffset = (width - to.width) / 2
            return CGPoint(x: ((self.x * width) / from.width) - xOffset,
                           y: (self.y * height) / from.height)
        } else {
            // 'from' height is bigger
            let width = to.width
            let height = (from.height * to.width) / from.width
            let yOffset = (height - to.height) / 2
            return CGPoint(x: ((self.x * width) / from.width) - yOffset,
                           y: (self.y * height) / from.height)
        }
        
    }
    
    //*************************************************************************
    
    func ciVector() -> CIVector {
        return CIVector(cgPoint: self)
    }
    
    //*************************************************************************

    func toCartesian(extent:CGRect) -> CGPoint {
        return CGPoint(x: self.x, y: extent.height - self.y)
    }
    
    //*************************************************************************

    static func sortCorners(corners:[CGPoint]) -> [CGPoint] {
        // Based on the method described here: https://stackoverflow.com/a/64659569
        
        // The array indices will be:
        //
        //  [0]*****[3]
        //   *       *
        //   *       *
        //  [1]*****[2]
        //

        // It needs at least 4 corners
        guard corners.count >= 4 else {
            return [];
        }

        var cornersSorted: [CGPoint] = [ CGPoint.zero, CGPoint.zero, CGPoint.zero, CGPoint.zero ]
        var remainingCorners: [CGPoint] = [];

        let sumArray = corners.map { $0.x + $0.y }
        let topLeftIndex = sumArray.firstIndex(of: sumArray.min()!) ?? 0
        let bottomRightIndex = sumArray.firstIndex(of: sumArray.max()!) ?? 2
        cornersSorted[0] = corners[topLeftIndex]
        cornersSorted[2] = corners[bottomRightIndex]
        
        for i in 0..<corners.count {
            if i != topLeftIndex && i != bottomRightIndex {
                remainingCorners.append(corners[i])
            }
        }

        let diffArray = remainingCorners.map { $0.y - $0.x }
        let topRightIndex = diffArray.firstIndex(of: diffArray.min()!) ?? 1
        let bottomLeftIndex = diffArray.firstIndex(of: diffArray.max()!) ?? 3
        cornersSorted[3] = remainingCorners[topRightIndex]
        cornersSorted[1] = remainingCorners[bottomLeftIndex]

        return cornersSorted
        
    }
    
    
}
