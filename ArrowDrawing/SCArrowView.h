//
//  SCArrowView.h
//  ArrowDrawing
//
//  Created by Sam Davies on 06/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

@import Foundation;
@import QuartzCore;

typedef NS_ENUM(NSInteger, SCArrowViewCurveType) {
    SCArrowViewCurveTypeLeft,
    SCArrowViewCurveTypeRight,
    SCArrowViewCurveTypeBoth
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

@end
