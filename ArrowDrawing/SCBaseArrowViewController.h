//
//  SCBaseArrowViewController.h
//  ArrowDrawing
//
//  Created by Sam Davies on 25/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCArrowView.h"

@interface SCBaseArrowViewController : UIViewController

- (UIView<SCArrowView> *)createArrowViewFrom:(CGPoint)from to:(CGPoint)to;

@end
