//
//  VSJStackViewItem.h
//  VSJStackView
//
//  Created by Vashishtha Jogi on 6/25/13.
//  Copyright (c) 2013 Vashishtha Jogi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VSJStackViewItemState) {
	VSJStackViewItemStateNormal = 0,
	VSJStackViewItemStateFocused = 1,
	VSJStackViewItemStateStashed = 2
};

@interface VSJStackViewItem : UIView

@property (nonatomic) NSInteger index;
@property (nonatomic, assign) VSJStackViewItemState state;
@property (nonatomic) CGRect originalFrame;

@property (nonatomic) CGFloat focusY;
@property (nonatomic) CGFloat stashY;

- (CGRect)restoreFrame;
- (CGRect)focusedFrame;
- (CGRect)stashedFrame;

@end
