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
#import "AADomUtil.h"
#import "AAToneData.h"
#import "AACvUtil.h"

@implementation AADataManager

#define _FONT_NAME @"IPAMonaPGothic"
#define _BLACK_TOLERANCE 170
#define _AA_WHITE_PIXEL_THRETHOLD 5

#pragma mark public

static IplImage* templeteResult;

- (id) init {
    if(self = [super init]) {
        // initialize
        _directoryPath = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory, NSUserDomainMask, YES)[0];
        _filePrefix = @"";
        _edgeData = [NSMutableDictionary dictionaryWithCapacity:0];
        _toneData = [NSMutableArray arrayWithCapacity:0];
        self.fontSize = 12;
        
        templeteResult = cvCreateImage(cvSize(1, 1), 32, 1);
    }
    return self;
}

- (void) dealloc {
    cvReleaseImage(&templeteResult);
}

- (void) loadMovieFile:(NSURL *)file {
    // initialize
    _directoryPath = [AAFileUtil getContainsDirectory:file];
    _filePrefix = [AAFileUtil getFileNameWithURL:file];
//    NSLog(@"fliename is %@", _filePrefix);
    [AAFileUtil createFolder:_directoryPath];
    
    // copy font file
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"ipagp-mona" ofType:@"woff"];
    [AAFileUtil copyFile:fontPath toDirectory:_directoryPath name:@"ipagp-mona.woff"];
}

- (void) setEdgeString:(NSString *)edgeString {
    [self.edgeData removeAllObjects];
    
    NSFont *bigFont = [NSFont fontWithName:self.font.fontName size:64];
    for(uint i=0; i<edgeString.length; ++i) {
        UniChar c = [edgeString characterAtIndex:i];
        if([AADomUtil isEscape:c]) { // avoid escape characters
            continue;
        }
        self.edgeData[[NSNumber numberWithUnsignedShort:c]] = [[AAEdgeData alloc] initWithCharacter:c font:self.font bigFont:bigFont];
    }
    
    // 全角スペース
    NSString * space = @"　";
    _spaceChar = [[AAEdgeData alloc] initWithCharacter:[space characterAtIndex:0] font:self.font];
}

- (void) setToneString:(NSString *)toneString {
    [self.toneData removeAllObjects];
    
    NSArray * arr = [toneString componentsSeparatedByString:@"\n"];
    if(arr.count == 0) {
        NSLog(@"error tone count is 0");
        return;
    }
    for(uint i=0; i<arr.count; ++i) {
        float brightness = 1.0f - (float)i/(float)arr.count;
        AAToneData *data = [[AAToneData alloc] initWithString:arr[i]
                                                         font:self.font
                                                   brightness:brightness];
        [self.toneData addObject:data];
    }
}

- (NSArray*) getEdgeTableData {
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for(id data in [self.edgeData objectEnumerator]) {
        [arr addObject:data];
    }
    return arr;
}

- (NSArray*) getToneTableData {
    return self.toneData;
}

- (void) setFontSize:(uint)fontSize {
    _fontSize = fontSize;
    _font = nil;
    _font = [NSFont fontWithName:_FONT_NAME size:fontSize];
}


#pragma mark Trace Logic

- (NSString*) asciiTrace:(NSImage**) edgeImage colorImage:(NSImage**) colorImage useEdge:(BOOL) useEdge useTone:(BOOL)useTone useColor:(BOOL) useColor {
    NSArray * edgeTable = [self getEdgeTableData];
    
    // errors
    if(edgeTable.count == 0) {
        return @"edge table is empty.";
    }
    if(self.toneData.count == 0) {
        return @"tone table is empty.";
    }
    
    NSMutableString *aa = [NSMutableString stringWithString:@""];
    
    // Edge trace
    double x=0,y=0;
    
    NSBitmapImageRep *colorRep = [(*colorImage) getBitmapImageRep];
    
    IplImage* edgeIplImage = [(*edgeImage) getCvMonotoneImage:240];
    IplImage* debugIplImage = cvCreateImage(cvSize(edgeIplImage->width, edgeIplImage->height), edgeIplImage->depth, 3);
    cvCvtColor(edgeIplImage, debugIplImage, CV_GRAY2BGR);
    
    int source_width = edgeIplImage->width;
    int source_hegiht = edgeIplImage->height;
    
    // fix edge bug
    cvRectangle(edgeIplImage, cvPoint(source_width-2, 0), cvPoint(source_width, source_hegiht), cvScalar(255), CV_FILLED, 8, 0);
    cvRectangle(edgeIplImage, cvPoint(0, source_hegiht-2), cvPoint(source_width, source_hegiht), cvScalar(255), CV_FILLED, 8, 0);
    

    
    while (y<source_hegiht) {
        x = 0;
        double _y = 0;
        while (x<source_width) {
            
            double _x = 0;
            float similarity = 0.0f;
            id<AADataProtcol> matchedData = nil; // AAEdgeData or AAToneData
            
            if(useEdge) {
                for(AAEdgeData* data in edgeTable) {
                    float f = getSimilarity(edgeIplImage, data, x, y);
                    
                    if(f > similarity) {
                        similarity = f;
                        matchedData = data;
                    }
                }
            }
            
            if(similarity < 0) { // End of Line
                break;
            }
            
            NSColor *color = [colorRep colorAtX:x y:y];
            // no match
            if(similarity == 0) {
                if(useTone) {
                    matchedData = [self getToneWithColor:color];
                }
                else {
                   matchedData = self.spaceChar;
                }
            }
            
            // color
            if(useColor && ![matchedData.character isEqualToString:_spaceChar.character]) {
                [aa appendString:[AADomUtil wrapSpanString:matchedData.character withColor:color]];
            }
            else {
                [aa appendString:matchedData.character];
            }
            _x = matchedData.size.width;
            _y = matchedData.size.height;
            
            // draw debug
            cvRectangle(debugIplImage, cvPoint(x, y), cvPoint(x+_x, y+_y), cvScalar(0,0,255), 1, 8, 0);
            
            x += _x;
        }
        [aa appendString:@"\n"];
        y+= _y;
    }
    
    (*edgeImage) = [NSImage imageWithIplImage:edgeIplImage];
    (*colorImage) = [NSImage imageWithIplImage:debugIplImage];
    
    // cleanup
    colorRep = nil;
    cvReleaseImage(&edgeIplImage);
    cvReleaseImage(&debugIplImage);
    
    return aa;
}

- (AAToneData*) getToneWithColor:(NSColor*) color {
    float brightness = color.brightnessComponent;
    int length = (int)_toneData.count;
    
    int i =  (1.0f-brightness) * (float) length;
    
    if(i >= length) {
        i = length -1;
    }
    if(i < 0){
        i = 0;
    }
    
    AAToneData * data = _toneData[i];
    [data nextTone];
    return data;
}

// monotone threthold
static inline BOOL isBlack(IplImage* bmp, const int x, const int y) {
    char *data = bmp->imageData + y * bmp->widthStep + x;
    return (unsigned char) *data == 0;
}

static inline float getCvPreCheck(IplImage* srcBmp, IplImage* charBmp, const int sX, const int sY) {
    
    // check over size
    if((sX+charBmp->width) >= (srcBmp->width)
       || sY+charBmp->height >= srcBmp->height) {
        return -1.0f;
    }
    
    // check white pixel
    int numSrcOn=0;
    int width = charBmp->width;
    int height = charBmp->height;

    for(int cY=0; cY<height; ++cY) {
        for(int cX=0; cX<width; ++cX) {
            BOOL sOn = isBlack(srcBmp, sX+cX, sY+cY);
            if(sOn) numSrcOn++;
        }
    }
    
    
    if(numSrcOn <= (width*height/16)) {
        return 0.0f;
    }
    
    return 1.0f;
}

static inline float getSimilarity(IplImage* srcBmp, AAEdgeData* edge, const int sX, const int sY) {
    IplImage * charBmp = edge.grayImage;
    
    float result = getCvPreCheck(srcBmp, charBmp, sX, sY);
    if(result <= 0) {
        return result;
    }
    
    IplImage* sign = edge.signImage;
    IplImage* buf = edge.signBuffer;
    
    cvSetImageROI(srcBmp, cvRect(sX, sY, charBmp->width, charBmp->height));
    [AACvUtil resizeMonoImage:srcBmp dst:buf];
    cvResetImageROI(srcBmp);
    
    float similarity = 100.0f;
    for(int cY=0; cY<sign->height; ++cY) {
        for(int cX=0; cX<sign->width; ++cX) {
            BOOL cOn = isBlack(sign, cX, cY);
            BOOL sOn = isBlack(buf, cX, cY);
            if(sOn == cOn) {
                similarity+=2;
            }
            else {
                similarity-=5;
            }
        }
    }
    return similarity;
}

@end