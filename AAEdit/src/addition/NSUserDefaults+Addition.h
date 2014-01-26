//
//  NSUserDefaults+Addition.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/26.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Addition)

- (NSColor*) colorForKey:(NSString*)key;
- (void) setColor:(NSColor*)color forKey:(NSString *)key;
@end
