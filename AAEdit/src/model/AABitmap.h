//
//  AABitmap.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/25.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#ifndef AAEdit_AABitmap_h
#define AAEdit_AABitmap_h

#import <Foundation/Foundation.h>


typedef struct {
    UInt8* buffer;
    size_t bytesPerRow;
    int width;
    int height;
} AABitmap;

typedef AABitmap* AABitmapRef;

#endif
