//
//  SCImageArrowViewController.m
//  ArrowDrawing
//
//  Created by Sam Davies on 23/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCImageArrowViewController.h"
#import "SCUIImageViewArrow.h"

@implementation SCImageArrowViewController

- (UIView<SCArrowView> *)createArrowViewFrom:(CGPoint)from to:(CGPoint)to
{
    return [[SCUIImageViewArrow alloc] initWithFrame:self.view.bounds from:from to:to];
}

@end
