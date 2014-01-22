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
    self.viewModel.htmlString = [AAFileUtil loadTextResource:@"template" extensition:@"html"];
    
    [self.previewImage setImage:self.asciiView.getEdgeImage];
    
    DOMDocument * dd = self.webView.mainFrame.DOMDocument;
    NSLog(@"DOM %@", dd);
}

- (IBAction)save:(id)sender {
    NSString* path = [NSString stringWithFormat:@"%@/%i.png", self.viewModel.dataManager.directoryPath, self.viewModel.currentFrame];
    [self.webView saveToFile:path];
}

@end
