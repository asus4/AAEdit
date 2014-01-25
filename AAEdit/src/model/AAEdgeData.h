//
//  AAEdgeData.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AABitmap.h"

@interface AAEdgeData : NSObject {
    AABitmap bitmap;
}

@property (nonatomic) NSString * character;
@property (nonatomic) NSImage * image;
@property (nonatomic) NSSize size;

- (id) initWithCharacter:(UniChar) c font:(NSFont*)font;
- (AABitmapRef) getAABitmapRef;

@end
