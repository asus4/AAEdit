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
        [self.asciiView loadMovie:panel.URL.path];
    }
}

- (IBAction)doTrace:(id)sender
{
    NSLog(@"text field : %@", self.aaTextField.stringValue);
    
    NSURL *url = [NSURL URLWithString:@"file://localhost/Users/ibu/Projects/HaKU/git/AA/index.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView.mainFrame loadRequest:req];
}

@end
