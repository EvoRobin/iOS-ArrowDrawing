//
//  SCFirstViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 05/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreGraphicsArrowViewController.h"
#import "SCCoreGraphicsArrowView.h"

@interface SCCoreGraphicsArrowViewController ()

@property (nonatomic, strong) UIView<SCArrowView> *arrowView;

@end

@implementation SCCoreGraphicsArrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.arrowView = [[SCCoreGraphicsArrowView alloc] initWithFrame:self.view.bounds
                                                               from:CGPointMake(0.2, 0.2)
                                                                 to:CGPointMake(0.8, 0.8)];
    [self.view addSubview:self.arrowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
