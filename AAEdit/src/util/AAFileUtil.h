//
//  AAFileUtil.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAFileUtil : NSObject


+ (void) copyFile:(NSString*)file toDirectory:(NSString*) directory name:(NSString*) name;
+ (NSString*) getContainsDirectory:(NSURL*)file;
+ (void) createFolder:(NSString*)directory;
+ (NSString*) loadTextResource:(NSString*)file extensition:(NSString*)extension;

+ (BOOL) saveText:(NSString*)text toPath:(NSString*)path;

@end
