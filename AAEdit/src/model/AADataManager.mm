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

#include <opencv2/legacy/compat.hpp>

@implementation AADataManager

#define _FONT_NAME @"IPAMonaPGothic"
#define _BLACK_TOLERANCE 170

#pragma mark public

static IplImage* templeteResult;

- (id) init {
    if(self = [super init]) {
        // initialize
        _directoryPath = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory, NSUserDomainMask, YES)[0];
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
    [AAFileUtil createFolder:_directoryPath];
    
    // copy font file
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"ipagp-mona" ofType:@"woff"];
    [AAFileUtil copyFile:fontPath toDirectory:_directoryPath name:@"ipagp-mona.woff"];
}

- (void) setEdgeString:(NSString *)edgeString {
    [self.edgeData removeAllObjects];
    
    for(uint i=0; i<edgeString.length; ++i) {
        UniChar c = [edgeString characterAtIndex:i];
        if([AADomUtil isEscape:c]) { // avoid escape characters
            continue;
        }
        self.edgeData[[NSNumber numberWithUnsignedShort:c]] = [[AAEdgeData alloc] initWithCharacter:c font:self.font];
    }
    
    // 全角スペース
    NSString * space = @"　";
    _spaceChar = [[AAEdgeData alloc] initWithCharacter:[space characterAtIndex:0] font:self.font];
}

- (void) setToneString:(NSString *)toneString {
    [self.toneData removeAllObjects];
    
    NSArray * arr = [toneString componentsSeparatedByString:@"\n"];
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

- (NSString*) asciiTrace:(NSImage *) edgeImage colorImage:(NSImage *) colorImage useEdge:(BOOL) useEdge useTone:(BOOL)useTone useColor:(BOOL) useColor {
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
    
    NSBitmapImageRep *colorRep = [colorImage getBitmapImageRep];
//    AABitmap edgeBmp;
//    NSBitmapImageRep *edgeRep = [edgeImage getAABitmap:&edgeBmp];
//    edgeBmp.buffer = edgeRep.bitmapData;
    
    IplImage* edgeIplImage = [edgeImage getCvMonotoneImage:200];
    
    int source_width = edgeIplImage->width;
    int source_hegiht = edgeIplImage->height;
    
    while (y<source_hegiht) {
        x = 0;
        double _y = 0;
        while (x<source_width) {
            
            double _x = 0;
            float similarity = 0.0f;
            id<AADataProtcol> matchedData = nil; // AAEdgeData or AAToneData
            
            if(useEdge) {
                for(AAEdgeData* data in edgeTable) {
//                    float f = getSimilarity(&edgeBmp, [data getAABitmapRef], x, y);
//                    float f = getCvSimilarity(edgeIplImage, [data grayImage], x, y);
//                    getCvSimilaritySurf(edgeIplImage, [data grayImage], x, y);
                    float f = getCvSimilarityContours(edgeIplImage, [data grayImage], x, y);
                    
                    if(f > similarity) { //
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
            
            x += _x;
        }
        [aa appendString:@"\n"];
        y+= _y;
    }
    
//    edgeRep = nil;
    colorRep = nil;
    
    cvReleaseImage(&edgeIplImage);
    
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

// rgb color black threthold
static inline BOOL isBlackPixel(AABitmapRef bmp, const int x, const int y) {
    UInt8*  pixelPtr = bmp->buffer + (int)y * bmp->bytesPerRow + (int)x * 4;
    UInt8 r = *(pixelPtr);
    UInt8 g = *(pixelPtr + 1);
    UInt8 b = *(pixelPtr + 2);
//    UInt8 a = *(pixelPtr + 3); // ignore alpha
    return (r + g + b < _BLACK_TOLERANCE);
}

// monotone threthold
static inline BOOL isBlack(IplImage* bmp, const int x, const int y) {
    char *data = bmp->imageData + y * bmp->widthStep + x;
    return (unsigned char) *data == 0;
//    return (b < _BLACK_TOLERANCE);
}

static inline float getCvPreCheck(IplImage* srcBmp, IplImage* charBmp, const int sX, const int sY) {
    // check over size
    if((sX+charBmp->width) >= (srcBmp->width)
       || sY+charBmp->height >= srcBmp->height) {
        return -1.0f;
    }
    
    // check white pixel
    int numSrcOn=0;
    for(int cY=0; cY<charBmp->height; ++cY) {
        for(int cX=0; cX<charBmp->width; ++cX) {
            BOOL sOn = isBlack(srcBmp, sX+cX, sY+cY);
            if(sOn) numSrcOn++;
        }
    }
    if(numSrcOn == 0) {
        return 0.0f;
    }
    
    return 1.0f;
}

static inline float getCvSimilarityContours(IplImage* srcBmp, IplImage* charBmp, const int sX, const int sY) {
    // precheck oversize and white
    float result = getCvPreCheck(srcBmp, charBmp, sX, sY);
    if(result <= 0) {
        return result;
    }
    
    cvSetImageROI(srcBmp, cvRect(sX, sY, charBmp->width, charBmp->height));
    
    CvMemStorage *srcStorage = cvCreateMemStorage (0);
    CvMemStorage *charStorage = cvCreateMemStorage(0);
    CvSeq *srcContours = NULL, *charContours = NULL;
    
    int srcNum = cvFindContours(srcBmp,
                                srcStorage,
                                &srcContours,
                                sizeof(CvContour),
                                CV_RETR_LIST,
                                CV_CHAIN_APPROX_NONE);
    
    int chrNum = cvFindContours(charBmp,
                                charStorage,
                                &charContours,
                                sizeof(CvContour),
                                CV_RETR_LIST,
                                CV_CHAIN_APPROX_NONE);
    
    
    if(srcNum == 0 || chrNum ==0) {
        result = 0.0001;
    }
    else {
        double similarity = cvMatchShapes(srcContours, charContours, CV_CONTOURS_MATCH_I3, 0);
        
        if(similarity == 0) {
            result = 0.000001;
        }
        else {
            result = 10.0 - similarity;
        }
//        NSLog(@"src:%d chr:%d smi:%f", srcNum, chrNum, similarity);
    }
    
    // cleanup
    cvResetImageROI(srcBmp);
    cvReleaseMemStorage(&srcStorage);
    cvReleaseMemStorage(&charStorage);
    
    return result;
}

// use SURF method
static inline float getCvSimilaritySurf(IplImage* srcBmp, IplImage* charBmp, const int sX, const int sY) {
    // precheck oversize and white
    float result = getCvPreCheck(srcBmp, charBmp, sX, sY);
    if(result <= 0) {
        return result;
    }
    
    // surf algorithm
    cvSetImageROI(srcBmp, cvRect(sX, sY, charBmp->width, charBmp->height));
    
    CvSeq *keypoints1 = 0, *descriptors1 = 0;
    CvSeq *keypoints2 = 0, *descriptors2 = 0;
    CvMemStorage* storage = cvCreateMemStorage(0);
    CvSURFParams params = cvSURFParams(600, 1);
    
    cvExtractSURF(srcBmp, 0, &keypoints1, &descriptors1, storage, params, 500);
    cvExtractSURF(charBmp, 0, &keypoints2, &descriptors2, storage, params, 500);
    
    if(descriptors2->total != 0 || descriptors1->total != 0) {
        NSLog(@"key num : %d %d",descriptors1->total, descriptors2->total);
    }
    
    // creanup
    cvClearSeq(keypoints1);
    cvClearSeq(descriptors1);
    cvClearSeq(keypoints2);
    cvClearSeq(descriptors2);
    cvReleaseMemStorage(&storage);
    
    cvResetImageROI(srcBmp);
    
    return 0;
}

// -1: out of boarder
// 0 : white pixel
// ~ : similarity
static inline float getCvSimilarity(IplImage* srcBmp, IplImage* charBmp,const int sX, const int sY) {
    
    // precheck oversize and white
    float result = getCvPreCheck(srcBmp, charBmp, sX, sY);
    if(result <= 0) {
        return result;
    }
    
    // calc similarity
    cvSetImageROI(srcBmp, cvRect(sX, sY, charBmp->width, charBmp->height));
    double similarity = cvMatchShapes(srcBmp, charBmp, CV_CONTOURS_MATCH_I1, 0);
    
//    cvMatchTemplate(srcBmp, charBmp, templeteResult, CV_TM_SQDIFF);
//    char * c = templeteResult->imageData;
//    double similarity = *c;
    
    cvResetImageROI(srcBmp);
    
    return 1.0f - similarity;
}

// bitmap matching algorithm
static inline float getSimilarity(AABitmapRef srcBmp, AABitmapRef charBmp, const int sX, const int sY) {
    
    if((sX+charBmp->width) >= (srcBmp->width)
       || sY+charBmp->height >= srcBmp->height) {
        return -1.0f;
    }
    
    float similarity = 0.1f;
    int numSrcOn=0, numCharOn=0;
    
    for(int cY=0; cY<charBmp->height; ++cY) {
        for(int cX=0; cX<charBmp->width; ++cX) {
            BOOL cOn = isBlackPixel(charBmp, cX, cY);
            BOOL sOn = isBlackPixel(srcBmp, sX+cX, sY+cY);
            
            if(sOn) numSrcOn++;
            if(cOn) numCharOn++;
            
            if(sOn == cOn) { // on on || off off
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