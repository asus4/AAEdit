//
//  NSImage+OpenCV.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/27.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//


// http://stackoverflow.com/questions/8563356/nsimage-to-cvmat-and-vice-versa

#import "NSImage+OpenCV.h"


@implementation NSImage (OpenCV)

#pragma mark class method

+ (NSImage*) imageWithIplImage:(IplImage *)iplImage {
//    http://article.gmane.org/gmane.comp.lib.opencv/14808

    NSString* colorspace;

    
    if(iplImage->nChannels == 1) {
        colorspace = NSDeviceWhiteColorSpace;
    }
    else {
        colorspace = NSDeviceRGBColorSpace;
    }
    
    int nChannels = iplImage->nChannels;
    BOOL hasAlpha = iplImage->nChannels >= 4 ? YES : NO;
    char *d = iplImage->imageData;
    NSUInteger colors[nChannels];
    int width = iplImage->width;
    int height = iplImage->height;
    int bytePerRow = iplImage->widthStep;
    
//    NSLog(@"NSImage hasAlpha:%d ch:%d", hasAlpha, nChannels);
    
    NSBitmapImageRep *bmp = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                    pixelsWide:width
                                                                    pixelsHigh:height
                                                                 bitsPerSample:iplImage->depth samplesPerPixel:nChannels
                                                                      hasAlpha:hasAlpha
                                                                      isPlanar:NO
                                                                colorSpaceName:colorspace bytesPerRow:bytePerRow
                                                                  bitsPerPixel:0];
    
    for(int y=0; y<iplImage->height; ++y) {
        for(int x=0; x<iplImage->width; ++x) {
            if(nChannels == 3){
				colors[0] = (unsigned int) d[(y * bytePerRow) + (x*3)];
				colors[1] = (unsigned int) d[(y * bytePerRow) + (x*3)+1];
				colors[2] = (unsigned int) d[(y * bytePerRow) + (x*3)+2];
			}
            else if(nChannels == 4) {
                colors[0] = (unsigned int) d[(y * bytePerRow) + (x*4)];
				colors[1] = (unsigned int) d[(y * bytePerRow) + (x*4)+1];
				colors[2] = (unsigned int) d[(y * bytePerRow) + (x*4)+2];
                colors[3] = (unsigned int) d[(y * bytePerRow) + (x*4)+3];
            }
			else{
				colors[0] = (unsigned int)d[(y * bytePerRow) + x];
			}
            [bmp setPixel:colors atX:x y:y];
        }
    }
    
    return [[NSImage alloc] initWithData:[bmp TIFFRepresentation]];
}

#pragma mark properties

- (cv::Mat) CVGrayscaleMat {
    cv::Mat mat;
    return mat;
}

- (IplImage*) cvImage {
    NSBitmapImageRep *bmp = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
    
    int depth       = (int) bmp.bitsPerSample;
    int channels    = (int) bmp.samplesPerPixel;
    int width       = (int) bmp.pixelsWide;
    int height      = (int) bmp.pixelsHigh;
    
    IplImage *iplImage = cvCreateImage(cvSize(width, height), depth, channels);
    cvSetData(iplImage, bmp.bitmapData, (int)bmp.bytesPerRow);
    
    // release
    bmp = nil;
    return iplImage;
}

- (IplImage*) cvGrayImage {
    
    IplImage* img = self.cvImage;
    if(img->nChannels == 1) {
        return img;
    }
    // else ... convert color to grayscale
    
    IplImage *grayImage = cvCreateImage(cvSize(img->width, img->height), img->depth, 1);
    cvCvtColor(img, grayImage, CV_RGB2GRAY);
    
    // release
//    cvReleaseImage(&img);
    
    return  grayImage;
}

@end
