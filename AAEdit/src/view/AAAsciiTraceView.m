//
//  AAAsciiTraceView.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAAsciiTraceView.h"
#import "NSImage+Addition.h"

// input keys
#define _KEY_MOVIE_LOCATION @"MovieLocation"
#define _KEY_PLAYBACK_MODE @"PlaybackMode"
#define _KEY_FPS @"Fps"
#define _KEY_FRAMES @"Frames"
#define _KEY_USE_FILTER @"UseFilter"
#define _KEY_OVERLAY_COLOR @"OverlayColor"
#define _KEY_EDGE_INTENSITY @"EdgeIntensity"
// output keys
#define _KEY_MOVIE_DURATION @"MovieDuration"
#define _KEY_EDGE_IMAGE @"EdgeImage"
#define _KEY_NORMAL_IMAGE @"NormalImage"

@implementation AAAsciiTraceView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) viewDidMoveToWindow
{
    NSRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    _qcView = [[QCView alloc] initWithFrame:frame];
    [self addSubview:_qcView];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"player" ofType:@"qtz"];
    
    if(![_qcView loadCompositionFromFile:file]) {
        NSLog(@"failed to load");
        return;
    }
    [_qcView startRendering];
    
    // Listen terminate
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
}

- (void) applicationWillTerminate:(NSNotification *)aNotification
{
    // unload QC on finish
    [_qcView stopRendering];
    [_qcView unloadComposition];
    _qcView = nil;
}

#pragma Quartz Composer Interface
- (void) loadMovie:(NSString *)file {
    [_qcView setValue:file forInputKey:_KEY_MOVIE_LOCATION];
}

- (void) setFps:(double)fps {
    [_qcView setValue:[NSNumber numberWithDouble:fps] forInputKey:_KEY_FPS];
}

- (void) setFrames:(int)frame {
    [_qcView setValue:[NSNumber numberWithInt:frame] forInputKey:_KEY_FRAMES];
}

- (void) setPlaybackMode:(BOOL)isPlayback {
    [_qcView setValue:[NSNumber numberWithBool:isPlayback] forInputKey:_KEY_PLAYBACK_MODE];
}

- (void) setUseFilter:(BOOL)useFilter {
    [_qcView setValue:[NSNumber numberWithBool:useFilter] forInputKey:_KEY_USE_FILTER];
}

- (void) setOverlayColor:(NSColor*)color {
    [_qcView setValue:color forInputKey:_KEY_OVERLAY_COLOR];
}

- (void) setEdgeIntensity:(double)intensity {
    [_qcView setValue:[NSNumber numberWithDouble:intensity] forInputKey:_KEY_EDGE_INTENSITY];
}

- (double) getMovieDuration {
    return [[_qcView valueForOutputKey:_KEY_MOVIE_DURATION] doubleValue];
}

- (NSImage*) getEdgeImage {
    NSImage* img = [_qcView valueForOutputKey:_KEY_EDGE_IMAGE];
    if(img.size.width == self.frame.size.width &&
       img.size.height == self.frame.size.height) {
        return img;
    }
    return [img resizeImage:self.frame.size scaleFactor:self.window.backingScaleFactor];
}

- (NSImage*) getNormalImage {
    NSImage* img = [_qcView valueForOutputKey:_KEY_NORMAL_IMAGE];
    if(img.size.width == self.frame.size.width &&
       img.size.height == self.frame.size.height) {
        return img;
    }
    return [img resizeImage:self.frame.size scaleFactor:self.window.backingScaleFactor];
}

@end
