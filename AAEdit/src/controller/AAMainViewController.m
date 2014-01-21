//
//  AAMainViewController.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/18.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAMainViewController.h"

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
    NSURL *url = [NSURL URLWithString:@"file://localhost/Users/ibu/Projects/HaKU/git/AA/index.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView.mainFrame loadRequest:req];
}

- (IBAction)save:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDesktopDirectory, NSUserDomainMask, YES);
    NSString* path = [NSString stringWithFormat:@"%@/test.png",
                      [paths objectAtIndex:0], nil];
    
    [self.webView saveToFile:path];
}

@end
