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
    NSBitmapImageRep* imageRep;
    AABitmap bitmap;
    IplImage* grayImage;
}

@property (nonatomic) NSString * character;
@property (nonatomic) NSImage * image;
@property (nonatomic) NSSize size;

- (id) initWithCharacter:(UniChar) c font:(NSFont*)font;
- (AABitmapRef) getAABitmapRef;

@end
