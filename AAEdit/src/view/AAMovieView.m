//
//  AAMovieView.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/20.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAMovieView.h"

@implementation AAMovieView

- (void) loadMovie:(NSString *) file {
    NSLog(@"AAMovieView file : %@", file);
    
    if(movie != NULL) {
        [movie stop];
    }
    movie = [QTMovie movieWithFile:file error:nil];
    
    [self setMovie:movie];
}

@end
