//
//  SCAnimatingCGViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCAnimatingCGViewController.h"
#import "SCAnimatingCGArrowView.h"

@interface SCAnimatingCGViewController ()

@property (nonatomic, strong) SCAnimatingCGArrowView *arrow;

@end

@implementation SCAnimatingCGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrow = [[SCAnimatingCGArrowView alloc] initWithFrame:self.view.bounds
                                                                             from:CGPointMake(10, 30)
                                                                               to:CGPointMake(CGRectGetWidth(self.view.bounds)-10, 30)];
    self.arrow.bendiness = 0;
    [self.view addSubview:self.arrow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.arrow setNeedsDisplay];
}



@end
