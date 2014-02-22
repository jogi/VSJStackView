//
//  VSJViewController.m
//  VSJStackView
//
//  Created by Vashishtha Jogi on 2/21/14.
//  Copyright (c) 2014 Vashishtha Jogi. All rights reserved.
//

#import "VSJViewController.h"
#import "VSJStackView.h"

static const CGFloat numberOfItems = 5.0;

@interface VSJViewController () <VSJStackViewDataSource, VSJStackViewDelegate>

@property (nonatomic, strong) VSJStackView *stackView;

@end

@implementation VSJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.stackView = [[VSJStackView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.stackView.stackViewDelegate = self;
    self.stackView.stackViewDataSource = self;
    self.stackView.bounces = NO;
    
    [self.view addSubview:self.stackView];
}


#pragma mark - VJUICardViewDataSource

- (NSInteger)numberOfRowsInStackView:(VSJStackView *)stackView {
    return numberOfItems;
}

- (VSJStackViewItem *)stackView:(VSJStackView *)stackView viewForRowAtIndex:(NSInteger)index {
    VSJStackViewItem *anItem = [[VSJStackViewItem alloc] initWithFrame:CGRectZero];
    anItem.backgroundColor = [UIColor colorWithHue:(index/numberOfItems) saturation:1.0 brightness:1.0 alpha:1.0];
    
    return anItem;
}

#pragma mark - VJUICardViewDelagete

- (CGSize)stackView:(VSJStackView *)stackView sizeForRowAtIndex:(NSInteger)index {
    return CGSizeMake(self.stackView.frame.size.width, 380.0);
}

- (void)stackView:(VSJStackView *)stackView willFocusRowAtIndex:(NSInteger)index {
    NSLog(@"%@ - %ld", NSStringFromSelector(_cmd), (long)index);
}

- (void)stackView:(VSJStackView *)stackView willDefocusRowAtIndex:(NSInteger)index {
    NSLog(@"%@ - %ld", NSStringFromSelector(_cmd), (long)index);
}

- (void)stackView:(VSJStackView *)stackView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"%@ - %ld", NSStringFromSelector(_cmd), (long)index);
}

@end
