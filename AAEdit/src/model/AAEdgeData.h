//
//  AAEdgeData.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/22.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAEdgeData : NSObject

- (id) initWithCharacter:(UniChar) c;

@property (nonatomic) NSString * character;
@property (nonatomic) NSImage * image;
@property (nonatomic) UInt size;

@end
