//
//  PremiereMakerDirector.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/02/14.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PremiereMarker.h"

@interface PremiereMakerDirector : NSObject

@property (nonatomic) NSArray* markers;

- (PremiereMarker*) getMarkerFromFrame:(NSInteger) frame fps:(NSUInteger) fps;

+ (PremiereMakerDirector*) directorFromCsv:(NSURL*) url fps:(float)fps;
@end
