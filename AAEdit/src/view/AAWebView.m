//
//  AAWebView.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/20.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAWebView.h"

@implementation AAWebView

- (void) awakeFromNib {
    // initialize settings
    [self setDrawsBackground:NO];
    [self setWantsLayer:YES];
}

- (void) saveToFile:(NSString *)path {
    // http://xcatsan.blogspot.jp/2009/04/webkit2_08.html
    NSBitmapImageRep* bitmap =
    [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds
                    toBitmapImageRep:bitmap];
    
    NSData* outdata = [bitmap representationUsingType:NSPNGFileType
                                           properties:[NSDictionary dictionary]];
    
    [outdata writeToFile:path atomically:YES];
}

@end