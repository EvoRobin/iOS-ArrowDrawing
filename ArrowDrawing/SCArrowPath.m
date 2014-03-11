//
//  SCArrowPath.m
//  ArrowDrawing
//
//  Created by Sam Davies on 10/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCArrowPath.h"

@interface SCArrowPath ()

@property (nonatomic, assign, readwrite) CGPoint start;
@property (nonatomic, assign, readwrite) CGPoint end;

@end


@implementation SCArrowPath

- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end
{
    self = [super init];
    if(self) {
        self.start = start;
        self.end = end;
    }
    return self;
}

- (UIBezierPath *)arrowBezierPath
{
    // Just a straight line in the base implementation
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:self.start];
    [path addLineToPoint:self.end];
    return path;
}

- (CGPathRef)arrowPath
{
    return CGPathCreateCopy([self arrowBezierPath].CGPath);
}

- (SC2DVector *)directionAtEnd
{
    return [self arrowVect];
}

#pragma mark - Override some property getters
- (SC2DVector *)arrowVect
{
    SC2DVector *vStart = [SC2DVector vectorWithPoint:self.start];
    SC2DVector *vEnd   = [SC2DVector vectorWithPoint:self.end];
    
    // Calculate arrow vector
    return [vEnd addVector:[vStart multiplyByScalar:-1]];
}

@end
