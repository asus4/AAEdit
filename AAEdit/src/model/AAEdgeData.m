//
//  AAEdgeData.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAEdgeData.h"
#import "NSImage+Addition.h"
#import "NSString+AAAddition.h"

@implementation AAEdgeData

- (id) initWithCharacter:(UniChar)c font:(NSFont *)font{
    if(self == [super init]) {
        self.character = [NSString stringWithCharacters:&c length:1];
        self.image = [self.character imageWithFont:font];
        self.size = self.image.size;
        
        [self.image getAABitmap:&bitmap];
    }
    return self;
}

- (AABitmapRef) getAABitmapRef {
    return &bitmap;
}

@end
