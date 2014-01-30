//
//  AAEdgeData.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAEdgeData.h"
#import "NSImage+Addition.h"
#import "NSString+AAAddition.h"
#import "AACvUtil.h"

@implementation AAEdgeData

#define _AA_MONOTONE_THRETHOLD 200
#define _AA_SIGN_WIDTH 3
#define _AA_SIGN_HEIGHT 4

- (id) initWithCharacter:(UniChar)c font:(NSFont *)font{
    if(self == [super init]) {
        self.character = [NSString stringWithCharacters:&c length:1];
        
        NSSize size;
        NSImage* img = [self.character imageWithFont:font size:&size];
        self.size = size;
        
        _grayImage = [img getCvMonotoneImage:_AA_MONOTONE_THRETHOLD];
        _signImage = [AACvUtil resizeMonoImage:_grayImage
                                         width:_AA_SIGN_WIDTH
                                        height:_AA_SIGN_HEIGHT];
        _signBuffer = cvCreateImage(cvSize(_signImage->width, _signImage->height), _signImage->depth, _signImage->nChannels);
        
        self.image = [NSImage imageWithIplImage:_grayImage];
        self.miniImage = [NSImage imageWithIplImage:_signImage];
    }
    return self;
}

- (void) dealloc {
    cvReleaseImage(&_grayImage);
    cvReleaseImage(&_signImage);
}

- (AABitmapRef) getAABitmapRef {
    return &bitmap;
}

- (IplImage*) grayImage {
    return _grayImage;
}

- (IplImage*) signImage {
    return _signImage;
}

- (IplImage*) signBuffer {
    return _signBuffer;
}

@end
