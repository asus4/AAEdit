//
//  AAFileUtil.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAFileUtil.h"

@implementation AAFileUtil



+ (void) copyFile:(NSString*)file toDirectory:(NSString*) directory name:(NSString*) name{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", directory, name];
    if([fm fileExistsAtPath:path]) {
        return;
    }
    
    NSError *error;
    BOOL result = [fm copyItemAtPath:file toPath:path error:&error];
    if(!result) {
        NSLog(@"Fail to file copy %@", error.description);
    }
}

+ (NSString*) getContainsDirectory:(NSURL*)file {
    NSString * path = file.path;
    NSString * extension = [NSString stringWithFormat:@".%@", file.pathExtension];
    NSArray * arr = [path componentsSeparatedByString:extension];
    NSString * directory = arr[0];
    return directory;
}

+ (NSString*) getFileNameWithURL:(NSURL *)file {
    NSString * extension = [NSString stringWithFormat:@".%@", file.pathExtension];
    NSArray* arr = [file.lastPathComponent componentsSeparatedByString:extension];
    return arr[0];
}

+ (void) createFolder:(NSString*)directory {
    NSFileManager * fm = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExists = [fm fileExistsAtPath:directory isDirectory:&isDirectory];
    
    if (!isExists) {
        if (![fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil]) {
			NSLog(@"can't make directory %@", directory);
		}
    }
}

+ (NSString*) loadTextResource:(NSString*)file extensition:(NSString*)extension {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


+ (BOOL) saveText:(NSString*)text toPath:(NSString*)path {
    NSError *error;
    BOOL status = [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(!status) {
        NSLog(@"Failed to save : %@", [error domain]);
    }
    
    return status;
}

@end
