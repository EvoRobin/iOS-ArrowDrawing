//
//  SCArrowHead.h
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SC2DVector.h"

@interface SCArrowHead : NSObject

@property (nonatomic, strong) SC2DVector *direction;
@property (nonatomic, assign) CGPoint tip;
@property (nonatomic, assign) CGFloat size;

- (instancetype)initWithDirection:(SC2DVector *)direction tip:(CGPoint)tip size:(CGFloat)size;

- (CGPathRef)arrowHeadPath CF_RETURNS_RETAINED;

@end
