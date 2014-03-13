//
//  SCArrowRandomiser.h
//  ArrowDrawing
//
//  Created by Sam Davies on 13/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCArrowView.h"

typedef UIView<SCArrowView>* (^SCArrowViewCreation)(CGRect frame, CGPoint from, CGPoint to);

@interface SCArrowRandomiser : NSObject

- (instancetype)initWithParentView:(UIView *)parent arrowCreator:(SCArrowViewCreation)arrowCreator;

- (void)startCreatingArrowsWithLambda:(CGFloat)lambda;
- (void)stopArrowCreation;
- (void)createArrowsForPeriod:(NSTimeInterval)period withLambda:(CGFloat)lambda;

@end
