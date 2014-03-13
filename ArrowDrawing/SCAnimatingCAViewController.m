//
//  SCAnimatingCAViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 12/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCAnimatingCAViewController.h"
#import "SCCoreAnimationArrowView.h"
#import "SCArrowRandomiser.h"

@interface SCAnimatingCAViewController ()

@property (nonatomic, strong) SCCoreAnimationArrowView *arrow;
@property (nonatomic, strong) SCArrowRandomiser *arrowRandomiser;

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


- (IBAction)startRandomArrowCreation:(id)sender {
    // Empty all the arrows currently in the container
    // Have to make a copy as the the method mutates the actual subviews array
    NSArray *subviews = [self.arrowContainer.subviews copy];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Create a randomiser
    if(!self.arrowRandomiser) {
        self.arrowRandomiser = [[SCArrowRandomiser alloc] initWithParentView:self.arrowContainer
                                                                arrowCreator:^UIView<SCArrowView> *(CGRect frame, CGPoint from, CGPoint to) {
            SCCoreAnimationArrowView *arrow = [[SCCoreAnimationArrowView alloc] initWithFrame:frame from:from to:to];
            arrow.shouldAnimate = YES;
            return arrow;
        }];
    }
    // Kick it off
    [self.arrowRandomiser createArrowsForPeriod:10 withLambda:(1/0.2)];
}
@end
