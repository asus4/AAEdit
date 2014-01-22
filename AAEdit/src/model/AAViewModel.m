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
        _dataManager = [[AADataManager alloc] init];
    }
    return self;
}

- (void) load {
    // TODO: load recent settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.movieUrl = [defaults URLForKey:@"movieUrl"];
    self.fps = [defaults integerForKey:@"fps"];
    self.toneString = [defaults stringForKey:@"toneString"];
    self.edgeString = [defaults stringForKey:@"edgeString"];
    self.overlayColor = [NSColor clearColor];
}

- (void) save {
    // TODO: save settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setURL:self.movieUrl forKey:@"movieUrl"];
    [defaults setInteger:self.fps forKey:@"fps"];
    [defaults setObject:self.toneString forKey:@"toneString"];
    [defaults setObject:self.edgeString forKey:@"edgeString"];
    [defaults synchronize];
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
    _currentFrame = currentFrame;
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
    
    NSURL *url = [NSURL URLWithString: [_dataManager.directoryPath stringByAppendingString:@"/"]];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:url];
}

- (void) setToneString:(NSString *)toneString {
    _toneString = toneString;
    NSLog(@"set tone string　%@", toneString);
}

- (void) setEdgeString:(NSString *)edgeString {
    _edgeString = edgeString;
    NSLog(@"set dege string %@", edgeString);
}

#pragma mark actions

- (IBAction)nextFrame:(id)sender {
    if(self.currentFrame+1 < self.totalFrames) {
        self.currentFrame++;
    }
}

- (IBAction)prevFrame:(id)sender {
    if(self.currentFrame > 0) {
        self.currentFrame--;
    }
}
@end
