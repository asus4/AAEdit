//
//  NSImage+Addition.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/24.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "NSImage+Addition.h"

@implementation NSImage (Addition)

- (NSImage*) resizeImage:(NSSize)size scaleFactor:(CGFloat)scale {
    // scaling for retina
    if(scale != 1) {
        size.width /= scale;
        size.height /= scale;
    }
    
    // resize
    NSSize originalSize = self.size;
    NSImage* resizedImage = [[NSImage alloc] initWithSize:size];
    
    [resizedImage lockFocus];
    [self drawInRect:NSMakeRect(0, 0, size.width, size.height)
            fromRect:NSMakeRect(0, 0, originalSize.width, originalSize.height)
           operation:NSCompositeSourceOver
            fraction:1.0];
    [resizedImage unlockFocus];
    
    return resizedImage;
}

- (NSBitmapImageRep*) getBitmapData:(UInt8**) buffer bytesPerRow:(size_t*) bpr width:(int*) w height:(int*)h;
 {
    // Get Bitmap image
     NSBitmapImageRep* imageRep = [self getBitmapImageRep];
    
    CGImageRef imageRef = imageRep.CGImage;
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef); // data provider
    
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    *buffer = (UInt8*)CFDataGetBytePtr(dataRef); // bitmap data
    *bpr = CGImageGetBytesPerRow(imageRef);
    *w = (int)imageRep.pixelsWide;
    *h = (int)imageRep.pixelsHigh;
    
    CFRelease(dataRef);
     
    return imageRep;
}

- (NSBitmapImageRep*) getAABitmap:(AABitmapRef)bmp {
    return [self getBitmapData:&(*bmp).buffer bytesPerRow:&(*bmp).bytesPerRow width:&(*bmp).width height:&(*bmp).height];
}

- (NSBitmapImageRep*) getBitmapImageRep {
    return [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
}


- (NSInteger) pixelsWide
{
    /*
     returns the pixel width of NSImage.
     Selects the largest bitmapRep by preference
     If there is no bitmapRep returns largest size reported by any imageRep.
     */
    NSInteger result = 0;
    NSInteger bitmapResult = 0;
    
    for (NSImageRep* imageRep in [self representations]) {
        if ([imageRep isKindOfClass:[NSBitmapImageRep class]]) {
            if (imageRep.pixelsWide > bitmapResult)
                bitmapResult = imageRep.pixelsWide;
        } else {
            if (imageRep.pixelsWide > result)
                result = imageRep.pixelsWide;
        }
    }
    if (bitmapResult) result = bitmapResult;
    return result;
    
}

- (NSInteger) pixelsHigh
{
    /*
     returns the pixel height of NSImage.
     Selects the largest bitmapRep by preference
     If there is no bitmapRep returns largest size reported by any imageRep.
     */
    NSInteger result = 0;
    NSInteger bitmapResult = 0;
    
    for (NSImageRep* imageRep in [self representations]) {
        if ([imageRep isKindOfClass:[NSBitmapImageRep class]]) {
            if (imageRep.pixelsHigh > bitmapResult)
                bitmapResult = imageRep.pixelsHigh;
        } else {
            if (imageRep.pixelsHigh > result)
                result = imageRep.pixelsHigh;
        }
    }
    if (bitmapResult) result = bitmapResult;
    return result;
}

- (NSSize) pixelSize
{
    return NSMakeSize(self.pixelsWide,self.pixelsHigh);
}

@end
