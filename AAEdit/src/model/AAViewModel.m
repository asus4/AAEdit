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
        _color = [NSColor clearColor];
        _dataManager = [[AADataManager alloc] init];
    }
    return self;
}

#pragma SETTER GETTER

- (void) setMovieUrl:(NSURL *)movieUrl {
    _movieUrl = movieUrl;
    [self.asciiTraceView loadMovie:movieUrl.path];
    [_dataManager loadMovieFile:movieUrl];
}

- (void) setMoviePosition: (double) value {
    _moviePosition = value;
    self.currentFrame = [self moviePositionToFrame:_moviePosition];
}

- (void) setFps:(int)value {
    _fps = value;
    [self.asciiTraceView setFps:_fps];
}

- (int) getFps {
    return _fps;
}

- (int) moviePositionToFrame:(double)position {
    return (int)(position * [self.asciiTraceView getMovieDuration] * _fps);
}

- (void) setCurrentFrame:(int)currentFrame {
    [self.asciiTraceView setFrames:currentFrame];
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

- (void) setOverlayColor:(NSColor *)overlayColor {
    _color = overlayColor;
    [self.asciiTraceView setOverlayColor:overlayColor];
}

- (void) setEdgeIntensity:(double)edgeIntensity {
    _edgeIntensity = edgeIntensity;
    [self.asciiTraceView setEdgeIntensity:edgeIntensity];
}

- (void) setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    
    NSURL *url = [NSURL URLWithString:@"file://localhost/Users/ibu/Projects/HaKU/git/AA/index.html"];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:url];
}

@end
