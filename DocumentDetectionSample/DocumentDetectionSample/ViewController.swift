//
//  ViewController.swift
//  DocumentDetectionSample
//
//  Created by Alejandro Maldonado on 11/07/24.
//

import UIKit
import DocumentDetectionSDK

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
        
    @IBAction func buttonClicked(_ sender: Any) {
        
        DocumentDetection.scanDocument { image, error in
            // Show image result
            if let image = image {
                self.image.image = image
            }
            // Show error message
            if let error = error {
                let message = switch error {
                    case .ImageNotFound:
                        "Image not found"
                    case .CropFailed:
                        "Error cropping the image"
                    case .TransformFailed:
                        "Error applying perspective correction to the image"
                    default:
                        "Unknown error"
                }
                self.showAlertMessage(title: "Error", message: message)
            }
        }
        
    }
    
    
    public func showAlertMessage(title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
    }
    
}

