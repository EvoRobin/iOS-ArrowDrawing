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

#import "SCArrowHead.h"

@implementation SCArrowHead

- (instancetype)initWithDirection:(SC2DVector *)direction tip:(CGPoint)tip size:(CGFloat)size
{
    self = [super init];
    if(self) {
        self.direction = direction;
        self.tip = tip;
        self.size = size;
    }
    return self;
}

- (UIBezierPath *)arrowHeadBezierPath
{
    // Out at right angles
    SC2DVector *perpVector = [self.direction perpendicularVectorOfLength:self.size * 0.4];
    
    // Back from tip
    SC2DVector *footOfArrow = [[SC2DVector vectorWithPoint:self.tip] addVector:[self.direction normalisedToLength:-self.size]];
    SC2DVector *arrowSide1 = [footOfArrow addVector:perpVector];
    SC2DVector *arrowSide2 = [footOfArrow addVector:[perpVector multiplyByScalar:-1]];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // Draw line to point
    [path moveToPoint:arrowSide1.point];
    [path addLineToPoint:self.tip];
    
    // Then to other out
    [path addLineToPoint:arrowSide2.point];
    
    return path;
}

- (CGPathRef)arrowHeadPath
{
    return CGPathCreateCopy([self arrowHeadBezierPath].CGPath);
}

@end
