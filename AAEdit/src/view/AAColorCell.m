//
//  AAColorCell.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/26.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAColorCell.h"

@implementation AAColorCell


- (void) setObjectValue:(id<NSCopying>)obj {
    id o = obj;
    if([o isKindOfClass:[NSColor class]] ) {
        NSColor * color = o;
        [self setDrawsBackground:YES]; // this wont work ??
        [self setBackgroundColor:color];
        [self setTextColor:color]; // this will work.
    }
    [super setObjectValue:obj];
}

@end
