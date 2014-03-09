//
//  SCVector.h
//  ArrowDrawing
//
//  Created by Sam Davies on 09/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SC2DVector : NSObject<NSCopying>

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign, readonly) CGPoint point;

+ (instancetype)vectorWithPoint:(CGPoint)point;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y;
- (instancetype)initWithCGPoint:(CGPoint)point;

- (SC2DVector *)addVector:(SC2DVector *)vector;
- (SC2DVector *)multiplyByScalar:(CGFloat)scalar;

- (CGFloat)dotProductWithVector:(SC2DVector *)vector;

- (CGFloat)length;
- (SC2DVector *)normalisedToLength:(CGFloat)length;

- (SC2DVector *)perpendicularVector;
- (SC2DVector *)perpendicularVectorOfLength:(CGFloat)length;


@end
