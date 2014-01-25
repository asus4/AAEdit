//
//  AAStringManager.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAEdgeData.h"

@interface AADataManager : NSObject {
}

@property (nonatomic, readonly) NSFont * font;
@property (nonatomic, readonly) NSString * directoryPath;

@property (nonatomic, readonly) NSMutableDictionary * edgeData; // [uchar, AAEdgeData]
@property (nonatomic, readonly) NSMutableArray * toneData;
@property (nonatomic, readonly) AAEdgeData * spaceChar;

@property (nonatomic) uint fontSize;

- (void) loadMovieFile:(NSURL*) file;

// setter getter
- (void) setEdgeString:(NSString *)edgeString;
- (void) setToneString:(NSString *)toneString;
- (NSArray* )getEdgeTableData;

- (NSString*) asciiTrace:(NSImage *) edgeImage;

@end
