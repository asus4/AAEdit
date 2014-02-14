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
#import "AAAutoProgressWindow.h"

@interface AAMainViewController : NSViewController
- (IBAction)loadMovie:(id)sender;
- (IBAction)doTrace:(id)sender;
- (IBAction)autoTrace:(id)sender;
- (IBAction)autoHtmlRendering:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancelAutoTrace:(id)sender;
- (IBAction)biggerFont:(id)sender;
- (IBAction)smallerFont:(id)sender;
- (IBAction)loadPremiereMarker:(id)sender;


@property (weak) IBOutlet AAViewModel *viewModel;
@property (weak) IBOutlet AAAsciiTraceView *asciiView;
@property (weak) IBOutlet AAWebView *webView;

@property (weak) IBOutlet AAAutoProgressWindow *progressWindow;

@property (weak) IBOutlet NSImageView *previewEdgeImage;
@property (weak) IBOutlet NSImageView *previewNormalImage;

@end
