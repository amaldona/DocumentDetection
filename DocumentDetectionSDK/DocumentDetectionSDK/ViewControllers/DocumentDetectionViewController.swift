//
//  DocumentDetectionViewController.swift
//  DocumentDetection
//
//  Created by Alejandro Maldonado on 10/07/24.
//

import Foundation
import AVFoundation
import UIKit

class DocumentDetectionViewController : VideoPreviewViewController {
    
    private var detectionLayer: CAShapeLayer?
    var completion: CompletionCallback?
    let model: DocumentDetectionModel = DocumentDetectionModel()
    
    //*************************************************************************
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    //*************************************************************************

    func setup()
    {
        let bottomOffset = 50
        // Init image
        let colorConfig = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "camera.fill", withConfiguration: colorConfig.applying(sizeConfig))
        // Init button
        let captureButton = UIButton(frame: CGRect(x:0, y:0, width:100, height:100))
        captureButton.frame.origin = CGPoint(x: Int(self.view.frame.size.width - captureButton.frame.size.width) / 2,
                                             y: Int(self.view.frame.size.height) - Int(captureButton.frame.size.height) - bottomOffset)
        captureButton.backgroundColor = .blue
        captureButton.layer.masksToBounds = false
        captureButton.layer.backgroundColor = UIColor.blue.cgColor
        captureButton.layer.cornerRadius = captureButton.frame.size.width / 2
        captureButton.clipsToBounds = true
        captureButton.setImage(image, for: .normal)
        
        let action = UIAction { action in
            self.captureButtonClicked()
        }
        captureButton.addAction(action, for: .touchUpInside)

        self.view.addSubview(captureButton)
        self.view.backgroundColor = .black
    }
    
    //*************************************************************************
    
    func captureButtonClicked() {
        // Stop camera
        if (self.captureSession.isRunning) {
            self.captureSession.stopRunning()
        }
        
        // Perspective transformation
        model.generateCorrectedImage { image, error in
            self.dismiss(animated: true) {
                self.completion?(image, error)
            }
        }
        
        // Crop
//        model.generateCroppedImage { image, error in
//            self.dismiss(animated: true) {
//                self.completion?(image, error)
//            }
//        }

    }

    //*************************************************************************
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        super.captureOutput(output, didOutput: sampleBuffer, from: connection)
        
        if let snapshot = snapshot {
            model.detectDocumentFrom(image: snapshot) { corners, imageSize in
                drawDetectionBox(corners: corners, imageSize: imageSize)
            }
        }
    }
    
    //*************************************************************************

    func drawDetectionBox(corners:[CGPoint], imageSize:CGSize) {
        // Remove current layer
        DispatchQueue.main.async {
            self.detectionLayer?.removeFromSuperlayer()
        }

        // It needs at least 4 corners
        guard corners.count >= 4 else {
            return;
        }
        
        // imageSize must be non-zero
        guard imageSize != CGSize.zero else {
            return;
        }
        
        // Init the layer
        let layer = CAShapeLayer()
        layer.frame = UIScreen.main.bounds
        layer.lineWidth = 2
        layer.lineJoin = .miter
        layer.strokeColor =  UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor
        layer.fillColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 0.2).cgColor

        // Draw the points in the layer
        let path = UIBezierPath()
        path.move(to: corners.first!.transformCoordinates(from: imageSize, to: UIScreen.main.bounds.size))
        for i in 1..<corners.count {
            path.addLine(to: corners[i].transformCoordinates(from: imageSize, to: UIScreen.main.bounds.size))
        }
        path.close()
        layer.path = path.cgPath

        // Update the UI
        self.detectionLayer = layer
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(layer)
        }

    }

}
