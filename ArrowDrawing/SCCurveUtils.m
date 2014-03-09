//
//  SCVectorUtils.m
//  ArrowDrawing
//
//  Created by Sam Davies on 09/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCurveUtils.h"
#import "SC2DVector.h"

@implementation SCCurveUtils

+ (CGPoint)determinePointOnQuadBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                       endPoint:(CGPoint)end controlPoint:(CGPoint)control
{
    CGFloat x = (1-t) * ((1-t) * start.x + t * control.x) + t * ((1-t) * control.x + t * end.x);
    CGFloat y = (1-t) * ((1-t) * start.y + t * control.y) + t * ((1-t) * control.y + t * end.y);
    return CGPointMake(x, y);
}

+ (CGPoint)determinePointOnCubicBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                        endPoint:(CGPoint)end control1:(CGPoint)c1
                                        control2:(CGPoint)c2
{
    CGPoint part1 = [self determinePointOnQuadBezierAtPosition:t startPoint:start
                                                      endPoint:c2 controlPoint:c1];
    CGPoint part2 = [self determinePointOnQuadBezierAtPosition:t startPoint:c1
                                                      endPoint:end controlPoint:c2];
    
    SC2DVector *v1 = [SC2DVector vectorWithPoint:part1];
    SC2DVector *v2 = [SC2DVector vectorWithPoint:part2];
    
    return [[[v1 multiplyByScalar:(1-t)] addVector:[v2 multiplyByScalar:t]] point];
}

@end
