//
//  SCArrrowPathQuad.m
//  ArrowDrawing
//
//  Created by Sam Davies on 10/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

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
