//
//  SCAnimatingCAViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 12/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCAnimatingCAViewController.h"
#import "SCCoreAnimationArrowView.h"

@interface SCAnimatingCAViewController ()

@property (nonatomic, strong) SCCoreAnimationArrowView *arrow;

@end

@implementation SCAnimatingCAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrow = [[SCCoreAnimationArrowView alloc] initWithFrame:self.view.bounds from:CGPointMake(10, 30) to:CGPointMake(CGRectGetWidth(self.view.bounds) - 10, 30)];
    self.arrow.shouldAnimate = YES;
    [self.view addSubview:self.arrow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.arrow redrawArrow];
}


@end
