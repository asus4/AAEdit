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
// atomic
@property (atomic) BOOL isAutoTracing;
@property (atomic) BOOL isHtmlOnly;
@property (atomic) BOOL isLoadedWebview;

@end

@implementation AAMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        _isLoadedWebview = NO;
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

- (void) trace:(void (^)(void))onComplete {
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
    
    NSImage *edge = _asciiView.getEdgeImage;
    NSImage *normal = _asciiView.getNormalImage;
    
    
    NSString* aa = [_viewModel.dataManager asciiTrace:&edge
                                           colorImage:&normal
                                              useEdge:_viewModel.isTraceEdge
                                              useTone:_viewModel.isTraceTone
                                             useColor:_viewModel.isTraceColor];
    
    [self.previewEdgeImage setImage:edge];
    [self.previewNormalImage setImage:normal];
    
    NSString * template = [AAFileUtil loadTextResource:@"template" extensition:@"html"];
    
    NSString* overflow = self.viewModel.overflowMode ? @"hidden" : @"auto";
    self.viewModel.htmlString = [NSString stringWithFormat:template,
                                 overflow,
                                 self.viewModel.fontSize,
                                 self.viewModel.currentFrame,
                                 aa];
}

- (IBAction)doTrace:(id)sender
{
    [self trace:nil];
}

- (void) traceThread {
    // confirmation
    NSAlert * alert = [NSAlert alertWithMessageText:@"Confirmation"
                                      defaultButton:@"GO" alternateButton:@"Cancel"
                                        otherButton:NULL
                          informativeTextWithFormat:@"Will overwrite all frames?"];
    NSUInteger result = [alert runModal];
    if(result != NSAlertDefaultReturn) {
        return; // cancel auto trace
    }
    
    self.webView.frameLoadDelegate = self;
    
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
        // threaded block
        @autoreleasepool{
            while (_viewModel.currentFrame < _viewModel.totalFrames) {
                if(!_isAutoTracing) {
                    break;
                }
                
                self.isLoadedWebview = NO;
                
                // trace
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(!_isHtmlOnly) {
                        [self trace:nil];
                    }
                    else {
                        self.isLoadedWebview = YES;
                    }
                    // hide scrollbar
                    for (id subview in self.webView.subviews) {
                        if ([[subview class] isSubclassOfClass: [NSScrollView class]]) {
                            ((NSScrollView *)subview).hasHorizontalScroller = NO;
                            ((NSScrollView *)subview).hasHorizontalRuler = NO;
                        }
                    }
                });
                
                // wait for webview load
                while (self.isLoadedWebview == NO) {
                    [NSThread sleepForTimeInterval:0.01];
                }
                
                // save file
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self save:nil];
                    self.isLoadedWebview = NO;
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

- (IBAction)autoTrace:(id)sender {
    _isHtmlOnly = NO;
    [self traceThread];
}

- (IBAction)autoHtmlRendering:(id)sender {
    _isHtmlOnly = YES;
    [self traceThread];
}

- (IBAction)save:(id)sender {
    NSString* img_path = [self.viewModel getSavePath:@"png"];
    NSString* html_path = [self.viewModel getSavePath:@"html"];
    NSString* txt_path = [self.viewModel getSavePath:@"txt"];
    
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

- (IBAction)biggerFont:(id)sender {
    self.viewModel.fontSize++;
}

- (IBAction)smallerFont:(id)sender {
    if(self.viewModel.fontSize > 4) {
        self.viewModel.fontSize--;
    }
}

- (IBAction)loadPremiereMarker:(id)sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:@[@"csv"]]; // all file types
    
    if([panel runModal] == NSOKButton) {
        [self.viewModel loadPremiereMarker:panel.URL];
    }
}

- (IBAction)resetSetting:(id)sender {
    // confirmation
    NSAlert * alert = [NSAlert alertWithMessageText:@"Confirmation"
                                      defaultButton:@"RESET"
                                    alternateButton:@"Cancel"
                                        otherButton:NULL
                          informativeTextWithFormat:@"Do you reset all settgin?"];
    NSUInteger result = [alert runModal];
    if(result != NSAlertDefaultReturn) {
        return; // cancel
    }
    
    // Delete user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removePersistentDomainForName:appDomain];
    
    // Reload model
    [self.viewModel load];
}

#pragma mark --
#pragma mark delegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if(frame == _webView.mainFrame) {
        self.isLoadedWebview = YES; // atomic
    }
}
@end
