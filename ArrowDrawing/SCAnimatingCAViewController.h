//
//  SCAnimatingCAViewController.h
//  ArrowDrawing
//
//  Created by Sam Davies on 12/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAnimatingCAViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *createRandomArrows;
@property (weak, nonatomic) IBOutlet UIView *arrowContainer;

- (IBAction)startRandomArrowCreation:(id)sender;


@end
