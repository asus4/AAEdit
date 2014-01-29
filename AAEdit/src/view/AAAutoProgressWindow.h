//
//  AAAutoProgressWindow.h
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/29.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AAProgressViewModel.h"

@interface AAAutoProgressWindow : NSWindow

@property (unsafe_unretained) IBOutlet AAProgressViewModel *viewModel;
@property (unsafe_unretained) IBOutlet NSProgressIndicator *progressIndicator;


- (void) setProgress:(NSUInteger) current total:(NSUInteger) total;

@end
