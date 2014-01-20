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

@interface AAViewModel : NSObject {
    double _moviePosition;
    int _fps;
    int _currentFrame;
    bool _playbackMode;
    bool _useFilter;
}

@property (weak) IBOutlet AAAsciiTraceView *asciiTraceView;
@property (weak) IBOutlet AATextField *aaTextField;

@property (nonatomic, setter = setMoviePositon:) double moviePosition;
@property (nonatomic, setter = setFps:, getter = getFps) int fps;
@property (nonatomic, getter = getCurrentFrame) int currentFrame;
@property (nonatomic, getter = getTotalFrames) int totalFrames;
@property (nonatomic, setter = setPlaybackMode:) bool playbackMode;
@property (nonatomic, setter = setUseFilter:) bool useFilter;
@end
