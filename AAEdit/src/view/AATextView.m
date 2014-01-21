//
//  AATextView.m
//  AAGenerator
//
//  Created by Koki Ibukuro on 2014/01/17.
//  Copyright (c) 2014年 Koki Ibukuro. All rights reserved.
//

#import "AATextView.h"

@implementation AATextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) awakeFromNib {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    [style setLineHeightMultiple:12];
    [style setLineSpacing:10];
    [self setDefaultParagraphStyle:style];
    style = nil;
}

@end
