//
//  PremiereMakerDirector.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/02/14.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "PremiereMakerDirector.h"

@implementation PremiereMakerDirector

-(PremiereMarker*) getMarkerFromFrame:(NSInteger)frame fps:(NSUInteger)fps {
    PremiereMarker *current = _markers[0];
    
    for(uint i=0; i<_markers.count; ++i) {
        PremiereMarker *m = _markers[i];
        
        if(frame >= m.inTime) {
            current = m;
        }
        else {
            current = i>0 ? _markers[i-1] : _markers[0];
            break;
        }
    }
    
    return current;
}

+(PremiereMakerDirector*) directorFromCsv:(NSURL *)url fps:(float)fps {
    NSError * error;
//    NSString* csv = [NSString stringWithContentsOfFile:url.path encoding:NSUTF8StringEncoding error:&error];
    NSString* csv = [NSString stringWithContentsOfFile:url.path encoding:NSUTF16StringEncoding error:&error];
    if(error) {
        return nil;
    }
    NSLog(@"loaded : %@", csv);
    
    NSArray *arr = [csv componentsSeparatedByString:@"\n"];
    NSMutableArray *_markers = [[NSMutableArray alloc] initWithCapacity:0];
    
    if(arr.count <= 1) {
        return nil;
    }
    
    for(int i=1; i<arr.count; ++i) {
        NSString* line = arr[i];
        if(![line isEqualToString:@""]) {
            [_markers addObject:[PremiereMarker markerFromCsv:line fps:fps]];
        }
    }
    
    PremiereMakerDirector * director =  [[PremiereMakerDirector alloc] init];
    director.markers = _markers;
    
    return director;
}
@end
