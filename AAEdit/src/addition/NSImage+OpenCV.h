//
//  NSImage+OpenCV.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/27.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#ifndef __NSIMAGE_OPENCV_H__
#define __NSIMAGE_OPENCV_H__


#import <Cocoa/Cocoa.h>
#include <opencv2/opencv.hpp>

@interface NSImage (OpenCV)

//using namespace cv;

+ (NSImage*) imageWithIplImage:(IplImage*) iplImage;

@property(nonatomic, readonly) IplImage* cvImage;
@property(nonatomic, readonly) IplImage* cvGrayImage;

- (IplImage*) getCvMonotoneImage:(double)threshold;

@end

#endif