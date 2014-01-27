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

- (void) saveImageFile:(NSString *)path {
    // http://xcatsan.blogspot.jp/2009/04/webkit2_08.html
    NSBitmapImageRep* bitmap =
    [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds
                    toBitmapImageRep:bitmap];
    
    NSData* outdata = [bitmap representationUsingType:NSPNGFileType
                                           properties:[NSDictionary dictionary]];
    
    [outdata writeToFile:path atomically:YES];
}

- (void) saveHtmlFile:(NSString *)path {
    // save to file
    NSString * html = [(DOMHTMLElement*)self.mainFrame.DOMDocument.documentElement outerHTML];
    
    NSError *error;
    BOOL status = [html writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(!status) {
        NSLog(@"Failed to save : %@", [error domain]);
    }
}

- (void) saveIdOuterHtml:(NSString*)_id path:(NSString *)path {
    // TODO: impelemented
}


@end