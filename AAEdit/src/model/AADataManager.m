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
#import "NSImage+Addition.h"

@implementation AADataManager

#define _FONT_NAME @"IPAMonaPGothic"

const UniChar escapes[] = {'\n','\b','\r','\t'};

#pragma mark private

- (BOOL) isEscape:(UniChar) c {
    uint length = sizeof escapes / sizeof escapes[0];
    for(uint i=0; i<length; ++i) {
        if(escapes[i] == c) {
            return YES;
        }
    }
    return NO;
}

#pragma mark public

- (id) init {
    if(self = [super init]) {
        // initialize
        _directoryPath = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory, NSUserDomainMask, YES)[0];
        _edgeData = [@{} mutableCopy];
        
        self.fontSize = 12;
    }
    return self;
}

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
        if([self isEscape:c]) { // avoid escape characters
            continue;
        }
        self.edgeData[[NSNumber numberWithUnsignedShort:c]] = [[AAEdgeData alloc] initWithCharacter:c font:self.font];
    }
}

- (void) setToneString:(NSString *)toneString {
    // TODO: implemented
}

- (NSArray*) getEdgeTableData {
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for(id data in [self.edgeData objectEnumerator]) {
        [arr addObject:data];
    }
    return arr;
}

- (void) setFontSize:(uint)fontSize {
    _fontSize = fontSize;
    _font = nil;
    _font = [NSFont fontWithName:_FONT_NAME size:fontSize];
}


#pragma mark Trace Logic

- (NSString*) asciiTrace:(NSImage *)edgeImage {
    NSArray * edgeTable = [self getEdgeTableData];
    
    // TODO: edge, color, tone mode
    
    if(edgeTable.count == 0) {
        return @"edge table is empty.";
    }
    
    // this is slow
    //    NSColor * c = [imageRep colorAtX:0 y:0];
    
    NSMutableString *aa = [NSMutableString stringWithString:@""];
    
    // Edge trace
    int x=0,y=0;
    AABitmap bmp;
    [edgeImage getAABitmap:&bmp];
    
    while (y<bmp.height) {
        x = 0;
        int _y = 0;
        while (x<bmp.width) {
            if(isBlackPixel(&bmp, x, y, 10)) {
                [aa appendString:@"-"];
            }
            else {
                [aa appendString:@"0"];
            }
            
            int _x = 0;
//            
//            for(AAEdgeData* data in edgeTable) {
//                
//            }
//            
//            x += _x;
            x++;
        }
        [aa appendString:@"\n"];
//        y+= _y;
        y++;
    }
    
//    [self getMatchLevel:imageRep edgeData:edgeTable[0]];
    
    NSLog(@"image size %f,%f", edgeImage.size.width, edgeImage.size.height);
//    NSLog(@"imaeg rep %i,%i", bmp.width, bmp.height);
    
    return aa;
}


static inline BOOL isBlack(UInt8* buffer, const int x, const int y, const size_t bytesPerRow, const int tolerance) {
    UInt8*  pixelPtr = buffer + (int)y * bytesPerRow + (int)x * 4;
    UInt8 r = *(pixelPtr);
    UInt8 g = *(pixelPtr + 1);
    UInt8 b = *(pixelPtr + 2);
//    UInt8 a = *(pixelPtr + 3);
    return (r + g + b < tolerance);
}

static inline BOOL isBlackPixel(AABitmap* bmp, const int x, const int y, const int tolerance) {
    UInt8*  pixelPtr = (*bmp).buffer + (int)y * (*bmp).bytesPerRow + (int)x * 4;
    UInt8 r = *(pixelPtr);
    UInt8 g = *(pixelPtr + 1);
    UInt8 b = *(pixelPtr + 2);
    //    UInt8 a = *(pixelPtr + 3);
    return (r + g + b < tolerance);
}

- (float) getMatchLevel:(NSBitmapImageRep*) bmp edgeData:(AAEdgeData*)edgeData {
    return 0;
}

@end
