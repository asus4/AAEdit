//
//  AAAppDelegate.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/20.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAAppDelegate.h"

@implementation AAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // register userdefaults
    NSString * userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"];
    NSDictionary *userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
    
    [self.viewModel load];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.viewModel save];
}
@end
