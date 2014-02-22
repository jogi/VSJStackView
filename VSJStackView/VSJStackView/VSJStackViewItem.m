//
//  VSJStackViewItem.m
//  VSJStackView
//
//  Created by Vashishtha Jogi on 6/25/13.
//  Copyright (c) 2013 Vashishtha Jogi. All rights reserved.
//

#import "VSJStackViewItem.h"

@implementation VSJStackViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		_state = VSJStackViewItemStateNormal;
		_focusY = 0;
		_stashY = 0;
    }
    return self;
}

- (CGRect)restoreFrame
{
    return self.originalFrame;
}

- (CGRect)focusedFrame
{
    return CGRectMake(self.frame.origin.x, self.focusY, self.frame.size.width, self.frame.size.height);
}

- (CGRect)stashedFrame
{
    return CGRectMake(self.frame.origin.x, self.stashY, self.frame.size.width, self.frame.size.height);
}

@end
