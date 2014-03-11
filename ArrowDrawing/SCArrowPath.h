//
//  SCArrowPath.h
//  ArrowDrawing
//
//  Created by Sam Davies on 10/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SC2DVector.h"

@interface SCArrowPath : NSObject

@property (nonatomic, assign) CGFloat bendiness;
@property (nonatomic, assign, readonly) CGPoint start;
@property (nonatomic, assign, readonly) CGPoint end;
@property (nonatomic, readonly) SC2DVector *arrowVect;

- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end;

- (CGPathRef)arrowPath CF_RETURNS_RETAINED;
- (SC2DVector *)directionAtEnd;

@end
