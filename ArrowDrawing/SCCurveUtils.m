/*
 Copyright 2014 Scott Logic Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

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
