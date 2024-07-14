//
//  VideoPreviewViewController.swift
//  DocumentDetection
//
//  Created by Alejandro Maldonado on 9/07/24.
//

import Foundation
import AVFoundation
import UIKit


class VideoPreviewViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var snapshot: CIImage?
    let captureSession = AVCaptureSession()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var videoOutput = AVCaptureVideoDataOutput()
    
    //*************************************************************************

    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    //*************************************************************************

    override func viewDidLoad() {
        Task {
            guard await isAuthorized else {
                dismiss(animated: true)
                return
            }
        }
    }

    //*************************************************************************

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    //*************************************************************************

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }

    //*************************************************************************

    func setupCaptureSession() {
        // Camera input
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
           
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
                         
        // Preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        // Capture snapshots
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        // Updates to UI must be on main queue
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.insertSublayer(self!.previewLayer, at: 0)
        }
    }
    
    //*************************************************************************

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        snapshot = getImageFromSampleBuffer(sampleBuffer: sampleBuffer)
    }
    
    //*************************************************************************
    
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation = .up, scale: CGFloat = 1.0) -> CIImage? {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let image = CIImage(cvPixelBuffer: buffer)
        return image
    }
    
    //*************************************************************************
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
