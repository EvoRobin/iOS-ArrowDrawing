//
//  SCAnimatingCGViewController.h
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAnimatingCGViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *arrowContainer;
- (IBAction)handleCreateArrowsButtonPressed:(id)sender;

@end
