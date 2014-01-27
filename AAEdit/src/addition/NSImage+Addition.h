//
//  NSImage+Addition.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/24.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AABitmap.h"

@interface NSImage (Addition)
- (NSImage*) resizeImage:(NSSize)size scaleFactor:(CGFloat)scale;

- (NSBitmapImageRep*) getBitmapData:(UInt8**) buffer bytesPerRow:(size_t*) bpr width:(int*) w height:(int*)h;
- (NSBitmapImageRep*) getAABitmap:(AABitmap*) bmp;

- (NSBitmapImageRep*) getBitmapImageRep;
@end
