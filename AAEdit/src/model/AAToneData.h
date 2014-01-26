//
//  AAToneData.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/26.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AADataProtcol.h"

@interface AAToneData : NSObject<AADataProtcol> {
    
}

@property (nonatomic)NSString * tone;
@property (nonatomic) NSColor* color;
// protcol implement
@property (nonatomic) NSString * character;
@property (nonatomic) NSSize size;

- (id) initWithString:(NSString*)str font:(NSFont*)font brightness:(float)brightness;
- (void) nextTone;

@end
