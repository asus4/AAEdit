//
//  AAViewModel.h
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/19.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAsciiTraceView.h"
#import "AATextField.h"
#import "AAWebView.h"
#import "AADataManager.h"

@interface AAViewModel : NSObject {
    AADataManager * _dataManager;
    
    NSURL * _movieUrl;
    double _moviePosition;
    int _fps;
    int _currentFrame;
    bool _playbackMode;
    bool _useFilter;
    NSColor *_overlayColor;
    double _edgeIntensity;
    NSString * _htmlString;
}

@property (weak) IBOutlet AAAsciiTraceView *asciiTraceView;
@property (weak) IBOutlet AAWebView *webView;
@property (weak) IBOutlet NSArrayController *edgeArrayController;
@property (weak) IBOutlet NSArrayController *toneArrayController;

@property (nonatomic) AADataManager * dataManager;

// Bindings
// movie
@property (nonatomic, setter = setMovieUrl:) NSURL * movieUrl;
@property (nonatomic, setter = setMoviePositon:) double moviePosition;

// UI
@property (nonatomic, setter = setFps:, getter = getFps) int fps;
@property (nonatomic, setter = setCurrentFrame:, getter = getCurrentFrame) int currentFrame;
@property (nonatomic, getter = getTotalFrames) int totalFrames;
@property (nonatomic, setter = setPlaybackMode:) bool playbackMode;
@property (nonatomic, setter = setUseFilter:) bool useFilter;
@property (nonatomic, setter = setOverlayColor:) NSColor* overlayColor;
@property (nonatomic, setter = setEdgeIntensity:) double edgeIntensity;

@property (nonatomic) BOOL isTraceEdge;
@property (nonatomic) BOOL isTraceTone;
@property (nonatomic) BOOL isTraceColor;

// Font
@property (nonatomic, setter = setFontSize:) uint fontSize;

// Text
@property (nonatomic, setter = setHtmlString:) NSString * htmlString;
@property (nonatomic, setter = setToneString:) NSString * toneString;
@property (nonatomic, setter = setEdgeString:) NSString * edgeString;

- (IBAction)nextFrame:(id)sender;
- (IBAction)prevFrame:(id)sender;

- (NSString*) getSavePath:(NSString*) extension;
- (BOOL) hasSavedFile:(NSString*) extension;

// save data
- (void) load;
- (void) save;
@end
