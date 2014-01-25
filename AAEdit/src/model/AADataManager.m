//
//  AAStringManager.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/21.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AADataManager.h"
#import "AAFileUtil.h"
#import "NSImage+Addition.h"

@implementation AADataManager

#define _FONT_NAME @"IPAMonaPGothic"
#define _BLACK_TOLERANCE 20

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
    
    // 全角スペース
    NSString * space = @"　";
    _spaceChar = [[AAEdgeData alloc] initWithCharacter:[space characterAtIndex:0] font:self.font];
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
    
    padding = fontSize/2;
}


#pragma mark Trace Logic

- (NSString*) asciiTrace:(NSImage *) edgeImage colorImage:(NSImage *) colorImage useEdge:(BOOL) useEdge useTone:(BOOL)useTone useColor:(BOOL) useColor {
    NSArray * edgeTable = [self getEdgeTableData];
    
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
            // test
            /*
            if(isBlackPixel(&bmp, x, y, 10)) {
                [aa appendString:@"-"];
            }
            else {
                [aa appendString:@"0"];
            }
            */
            
            int _x = 0;
            float similarity = 0.0f;
            AAEdgeData* matchedData = nil;
            
            for(AAEdgeData* data in edgeTable) {
                float f = getSimilarity(&bmp, [data getAABitmapRef], x, y);
                
                if(f > similarity) {
                    similarity = f;
                    matchedData = data;
                }
            }
            
            // no match
            // TODO : tone
            if(similarity < 0) {
                break;
            }
            
            if(similarity == 0) {
                matchedData = self.spaceChar;
            }
            
            // TODO : color
            [aa appendString:matchedData.character];
            _x = matchedData.size.width;
            _y = matchedData.size.height;
            
            x += _x;
        }
        [aa appendString:@"\n"];
        y+= _y;
    }
    
    NSLog(@"image size %f,%f", edgeImage.size.width, edgeImage.size.height);
    NSLog(@"bitmap size %d,%d", bmp.width, bmp.height);
    
    return aa;
}


static inline BOOL isBlack(UInt8* buffer, const int x, const int y, const size_t bytesPerRow) {
    UInt8*  pixelPtr = buffer + (int)y * bytesPerRow + (int)x * 4;
    UInt8 r = *(pixelPtr);
    UInt8 g = *(pixelPtr + 1);
    UInt8 b = *(pixelPtr + 2);
//    UInt8 a = *(pixelPtr + 3); // ignore alpha
    return (r + g + b < _BLACK_TOLERANCE);
}

static inline BOOL isBlackPixel(AABitmapRef bmp, const int x, const int y) {
    UInt8*  pixelPtr = bmp->buffer + (int)y * bmp->bytesPerRow + (int)x * 4;
    UInt8 r = *(pixelPtr);
    UInt8 g = *(pixelPtr + 1);
    UInt8 b = *(pixelPtr + 2);
//    UInt8 a = *(pixelPtr + 3); // ignore alpha
    return (r + g + b < _BLACK_TOLERANCE);
}


// bitmap matcing algorithm
static int padding;
static inline float getSimilarity(AABitmapRef srcBmp, AABitmapRef charBmp, const int sX, const int sY) {
    
    if(sX+charBmp->width >= srcBmp->width-padding
       || sY+charBmp->height >= srcBmp->height-padding) {
        return -1.0f;
    }
    
    float similarity = 0.1f;
    int numSrcOn=0, numCharOn=0;
    
    for(int cY=0; cY<charBmp->height; ++cY) {
        for(int cX=0; cX<charBmp->width; ++cX) {
            BOOL cOn = isBlackPixel(charBmp, cX, cY);
            BOOL sOn = !isBlackPixel(srcBmp, sX+cX, sY+cY);
            
            if(sOn) numSrcOn++;
            if(cOn) numCharOn++;
            
            if(sOn && cOn) {
                similarity += 1.0f;
            }
            else {
                similarity -= 1.0f;
            }
        }
    }
    
    if(numSrcOn == 0) { // white pixel
        return 0;
    }
    
    if(similarity < 0) {
        similarity = 0.1f;
    }
    
    return similarity;
}

@end