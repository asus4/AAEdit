//
//  AAMainViewController.h
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "AAViewModel.h"
#import "AAAsciiTraceView.h"
#import "AAMovieView.h"
#import "AAWebView.h"

@interface AAMainViewController : NSViewController
- (IBAction)loadMovie:(id)sender;
- (IBAction)doTrace:(id)sender;

@property (weak) IBOutlet AAViewModel *viewModel;
@property (weak) IBOutlet AAAsciiTraceView *asciiView;
@property (weak) IBOutlet AATextField *aaTextField;
@property (weak) IBOutlet AAWebView *webView;


@end
