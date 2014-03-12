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

@property (nonatomic, strong) NSMutableArray *arrows;

@end

@implementation SCCoreAnimationArrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.arrows = [NSMutableArray array];
    for(int i=0; i<10; i++) {
        id arrow = [[SCCoreAnimationArrowView alloc] initWithFrame:self.view.bounds
                                                             from:CGPointMake(10, (i+1)*40)
                                                               to:CGPointMake(CGRectGetWidth(self.view.bounds)-10, (i+1)*40)];
        [self.view addSubview:arrow];
        [self.arrows addObject:arrow];
    }
    
    [self.arrows[1] setBendiness:0.4];
    [self.arrows[2] setCurveType:SCArrowViewCurveTypeRight];
    [self.arrows[3] setHeadType:SCArrowViewHeadTypeFilled];
    [self.arrows[4] setHeadType:SCArrowViewHeadTypeTriangle];
    [self.arrows[5] setColor:[UIColor blueColor]];
    [self.arrows[6] setCurveType:SCArrowViewCurveTypeBoth];
    [self.arrows[7] setCurveType:SCArrowViewCurveTypeBoth];
    [self.arrows[7] setBendiness:0.4];
    [self.arrows[8] setLineThickness:5];
    [self.arrows[9] setHeadSize:50];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (id<SCArrowView> arrow in self.arrows) {
        [arrow redrawArrow];
    }
}
@end
