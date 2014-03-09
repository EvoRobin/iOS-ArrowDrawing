//
//  SCVectorUtils.m
//  ArrowDrawing
//
//  Created by Sam Davies on 09/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCVectorUtils.h"

@implementation SCVectorUtils

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
    
    return [self addVector:[self multiplyVector:part1 byScalar:(1-t)]
                  toVector:[self multiplyVector:part2 byScalar:t]];
}

+ (CGPoint)perpendicularToVector:(CGPoint)vector length:(CGFloat)length
{
    CGPoint perpVector;
    perpVector.x =   vector.y;
    perpVector.y = - vector.x;
    return [self resizeVector:perpVector length:length];
}

+ (CGPoint)resizeVector:(CGPoint)vector length:(CGFloat)length
{
    CGFloat currentLength = [self vectorLength:vector];
    return [self multiplyVector:vector byScalar:(length / currentLength)];
}

+ (CGFloat)vectorLength:(CGPoint)vector
{
    return sqrt(vector.x * vector.x + vector.y * vector.y);
}

+ (CGPoint)addVector:(CGPoint)v1 toVector:(CGPoint)v2
{
    CGPoint sum;
    sum.x = v1.x + v2.x;
    sum.y = v1.y + v2.y;
    return sum;
}

+ (CGPoint)multiplyVector:(CGPoint)vector byScalar:(CGFloat)scalar
{
    return CGPointMake(vector.x * scalar, vector.y * scalar);
}

@end
