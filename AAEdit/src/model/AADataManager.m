//
//  AAStringManager.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AADataManager.h"

@implementation AADataManager

- (id) init {
    if(self = [super init]) {
        
    }
    return self;
}

#pragma mark public

- (void) loadMovieFile:(NSURL *)file {
    directoryPath = [self getContainsDirectory:file];
    [self createFolder:directoryPath];
}

#pragma mark private

- (NSString*) getContainsDirectory:(NSURL*)file {
    NSString * path = file.path;
    NSString * extension = [NSString stringWithFormat:@".%@", file.pathExtension];
    NSArray * arr = [path componentsSeparatedByString:extension];
    NSString * directory = arr[0];
    return directory;
}

- (void) createFolder:(NSString*)directory {
    NSFileManager * fm = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExists = [fm fileExistsAtPath:directory isDirectory:&isDirectory];
    
    if (!isExists) {
        if (![fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil]) {
			NSLog(@"can't make directory %@", directory);
		}
    }
}


@end
