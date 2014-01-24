//
//  AAStringManager.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AADataManager.h"
#import "AAEdgeData.h"
#import "AAFileUtil.h"

@implementation AADataManager

const UniChar escapes[] = {'\n','\b','\r','\t'};

- (BOOL) isEscape:(UniChar) c {
    uint length = sizeof escapes / sizeof escapes[0];
    for(uint i=0; i<length; ++i) {
        if(escapes[i] == c) {
            return YES;
        }
    }
    return NO;
}

#pragma mark life cycle

- (id) init {
    if(self = [super init]) {
        // initialize
        _directoryPath = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory, NSUserDomainMask, YES)[0];
        _edgeData = [@{} mutableCopy];
    }
    return self;
}

#pragma mark public

- (void) loadMovieFile:(NSURL *)file {
    // initialize
    _directoryPath = [AAFileUtil getContainsDirectory:file];
    [AAFileUtil createFolder:_directoryPath];
    
    // copy font file
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"ipagp-mona" ofType:@"woff"];
    [AAFileUtil copyFile:fontPath toDirectory:_directoryPath name:@"ipagp-mona.woff"];
}

- (void) setEdgeString:(NSString *)edgeString {
    [self.edgeData removeAllObjects];
    
    for(uint i=0; i<edgeString.length; ++i) {
        UniChar c = [edgeString characterAtIndex:i];
        if([self isEscape:c]) { // remove escape characters
            continue;
        }
        self.edgeData[[NSNumber numberWithUnsignedShort:c]] = [[AAEdgeData alloc] initWithCharacter:c];
    }
}

- (void) setToneString:(NSString *)toneString {
    
}

- (NSArray*) getEdgeTableData {
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for(id data in [self.edgeData objectEnumerator]) {
        [arr addObject:data];
    }
    return arr;
}

@end
