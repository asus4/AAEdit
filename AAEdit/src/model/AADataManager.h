//
//  AAStringManager.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AADataManager : NSObject {
}

@property (nonatomic, readonly) NSString * directoryPath;

@property (nonatomic, readonly) NSMutableDictionary * edgeData;
@property (nonatomic, readonly) NSMutableArray * toneData;

- (void) loadMovieFile:(NSURL*) file;

// setter getter
- (void) setEdgeString:(NSString *)edgeString;
- (void) setToneString:(NSString *)toneString;
- (NSArray* )getEdgeTableData;

@end
