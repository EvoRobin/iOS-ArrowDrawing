//
//  SCVectorUtils.h
//  ArrowDrawing
//
//  Created by Sam Davies on 09/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCurveUtils : NSObject

// Bezier curve operations
+ (CGPoint)determinePointOnQuadBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                       endPoint:(CGPoint)end controlPoint:(CGPoint)control;

+ (CGPoint)determinePointOnCubicBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                        endPoint:(CGPoint)end control1:(CGPoint)c1
                                        control2:(CGPoint)c2;



@end
