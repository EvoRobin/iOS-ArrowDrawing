//
//  SCBaseArrowViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 25/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCBaseArrowViewController.h"

@interface SCBaseArrowViewController ()

@property (nonatomic, strong) NSMutableArray *arrows;

@end

@implementation SCBaseArrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrows = [NSMutableArray array];
    for(int i=0; i<10; i++) {
        id arrow = [self createArrowViewFrom:CGPointMake(10, (i+1)*40)
                                          to:CGPointMake(CGRectGetWidth(self.view.bounds)-10, (i+1)*45)];
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

- (UIView<SCArrowView> *)createArrowViewFrom:(CGPoint)from to:(CGPoint)to
{
    NSException *exception = [NSException exceptionWithName:@"SubclassAndOverride" reason:@"This method should be overridden in a subclass" userInfo:nil];
    @throw exception;
}


@end
