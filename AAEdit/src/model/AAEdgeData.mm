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

- (id) initWithCharacter:(UniChar)c font:(NSFont *)font{
    if(self == [super init]) {
        self.character = [NSString stringWithCharacters:&c length:1];
        
        NSSize size;
        NSImage* img = [self.character imageWithFont:font size:&size];
        self.size = size;
        
        _grayImage = [img getCvMonotoneImage:200];
        _signImage = [AACvUtil resizeMonoImage:_grayImage width:3 height:4];
        
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

@end
