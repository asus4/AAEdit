//
//  AAViewModel.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/19.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAViewModel.h"

@implementation AAViewModel

- (id) init {
    if(self = [super init]) {
        // TODO: load recent settings
        _fps = 30;
    }
    return self;
}


#pragma SETTER GETTER

- (void) setMoviePosition: (double) value {
    _moviePosition = value;
    [self updateCurrentFrame];
    [self.asciiTraceView setFrames:self.currentFrame];
}

- (void) setFps:(int)value {
    _fps = value;
    [self.asciiTraceView setFps:_fps];
}

- (int) getFps {
    return _fps;
}

- (void) updateCurrentFrame {
    self.currentFrame = (int)(_moviePosition * [self.asciiTraceView getMovieDuration] * _fps);
}

- (int) getCurrentFrame {
    return _currentFrame;
}

- (int) getTotalFrames {
    return [self.asciiTraceView getMovieDuration] * self.fps;
}

- (void) setPlaybackMode:(bool)playbackMode {
    _playbackMode = playbackMode;
    [self.asciiTraceView setPlaybackMode:playbackMode];
}

- (void) setUseFilter:(bool)useFilter {
    _useFilter = useFilter;
    [self.asciiTraceView setUseFilter:useFilter];
}

@end
