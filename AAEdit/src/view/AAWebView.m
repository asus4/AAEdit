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
@end
