//
//  NSString+AAAddition.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/24.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "NSString+AAAddition.h"

@implementation NSString (AAAddition)

- (NSImage*) imageWithFont:(NSFont *)font size:(NSSize*) size {
    
    // @see: http://stackoverflow.com/questions/2444717/embed-font-in-a-mac-bundle
    // @see: http://stackoverflow.com/questions/11442993/how-to-convert-text-to-image-in-cocoa-objective-c

    NSDictionary * attributes = @{NSFontAttributeName:font};
    //    NSLog(@"%@ : {%f,%f}", str, size.width, size.height);
    NSAttributedString * as = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)as);
    CGFloat ascent, descent, leading;
    double fWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    // On iOS 4.0 and Mac OS X v10.6 you can pass null for data
    *size = CGSizeMake(fWidth, ascent + descent);
    
    size_t width = (size_t)ceilf(fWidth);
    size_t height = (size_t)ceilf(ascent + descent);
    void* data = malloc(width*height*4);
    
    // Create the context and fill it with white background
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    CGContextRef ctx = CGBitmapContextCreate(data, width, height, 8, width*4, space, bitmapInfo);
    CGColorSpaceRelease(space);
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0); // white background
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, width, height));
    
    // Draw the text
    CGFloat x = 0.0;
    CGFloat y = descent;
    CGContextSetTextPosition(ctx, x, y);
    CTLineDraw(line, ctx);
    CFRelease(line);
    
    // Save as image
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSAssert(imageRep, @"imageRep must not be nil");
    
    NSImage * img = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(width, height)];
    
    // crean up
    //    [imageRef release];
    CGImageRelease(imageRef);
    free(data);
    return img;
}

@end
