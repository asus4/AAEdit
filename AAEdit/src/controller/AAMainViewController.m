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
}

- (IBAction)doTrace:(id)sender
{
    
    [self.previewEdgeImage setImage:self.asciiView.getEdgeImage];
    [self.previewNormalImage setImage:self.asciiView.getNormalImage];
    
    NSString* aa = [self.viewModel.dataManager asciiTrace:self.asciiView.getEdgeImage
                                               colorImage:self.asciiView.getNormalImage
                                                  useEdge:YES
                                                  useTone:NO
                                                 useColor:YES];
    NSLog(@"AA %@", aa);
    NSString * template = [AAFileUtil loadTextResource:@"template" extensition:@"html"];
    self.viewModel.htmlString = [NSString stringWithFormat:template,self.viewModel.fontSize, aa];
    
}

- (IBAction)save:(id)sender {
    NSString* img_path = [NSString stringWithFormat:@"%@/%i.png", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    NSString* html_path = [NSString stringWithFormat:@"%@/%i.html", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    
    [self.webView saveImageFile:img_path];
    [self.webView saveHtmlFile:html_path];
}

@end
