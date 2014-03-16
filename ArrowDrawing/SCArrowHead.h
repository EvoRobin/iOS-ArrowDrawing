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

@interface SCArrowHead : NSObject

@property (nonatomic, strong) SC2DVector *direction;
@property (nonatomic, assign) CGPoint tip;
@property (nonatomic, assign) CGFloat size;

- (instancetype)initWithDirection:(SC2DVector *)direction tip:(CGPoint)tip size:(CGFloat)size;

- (CGPathRef)arrowHeadPath CF_RETURNS_RETAINED;
- (UIBezierPath *)arrowHeadBezierPath;

@end
