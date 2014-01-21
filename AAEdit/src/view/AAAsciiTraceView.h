//
//  AAAsciiTraceView.h
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface AAAsciiTraceView : NSView

@property (strong, nonatomic, readonly) QCView * qcView;

// qc interface
- (void) loadMovie:(NSString*) file;
- (void) setFps:(double) fps;
- (void) setFrames:(int) frame;
- (void) setPlaybackMode:(BOOL) isPlayback;
- (void) setUseFilter:(BOOL) useFilter;
- (void) setOverlayColor:(NSColor*) color;
- (void) setEdgeIntensity:(double) intensity;

- (double) getMovieDuration;

@end
