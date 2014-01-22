//
//  AAStringManager.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AADataManager.h"
#import "AAFileUtil.h"

@implementation AADataManager

- (id) init {
    if(self = [super init]) {
        // initialize
        _directoryPath = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory, NSUserDomainMask, YES)[0];
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


@end
