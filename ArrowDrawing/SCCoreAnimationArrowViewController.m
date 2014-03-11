//
//  SCSecondViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 05/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreAnimationArrowViewController.h"
#import "SCCoreAnimationArrowView.h"

@interface SCCoreAnimationArrowViewController ()

@end

@implementation SCCoreAnimationArrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arrows = [NSMutableArray array];
    for(int i=0; i<10; i++) {
        id arrow = [[SCCoreAnimationArrowView alloc] initWithFrame:self.view.bounds
                                                             from:CGPointMake(0, (i+1)*40)
                                                               to:CGPointMake(CGRectGetWidth(self.view.bounds), (i+1)*40)];
        [self.view addSubview:arrow];
        [arrows addObject:arrow];
    }
    
    [arrows[1] setBendiness:0.4];
    [arrows[2] setCurveType:SCArrowViewCurveTypeRight];
    [arrows[3] setHeadType:SCArrowViewHeadTypeFilled];
    [arrows[4] setHeadType:SCArrowViewHeadTypeTriangle];
    [arrows[5] setColor:[UIColor blueColor]];
    [arrows[6] setCurveType:SCArrowViewCurveTypeBoth];
    [arrows[7] setCurveType:SCArrowViewCurveTypeBoth];
    [arrows[7] setBendiness:0.4];
    [arrows[8] setLineThickness:5];
    [arrows[9] setHeadSize:50];
}

@end
