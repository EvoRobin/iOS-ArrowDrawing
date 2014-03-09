//
//  SCVectorUtils.h
//  ArrowDrawing
//
//  Created by Sam Davies on 09/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVectorUtils : NSObject

// Bezier curve operations
+ (CGPoint)determinePointOnQuadBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                       endPoint:(CGPoint)end controlPoint:(CGPoint)control;

+ (CGPoint)determinePointOnCubicBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                        endPoint:(CGPoint)end control1:(CGPoint)c1
                                        control2:(CGPoint)c2;

// Simple vector operations
+ (CGPoint)perpendicularToVector:(CGPoint)vector length:(CGFloat)length;
+ (CGPoint)resizeVector:(CGPoint)vector length:(CGFloat)length;
+ (CGFloat)vectorLength:(CGPoint)vector;
+ (CGPoint)addVector:(CGPoint)v1 toVector:(CGPoint)v2;
+ (CGPoint)multiplyVector:(CGPoint)vector byScalar:(CGFloat)scalar;


@end
