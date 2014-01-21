//
//  AAStringManager.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AADataManager : NSObject {
    NSString * directoryPath;
}

- (void) loadMovieFile:(NSURL*) file;

@end
