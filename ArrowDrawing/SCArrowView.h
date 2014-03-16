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

@import Foundation;
@import QuartzCore;

typedef NS_ENUM(NSInteger, SCArrowViewCurveType) {
    SCArrowViewCurveTypeLeft,
    SCArrowViewCurveTypeRight,
    SCArrowViewCurveTypeBoth
};

typedef NS_ENUM(NSInteger, SCArrowViewHeadType) {
    SCArrowViewHeadTypeFilled,
    SCArrowViewHeadTypeEdges,
    SCArrowViewHeadTypeTriangle
};


@protocol SCArrowView <NSObject>

- (instancetype)initWithFrame:(CGRect)frame from:(CGPoint)from to:(CGPoint)to;

@property (nonatomic, assign) CGPoint from;
@property (nonatomic, assign) CGPoint to;
@property (nonatomic, assign) CGFloat headSize;
@property (nonatomic, assign) CGFloat lineThickness;
@property (nonatomic, assign) CGFloat bendiness;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) SCArrowViewCurveType curveType;
@property (nonatomic, assign) SCArrowViewHeadType headType;

// For demonstration purposes
- (void)redrawArrow;

@end
