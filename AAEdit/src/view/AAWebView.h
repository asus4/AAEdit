//
//  AAWebView.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/20.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AAWebView : WebView

- (void) saveImageFile:(NSString *)path;
@end
