//
//  VSJStackView.h
//  VSJStackView
//
//  Created by Vashishtha Jogi on 6/25/13.
//  Copyright (c) 2013 Vashishtha Jogi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSJStackViewItem.h"

@class VSJStackView;
@protocol VSJStackViewDataSource;


@protocol VSJStackViewDelegate <NSObject>

@required

- (CGSize)stackView:(VSJStackView *)stackView sizeForRowAtIndex:(NSInteger)index;

@optional

- (CGFloat)stackViewHeightForHeader;

// Section header information. Views are preferred over title should you decide to provide both

- (UIView *)stackViewForHeader;   // custom view for header. will be adjusted to default or specified header height

// focus

- (void)stackView:(VSJStackView *)stackView willFocusRowAtIndex:(NSInteger)index;
- (void)stackView:(VSJStackView *)stackView didFocusRowAtIndex:(NSInteger)index;
- (void)stackView:(VSJStackView *)stackView willDefocusRowAtIndex:(NSInteger)index;
- (void)stackView:(VSJStackView *)stackView didDefocusRowAtIndex:(NSInteger)index;

// select

- (void)stackView:(VSJStackView *)stackView didSelectRowAtIndex:(NSInteger)index;

// stash

- (void)stackView:(VSJStackView *)stackView didStashAllExceptRowAtIndex:(NSInteger)index;

// restore

- (void)stackView:(VSJStackView *)stackView didRestoreAllRows:(BOOL)succeeded;

@end


@interface VSJStackView : UIScrollView

@property (nonatomic, assign) id <VSJStackViewDataSource> stackViewDataSource;
@property (nonatomic, assign) id <VSJStackViewDelegate> stackViewDelegate;
@property (nonatomic) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic) CGFloat sectionHeaderHeight;   // will return the default value if unset
@property (nonatomic, strong) UIView *stackHeaderView;

- (id)dequeReusableViewWithIndex:(NSInteger)index;

- (NSInteger)numberOfRows;
- (NSInteger)indexForFocusedRow;
- (NSInteger)indexForSelectedRow;

- (void)reloadData;
- (void)reloadRowAtIndex:(NSInteger)index;
- (void)focusRowAtIndex:(NSInteger)index;
- (void)restoreAll;

@end


@protocol VSJStackViewDataSource <NSObject>

@required

- (NSInteger)numberOfRowsInStackView:(VSJStackView *)stackView;
- (VSJStackViewItem *)stackView:(VSJStackView *)stackView viewForRowAtIndex:(NSInteger)index;

@optional

@end