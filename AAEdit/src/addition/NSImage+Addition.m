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
           operation:NSCompositeSourceOver fraction:1.0];
    [resizedImage unlockFocus];
    
    return resizedImage;
}
@end
