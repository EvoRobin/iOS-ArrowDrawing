//
//  SCArrowHead.m
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCArrowHead.h"

@implementation SCArrowHead

- (instancetype)initWithDirection:(SC2DVector *)direction tip:(CGPoint)tip size:(CGFloat)size
{
    self = [super init];
    if(self) {
        self.direction = direction;
        self.tip = tip;
        self.size = size;
    }
    return self;
}

- (UIBezierPath *)arrowHeadBezierPath
{
    // Out at right angles
    SC2DVector *perpVector = [self.direction perpendicularVectorOfLength:self.size * 0.4];
    
    // Back from tip
    SC2DVector *footOfArrow = [[SC2DVector vectorWithPoint:self.tip] addVector:[self.direction normalisedToLength:-self.size]];
    SC2DVector *arrowSide1 = [footOfArrow addVector:perpVector];
    SC2DVector *arrowSide2 = [footOfArrow addVector:[perpVector multiplyByScalar:-1]];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // Draw line to point
    [path moveToPoint:arrowSide1.point];
    [path addLineToPoint:self.tip];
    
    // Then to other out
    [path addLineToPoint:arrowSide2.point];
    
    return path;
}

- (CGPathRef)arrowHeadPath
{
    return CGPathCreateCopy([self arrowHeadBezierPath].CGPath);
}

@end
