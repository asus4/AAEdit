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
@property (nonatomic, readonly) NSString * filePrefix;

@property (nonatomic, readonly) NSMutableDictionary * edgeData; // [Unicode, AAEdgeData]
@property (nonatomic, readonly) NSMutableArray * toneData; // [AAToneData] // white(1.0) - black(0.0)
@property (nonatomic, readonly) AAEdgeData * spaceChar;

@property (nonatomic) uint fontSize;

- (void) loadMovieFile:(NSURL*) file;

// setter getter
- (void) setEdgeString:(NSString *)edgeString;
- (void) setToneString:(NSString *)toneString;
- (NSArray*) getEdgeTableData;
- (NSArray*) getToneTableData;

- (NSString*) asciiTrace:(NSImage**) edgeImage colorImage:(NSImage**) colorImage useEdge:(BOOL) useEdge useTone:(BOOL)useTone useColor:(BOOL) useColor;

@end
