//
//  AAMainViewController.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAMainViewController.h"
#import "AAFileUtil.h"

@interface AAMainViewController ()

@property (atomic) BOOL isAutoTracing;
@end

@implementation AAMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)loadMovie:(id)sender
{
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
//    [panel setAllowedFileTypes:@[@"mov"]]; // all file types
    
    if([panel runModal] == NSOKButton) {
        self.viewModel.movieUrl = panel.URL;
    }
    self.viewModel.currentFrame = 0;
}

- (IBAction)doTrace:(id)sender
{
    if(!self.viewModel.isTraceEdge && !self.viewModel.isTraceTone) {
        // alert
        NSAlert * alert = [NSAlert alertWithMessageText:@"Warning"
                                          defaultButton:@"OK"
                                        alternateButton:NULL
                                            otherButton:NULL
                              informativeTextWithFormat:@"Enable Edge or Tone switch."];
        [alert runModal];
        return;
    }
    
    NSImage *edge = self.asciiView.getEdgeImage;
    NSImage *normal = self.asciiView.getNormalImage;
    
    [self.previewEdgeImage setImage:edge];
    [self.previewNormalImage setImage:normal];
    
    NSString* aa = [self.viewModel.dataManager asciiTrace:edge
                                               colorImage:normal
                                                  useEdge:self.viewModel.isTraceEdge
                                                  useTone:self.viewModel.isTraceTone
                                                 useColor:self.viewModel.isTraceColor];
    
    NSString * template = [AAFileUtil loadTextResource:@"template" extensition:@"html"];
    self.viewModel.htmlString = [NSString stringWithFormat:template,self.viewModel.fontSize, self.viewModel.currentFrame, aa];
}


- (IBAction)autoTrace:(id)sender {
    // confirmation
    NSAlert * alert = [NSAlert alertWithMessageText:@"Confirmation"
                                      defaultButton:@"GO" alternateButton:@"Cancel"
                                        otherButton:NULL
                          informativeTextWithFormat:@"Will overwrite all frames?"];
    NSUInteger result = [alert runModal];
    if(result != NSAlertDefaultReturn) {
        return; // cancel
    }
    
    // start auto trace
    _viewModel.moviePosition = 0;
    _viewModel.currentFrame = 0;
    
    // create modal view
    if(!_progressWindow) {
        [NSBundle loadNibNamed:@"AutoTraceProgress" owner:self];
    }
    [self.progressWindow setLevel:NSPopUpMenuWindowLevel];
    [self.progressWindow setProgress:_viewModel.currentFrame total:_viewModel.totalFrames];
    [NSApp beginSheet:self.progressWindow modalForWindow:self.view.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    // start auto trace
    _isAutoTracing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        @autoreleasepool{
            while (_viewModel.currentFrame < _viewModel.totalFrames) {
                if(!_isAutoTracing) {
                    break;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self doTrace:nil];
                    for (id subview in self.webView.subviews) {
                        if ([[subview class] isSubclassOfClass: [NSScrollView class]]) {
                            ((NSScrollView *)subview).hasHorizontalScroller = NO;
                            ((NSScrollView *)subview).hasHorizontalRuler = NO;
                        }
                    }
                });
                
                [NSThread sleepForTimeInterval:0.5];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self save:nil];
                    _viewModel.currentFrame++;
                    [self.progressWindow setProgress:_viewModel.currentFrame total:_viewModel.totalFrames];
                });
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self cancelAutoTrace:nil];
            });

        }
    });
    
}

- (IBAction)save:(id)sender {
    NSString* img_path = [NSString stringWithFormat:@"%@/%i.png", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    NSString* html_path = [NSString stringWithFormat:@"%@/%i.html", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    NSString* txt_path = [NSString stringWithFormat:@"%@/%i.txt", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    
    [self.webView saveImageFile:img_path];
    [self.webView saveHtmlFile:html_path];
    [self.webView saveIdOuterHtml:@"pre" path:txt_path]; // TODO : implemented
}

- (IBAction)cancelAutoTrace:(id)sender {
    if(_isAutoTracing) {
        _isAutoTracing = NO;
        [NSApp endSheet:self.progressWindow];
        [self.progressWindow close];
    }
}

@end
