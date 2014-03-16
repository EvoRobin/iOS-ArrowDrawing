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

#import "SCArrowPathQuad.h"
#import "SCCurveUtils.h"

@implementation SCArrowPathQuad

- (UIBezierPath *)arrowBezierPath
{
    // Create the path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.start];
    [path addQuadCurveToPoint:self.end controlPoint:[self controlPoint].point];
    
    return path;
}

- (SC2DVector *)directionAtEnd
{
    CGPoint nearEnd = [SCCurveUtils determinePointOnQuadBezierAtPosition:0.95
                                                      startPoint:self.start
                                                        endPoint:self.end
                                                    controlPoint:[self controlPoint].point];
    
    // find the vector
    return [[SC2DVector vectorWithPoint:self.end] addVector:[[SC2DVector vectorWithPoint:nearEnd] multiplyByScalar:-1]];
}

#pragma mark - Util methods
- (SC2DVector *)controlPoint
{
    SC2DVector *vStart = [SC2DVector vectorWithPoint:self.start];
    // How bendy?
    CGFloat perpLength = self.bendiness * [self.arrowVect length];
    // Calculate perpendicular
    SC2DVector *arrowPerp = [self.arrowVect perpendicularVectorOfLength:perpLength];
    
    // If we're going left-handed
    if(self.leftHandedCurve) {
        arrowPerp = [arrowPerp multiplyByScalar:-1];
    }
    
    // Calculate the control point
    return [[vStart addVector:[self.arrowVect multiplyByScalar:0.5]] addVector:arrowPerp];
}

@end
