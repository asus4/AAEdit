//
//  AAAutoProgressWindow.m
//  AAEdit
//
//  Created by Koki Ibukuro on 2014/01/29.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AAAutoProgressWindow.h"

@implementation AAAutoProgressWindow

-(void) awakeFromNib {
    [self.progressIndicator startAnimation:self];
}

- (void) setProgress:(NSUInteger)current total:(NSUInteger)total {
    self.viewModel.currentFrame = current;
    self.viewModel.toralFrame = total;
    [self.progressIndicator startAnimation:self];
}
@end
