//
//  NSUserDefaults+Addition.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/26.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "NSUserDefaults+Addition.h"

@implementation NSUserDefaults (Addition)

- (NSColor*) colorForKey:(NSString *)key {
    
    NSData  * data = [self objectForKey:key];
    NSColor * color = [NSUnarchiver unarchiveObjectWithData:data];
    
    if(![color isKindOfClass:[NSColor class]] ) {
        color = [NSColor clearColor]; // default
    }
    return color;
}

- (void) setColor:(NSColor *)color forKey:(NSString *)key {
    NSData * data = [NSArchiver archivedDataWithRootObject:color];
    [self setObject:data forKey:key];
}
@end
