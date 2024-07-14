//
//  DocumentDetection.swift
//  DocumentDetectionSDK
//
//  Created by Alejandro Maldonado on 11/07/24.
//

import Foundation
import UIKit

public class DocumentDetection {
    
    public static func scanDocument(completion: @escaping CompletionCallback) {
        let viewController = DocumentDetectionViewController()
        viewController.completion = completion
        viewController.modalPresentationStyle = .fullScreen
        let keyWindow = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
        keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)

        
    }
}
