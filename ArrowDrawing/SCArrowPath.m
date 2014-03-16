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
