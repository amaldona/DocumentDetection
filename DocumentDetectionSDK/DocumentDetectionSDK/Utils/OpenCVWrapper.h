//
//  OpenCVWrapper.h
//  DocumentDetection
//
//  Created by Alejandro Maldonado on 9/07/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSArray *)findDocumentCorners:(CIImage *)image;

@end

NS_ASSUME_NONNULL_END
