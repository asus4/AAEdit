//
//  NSImage+OpenCV.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/27.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Cocoa/Cocoa.h>

@interface NSImage (OpenCV)

+(NSImage*)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;

@end
