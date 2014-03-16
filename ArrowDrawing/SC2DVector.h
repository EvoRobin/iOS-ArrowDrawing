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
