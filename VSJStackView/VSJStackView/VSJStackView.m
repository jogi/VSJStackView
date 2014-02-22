//
//  VSJStackView.m
//  VSJStackView
//
//  Created by Vashishtha Jogi on 6/25/13.
//  Copyright (c) 2013 Vashishtha Jogi. All rights reserved.
//

#import "VSJStackView.h"
#import <QuartzCore/QuartzCore.h>

@interface VSJStackView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSNumber *focusedRow;
@property (nonatomic, assign) NSNumber *previouslyFocusedRow;
@property (nonatomic, assign) NSNumber *selectedRow;

- (CGFloat)headerHeight;
- (CGFloat)minimizedItemHeight;

- (void)initStackView;
- (void)setupItems;
- (void)stashAllExceptRowAtIndex:(NSInteger)index;
- (void)tappedRow:(UITapGestureRecognizer *)recognizer;

@end

@implementation VSJStackView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initStackView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self initStackView];
	}
	
	return self;
}

- (void)initStackView {
	self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
	self.layer.masksToBounds = NO;
	[self addObserver:self forKeyPath:@"stackViewDataSource" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
	[self addObserver:self forKeyPath:@"stackViewDelegate" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"stackViewDataSource"]) {
		if (self.stackViewDataSource) {
			[self removeObserver:self forKeyPath:@"stackViewDataSource" context:NULL];
			[self setupItems];
		}
	}
	
	if ([keyPath isEqualToString:@"stackViewDelegate"]) {
		if (self.stackViewDelegate) {
			[self removeObserver:self forKeyPath:@"stackViewDelegate" context:NULL];
			[self setupItems];
		}
	}
}

- (NSInteger)numberOfRows {
	if ([self.stackViewDataSource respondsToSelector:@selector(numberOfRowsInStackView:)]) {
		return [self.stackViewDataSource numberOfRowsInStackView:self];
	} else {
		return 0;
	}
}

- (NSInteger)indexForFocusedRow {
	return self.focusedRow ? self.focusedRow.integerValue : -1;
}

- (NSInteger)indexForSelectedRow {
	return self.selectedRow ? self.selectedRow.integerValue : -1;
}

- (CGFloat)headerHeight {
	CGFloat headerHeight = 0.0f;
	if ([self.stackViewDelegate respondsToSelector:@selector(stackViewHeightForHeader)]) {
		headerHeight = [self.stackViewDelegate stackViewHeightForHeader];
	}
	
	return headerHeight;
}

- (CGFloat)minimizedItemHeight {
	CGFloat height = (self.frame.size.height - [self headerHeight] - [self.stackViewDelegate stackView:self sizeForRowAtIndex:0].height - 10.0) / (self.numberOfRows - 1);
	
	return height;
}

- (void)setupItems {
	self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.numberOfRows = [self.stackViewDataSource numberOfRowsInStackView:self];
    self.items = [[NSMutableArray alloc] init];
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	CGFloat headerHeight = [self headerHeight];
	
	// add the header
	if ([self.stackViewDelegate respondsToSelector:@selector(stackViewForHeader)]) {
		UIView *headerView = [self.stackViewDelegate stackViewForHeader];
		// add it to the top
		headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
		[self addSubview:headerView];
	}
	
	for (int i = 0; i < self.numberOfRows; i++) {
		VSJStackViewItem *item;
		if ([self.stackViewDataSource respondsToSelector:@selector(stackView:viewForRowAtIndex:)]) {
			item = [self.stackViewDataSource stackView:self viewForRowAtIndex:i];
		} else {
			item = [[VSJStackViewItem alloc] initWithFrame:CGRectZero];
			item.backgroundColor = [UIColor whiteColor];
		}
		
		CGSize size = [self.stackViewDelegate stackView:self sizeForRowAtIndex:i];
		item.frame = CGRectMake(0, i * ((self.frame.size.height - headerHeight) / self.numberOfRows) + headerHeight, size.width, size.height);
		item.index = i;
		
		item.originalFrame = CGRectMake(0, i * ((self.frame.size.height - headerHeight) / self.numberOfRows) + headerHeight, size.width, size.height);
		
		item.focusY = headerHeight;
		
		[item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRow:)]];
		
		[self addSubview:item];
		[self.items addObject:item];
	}
}

- (id)dequeReusableViewWithIndex:(NSInteger)index {
	if (index < self.items.count) {
		return self.items[index];
	} else {
		return nil;
	}
}

- (void)reloadData {
	[self setupItems];
}

- (void)reloadRowAtIndex:(NSInteger)index {
	if (self.headerHeight > 0) {
		[[self subviews][index+1] removeFromSuperview];
	} else {
		[[self subviews][index] removeFromSuperview];
	}
	
	VSJStackViewItem *oldItem = self.items[index];
	
	VSJStackViewItem *item;
	if ([self.stackViewDataSource respondsToSelector:@selector(stackView:viewForRowAtIndex:)]) {
		item = [self.stackViewDataSource stackView:self viewForRowAtIndex:index];
	} else {
		item = [[VSJStackViewItem alloc] initWithFrame:CGRectZero];
		item.backgroundColor = [UIColor whiteColor];
	}

	item.frame = oldItem.frame;
	item.index = oldItem.index;
	item.originalFrame = oldItem.originalFrame;
	item.focusY = oldItem.focusY;
	item.state = oldItem.state;
	
	[item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRow:)]];

	if (self.headerHeight > 0) {
		[self insertSubview:item atIndex:index+1];
	} else {
		[self insertSubview:item atIndex:index];
	}
	
	self.items[index] = item;
}

- (void)stashAllExceptRowAtIndex:(NSInteger)index {
	NSArray *allItems = [self.items copy];
    NSMutableArray *notSelectedItems = [NSMutableArray arrayWithArray:allItems];
    [notSelectedItems removeObjectAtIndex:index];
	
	void (^aCompletionBlock)(void) = ^(void) {
        if ([self.stackViewDelegate respondsToSelector:@selector(stackView:didStashAllExceptRowAtIndex:)]) {
			[self.stackViewDelegate stackView:self didStashAllExceptRowAtIndex:index];
		}
    };
	
    __block NSUInteger counter = 0;
    
	[notSelectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		VSJStackViewItem *item = (VSJStackViewItem *)obj;
		item.stashY = [self.stackViewDelegate stackView:self sizeForRowAtIndex:idx].height + [self headerHeight] + (idx * [self minimizedItemHeight] + 10.0);
		[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
			item.frame = [item stashedFrame];
		} completion:^(BOOL finished) {
			item.state = VSJStackViewItemStateStashed;
			counter++;
            if (counter == self.items.count) {
                aCompletionBlock();
            }
		}];
	}];
}

- (void)focusRowAtIndex:(NSInteger)index {
	self.focusedRow = @(index);
	if ([self.stackViewDelegate respondsToSelector:@selector(stackView:willFocusRowAtIndex:)]) {
		[self.stackViewDelegate stackView:self willFocusRowAtIndex:index];
	}
	
	VSJStackViewItem *item = self.items[index];
	
	[self stashAllExceptRowAtIndex:index];
	
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        item.frame = [item focusedFrame];
    } completion:^(BOOL finished) {
        item.state = VSJStackViewItemStateFocused;
		if ([self.stackViewDelegate respondsToSelector:@selector(stackView:didFocusRowAtIndex:)]) {
			[self.stackViewDelegate stackView:self didFocusRowAtIndex:index];
		}
    }];
}

- (void)restoreAll {
    self.alwaysBounceVertical = YES;
	self.previouslyFocusedRow = self.focusedRow;
	self.focusedRow = nil;
	self.selectedRow = nil;
	
	void (^aCompletionBlock)(void) = ^(void) {
        if ([self.stackViewDelegate respondsToSelector:@selector(stackView:didRestoreAllRows:)]) {
			[self.stackViewDelegate stackView:self didRestoreAllRows:YES];
		}
		
		if ([self.stackViewDelegate respondsToSelector:@selector(stackView:didDefocusRowAtIndex:)]) {
			[self.stackViewDelegate stackView:self didDefocusRowAtIndex:self.previouslyFocusedRow.integerValue];
		}
    };
	
	if ([self.stackViewDelegate respondsToSelector:@selector(stackView:willDefocusRowAtIndex:)]) {
		[self.stackViewDelegate stackView:self willDefocusRowAtIndex:self.previouslyFocusedRow.integerValue];
	}
	
    __block NSUInteger counter = 0;
    
	NSArray *allItems = [self.items copy];

	[allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		VSJStackViewItem *item = (VSJStackViewItem *)obj;
		
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            item.frame = [item restoreFrame];
        } completion:^(BOOL finished) {
            item.state = VSJStackViewItemStateNormal;
            counter++;
            if (counter == self.items.count) {
                aCompletionBlock();
            }
        }];
	}];
}

- (void)tappedRow:(UITapGestureRecognizer *)recognizer {
	VSJStackViewItem *item = (VSJStackViewItem *)recognizer.view;
	switch (item.state) {
		case VSJStackViewItemStateNormal:
			[self focusRowAtIndex:item.index];
			break;
		case VSJStackViewItemStateFocused:
			// aha selected
			self.selectedRow = @(item.index);
			if ([self.stackViewDelegate respondsToSelector:@selector(stackView:didSelectRowAtIndex:)]) {
				[self.stackViewDelegate stackView:self didSelectRowAtIndex:item.index];
			}
			break;
		case VSJStackViewItemStateStashed:
			[self restoreAll];
			break;
		default:
			break;
	}
}

@end
