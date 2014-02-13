//
//  PremiereMarker.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/02/14.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "PremiereMarker.h"

@implementation PremiereMarker

static inline int timecodeToFrames(NSString* timecode, int fps) {
    NSArray *arr = [timecode componentsSeparatedByString:@";"];
    if(arr.count < 4) {
        return -1;
    }
    int hour = ((NSString*)arr[0]).intValue;
    int min = ((NSString*)arr[1]).intValue;
    int sec = ((NSString*)arr[2]).intValue;
    int frame = ((NSString*)arr[3]).intValue;
    
    return hour*3600*fps + min*60*fps + sec*fps + frame;
}

+(PremiereMarker*) markerFromCsv:(NSString *)line fps:(float) fps
{
    NSArray *arr = [line componentsSeparatedByString:@"\t"];
    if(arr.count < 6) {
        return nil;
    }
    
    PremiereMarker * marker = [[PremiereMarker alloc] init];
    marker.markerName = arr[0];
    marker.description = arr[1];
    marker.inTime = timecodeToFrames(arr[2], fps);
    marker.outTime = timecodeToFrames(arr[3], fps);
    marker.duration = timecodeToFrames(arr[4], fps);
    marker.markerType = arr[5];
    return  marker;
}
@end
