//
//  NSArrayController+Additon.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/24.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "NSArrayController+Addition.h"

@implementation NSArrayController (Addition)
- (void) removeAllObjects {
    NSRange range = NSMakeRange(0, [self.arrangedObjects count]);
    [self removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}
@end
