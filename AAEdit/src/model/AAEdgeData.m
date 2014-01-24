//
//  AAEdgeData.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAEdgeData.h"

@implementation AAEdgeData

- (id) initWithCharacter:(UniChar)c {
    if(self == [super init]) {
        self.character = [NSString stringWithCharacters:&c length:1];
        self.image = [AAEdgeData createImage:c];
        self.size = 16;
    }
    return self;
}

#pragma mark private

+ (NSImage*) createImage:(UniChar)c {
    NSString * str = [NSString stringWithCharacters:&c length:1];
    
    NSFont * font = [NSFont fontWithName:@"IPAMonaPGothic" size:16];
    NSSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    NSLog(@"%@ : {%f,%f}", str, size.width, size.height);
    return [NSImage imageNamed:@"orenge"];
}

@end
