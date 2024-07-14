# DocumentDetection

**IMPORTANT:
Download OpenCV framework from: <https://github.com/opencv/opencv/releases> and copy `opencv2.framework` to `DocumentDetection/DocumentDetectionSDK/DocumentDetectionSDK/libs`**


Framework files
---------------

- `VideoPreviewViewController`: Parent class of `DocumentDetectionViewController`. This view controller only displays a layer with the video preview, and constantly updates a snapshot.
- `DocumentDetectionViewController`: subclass of `VideoPreviewViewController`. Displays another layer with the detection box over the video preview layer, and interacts with the `DocumentDetectionModel` to obtain the corners.
- `DocumentDetectionModel`: Model class that interacts with the OpenCV wrapper, detects the corners, crops and transforms the snapshot, and stores the result.
- `CGPoint+Helper`: Helper class with some point operations like transforming a point from one coordinate system to another, sort detected points, etc.
- `CIImage+Helper`: Helper class with cropping and perspective correction methods.
- `OpenCVWrapper`: C++ wrapper class.
- `DocumentDetection`: Entry point of the framework. Only has one static method that returns the transformed image.
- Tests with a `Host Application` target.

The workspace includes a barebone sample project, with a button that calls the framework entry point method (`DocumentDetection` class) and an imageView to display the result:

```swift
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
	    print(message)
	}

}
```
