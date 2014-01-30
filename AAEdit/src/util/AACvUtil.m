//
//  AACvUtil.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/30.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AACvUtil.h"

@implementation AACvUtil

#define _AA_BLACK_THRETHOLD 220

+ (void) resizeMonoImage:(IplImage*)src dst:(IplImage*)dst {
    cvResize(src,dst,CV_INTER_AREA);
    cvThreshold(dst, dst, _AA_BLACK_THRETHOLD, 255, CV_THRESH_BINARY);
}

+ (IplImage*) resizeMonoImage:(IplImage *)src width:(const uint)width height:(const uint)height {
    IplImage* dst = cvCreateImage(cvSize(width, height), src->depth, src->nChannels);
    [self resizeMonoImage:src dst:dst];
    return dst;
}

@end
