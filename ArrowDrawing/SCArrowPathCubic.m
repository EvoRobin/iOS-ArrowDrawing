//
//  SCArrowPathCubic.m
//  ArrowDrawing
//
//  Created by Sam Davies on 10/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCArrowPathCubic.h"
#import "SCCurveUtils.h"
#import "SC2DVector.h"

@implementation SCArrowPathCubic

- (UIBezierPath *)arrowBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.start];
    NSArray *controlPoints = [self controlPoints];
    [path addCurveToPoint:self.end controlPoint1:[controlPoints[0] point] controlPoint2:[controlPoints[1] point]];
    return path;
}

- (SC2DVector *)directionAtEnd
{
    NSArray *controlPoints = [self controlPoints];
    CGPoint nearEnd = [SCCurveUtils determinePointOnCubicBezierAtPosition:0.95
                                                               startPoint:self.start
                                                                 endPoint:self.end
                                                                 control1:[controlPoints[0] point]
                                                                 control2:[controlPoints[1] point]];
    
    // find the vector
    return [[SC2DVector vectorWithPoint:self.end] addVector:[[SC2DVector vectorWithPoint:nearEnd] multiplyByScalar:-1]];
}


#pragma mark - Utility methods
- (NSArray *)controlPoints
{
    SC2DVector *vStart = [SC2DVector vectorWithPoint:self.start];
    SC2DVector *vEnd   = [SC2DVector vectorWithPoint:self.end];
    
    // Calculate arrow vector
    SC2DVector *arrowVect = [vEnd addVector:[vStart multiplyByScalar:-1]];
    // How bendy?
    CGFloat perpLength = self.bendiness * [arrowVect length];
    // Calculate perpendicular
    SC2DVector *arrowPerp = [arrowVect perpendicularVectorOfLength:perpLength];
    
    SC2DVector *c1 = [[vStart addVector:[arrowVect multiplyByScalar:1/3.0]] addVector:arrowPerp];
    SC2DVector *c2 = [[vStart addVector:[arrowVect multiplyByScalar:2/3.0]] addVector:[arrowPerp multiplyByScalar:-1]];
    
    return @[c1, c2];
}

@end
