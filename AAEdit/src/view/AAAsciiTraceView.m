//
//  AAAsciiTraceView.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAAsciiTraceView.h"

// input keys
#define _KEY_MOVIE_LOCATION @"MovieLocation"
#define _KEY_PLAYBACK_MODE @"PlaybackMode"
#define _KEY_FPS @"Fps"
#define _KEY_FRAMES @"Frames"
#define _KEY_USE_FILTER @"UseFilter"
// output keys
#define _KEY_MOVIE_DURATION @"MovieDuration"

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
    
    if([_qcView loadCompositionFromFile:file] == YES) {
    } {
        NSLog(@"failed to load"); // ???
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
    NSLog(@"load move %@", file);
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

- (double) getMovieDuration {
    return [[_qcView valueForOutputKey:_KEY_MOVIE_DURATION] doubleValue];
}
@end
