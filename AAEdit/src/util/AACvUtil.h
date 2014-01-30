//
//  AACvUtil.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/30.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

//#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

@interface AACvUtil : NSObject

+ (void) resizeMonoImage:(IplImage*)src dst:(IplImage*)dst;
+ (IplImage*) resizeMonoImage:(IplImage*)src width:(const uint) width height:(const uint) height;



@end
