//
//  PremiereMarker.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/02/14.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PremiereMarker : NSObject

@property (nonatomic) NSString* markerName;
@property (nonatomic) NSString* description;
@property (nonatomic) NSInteger inTime;
@property (nonatomic) NSInteger outTime;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSString* markerType;

+(PremiereMarker*) markerFromCsv:(NSString*) line fps:(float) fps;

@end
