//
//  AAViewModel.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/19.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAViewModel.h"
#import "AAEdgeData.h"
#import "NSArrayController+Addition.h"
#import "NSUserDefaults+Addition.h"

@implementation AAViewModel

- (id) init {
    if(self = [super init]) {
        _dataManager = [[AADataManager alloc] init];
    }
    return self;
}

- (void) load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.movieUrl = [defaults URLForKey:@"movieUrl"];
    self.fps = [defaults integerForKey:@"fps"];
    self.toneString = [defaults stringForKey:@"toneString"];
    self.edgeString = [defaults stringForKey:@"edgeString"];
    self.fontSize = [defaults integerForKey:@"fontSize"];
    self.overlayColor = [defaults colorForKey:@"overlayColor"];
    
    self.isTraceEdge = [defaults boolForKey:@"isTraceEdge"];
    self.isTraceTone = [defaults boolForKey:@"isTraceTone"];
    self.isTraceColor = [defaults boolForKey:@"isTraceColor"];
}

- (void) save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setURL:self.movieUrl forKey:@"movieUrl"];
    [defaults setInteger:self.fps forKey:@"fps"];
    [defaults setObject:self.toneString forKey:@"toneString"];
    [defaults setObject:self.edgeString forKey:@"edgeString"];
    [defaults setInteger:self.fontSize forKey:@"fontSize"];
    [defaults setColor:self.overlayColor forKey:@"overlayColor"];
    
    [defaults setBool:self.isTraceEdge forKey:@"isTraceEdge"];
    [defaults setBool:self.isTraceTone forKey:@"isTraceTone"];
    [defaults setBool:self.isTraceColor forKey:@"isTraceColor"];
    
    [defaults synchronize];
}


#pragma mark SETTER GETTER

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
    _overlayColor = overlayColor;
    [self.asciiTraceView setOverlayColor:overlayColor];
}

- (void) setEdgeIntensity:(double)edgeIntensity {
    _edgeIntensity = edgeIntensity;
    [self.asciiTraceView setEdgeIntensity:edgeIntensity];
}

- (void) setFontSize:(uint)fontSize {
    _fontSize = fontSize;
    self.dataManager.fontSize = fontSize;
    self.edgeString = self.edgeString; // update edge data
}

- (void) setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    
    NSURL *url = [NSURL fileURLWithPath: [_dataManager.directoryPath stringByAppendingString:@"/"]];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:url];
}

- (void) setToneString:(NSString *)toneString {
    _toneString = toneString;
    [self.dataManager setToneString:toneString];
    
    // update talbe
    NSArray * arr = [self.dataManager getToneTableData];
    [self.toneArrayController removeAllObjects];
    [self.toneArrayController addObjects:arr];
}

- (void) setEdgeString:(NSString *)edgeString {
    _edgeString = edgeString;
    [self.dataManager setEdgeString:edgeString];
    
    // update table
    NSArray * arr = [self.dataManager getEdgeTableData];
    [self.edgeArrayController removeAllObjects];
    [self.edgeArrayController addObjects:arr];
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
