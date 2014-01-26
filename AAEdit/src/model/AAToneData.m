//
//  AAToneData.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/26.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAToneData.h"
#import "AAEdgeData.h"

#pragma mark private
@interface AAToneData()

@property (nonatomic) NSMutableArray* datas;
@property (nonatomic) int currentIndex;

@end

@implementation AAToneData

// initialize
- (id) initWithString:(NSString *)str font:(NSFont *)font brightness:(float)brightness {
    if(self == [super init]) {
        //
        self.currentIndex = 0;
        self.tone = str;
        self.color = [NSColor colorWithDeviceWhite:brightness alpha:1.0f];
        self.datas = [NSMutableArray arrayWithCapacity:0];
        for(uint i=0; i<str.length; ++i) {
            UniChar c = [str characterAtIndex:i];
            AAEdgeData *data = [[AAEdgeData alloc] initWithCharacter:c font:font];
            [self.datas addObject:data];
        }
        [self nextTone];
    }
    return self;
}

- (void) nextTone {
    if(self.currentIndex >= self.datas.count) {
        self.currentIndex = 0;
    }
    
    AAEdgeData*data = self.datas[self.currentIndex];
    self.character = data.character;
    self.size = data.size;
    
    self.currentIndex++;
}

@end
