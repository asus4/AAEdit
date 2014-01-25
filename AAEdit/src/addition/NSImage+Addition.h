//
//  NSImage+Addition.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/24.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Addition)

- (NSImage*) resizeImage:(NSSize)size scaleFactor:(CGFloat)scale;
@end
