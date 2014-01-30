//
//  AAEdgeData.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AADataProtcol.h"
#import "AABitmap.h"
#import "NSImage+OpenCV.h"


@interface AAEdgeData : NSObject <AADataProtcol> {
    AABitmap bitmap;
    IplImage* _grayImage;
    IplImage* _signImage;
    IplImage* _signBuffer;
}

@property (nonatomic) NSString * character;
@property (nonatomic) NSImage * image;
@property (nonatomic) NSImage * miniImage;
@property (nonatomic) NSSize size;

@property (nonatomic, readonly) IplImage* grayImage;
@property (nonatomic, readonly) IplImage* signImage;
@property (nonatomic, readonly) IplImage* signBuffer;

- (id) initWithCharacter:(UniChar) c font:(NSFont*)font;
//- (AABitmapRef) getAABitmapRef;

@end
