//
//  NSColorWellWithAlpha.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/20.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "NSColorWellWithAlpha.h"

@implementation NSColorWellWithAlpha

// http://www.allocinit.net/blog/2006/06/20/of-colour-wells-and-alpha/

- (void) activate:(BOOL)exclusive {
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [super activate:exclusive];
}

@end
