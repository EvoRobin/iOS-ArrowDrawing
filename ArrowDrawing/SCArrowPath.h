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
#import "SC2DVector.h"

@interface SCArrowPath : NSObject

@property (nonatomic, assign) CGFloat bendiness;
@property (nonatomic, assign, readonly) CGPoint start;
@property (nonatomic, assign, readonly) CGPoint end;
@property (nonatomic, readonly) SC2DVector *arrowVect;

- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end;

- (CGPathRef)arrowPath CF_RETURNS_RETAINED;
- (UIBezierPath *)arrowBezierPath;
- (SC2DVector *)directionAtEnd;

@end
