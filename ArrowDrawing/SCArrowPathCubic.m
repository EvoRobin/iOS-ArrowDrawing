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
