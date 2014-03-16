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

#import "SCAnimatingCGViewController.h"
#import "SCAnimatingCGArrowView.h"
#import "SCArrowRandomiser.h"

@interface SCAnimatingCGViewController ()

@property (nonatomic, strong) SCAnimatingCGArrowView *arrow;
@property (nonatomic, strong) SCArrowRandomiser *arrowRandomiser;

@end

@implementation SCAnimatingCGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrow = [[SCAnimatingCGArrowView alloc] initWithFrame:self.view.bounds
                                                                             from:CGPointMake(10, 30)
                                                                               to:CGPointMake(CGRectGetWidth(self.view.bounds)-10, 30)];
    self.arrow.bendiness = 0;
    [self.view addSubview:self.arrow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.arrow redrawArrow];
}


- (IBAction)handleCreateArrowsButtonPressed:(id)sender {
    // Empty the container
    NSArray *subviews = [self.arrowContainer.subviews copy];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Create the randomiser
    if(!self.arrowRandomiser) {
        self.arrowRandomiser = [[SCArrowRandomiser alloc] initWithParentView:self.arrowContainer arrowCreator:^UIView<SCArrowView> *(CGRect frame, CGPoint from, CGPoint to) {
            return [[SCAnimatingCGArrowView alloc] initWithFrame:frame from:from to:to];
        }];
    }
    
    // Kick it off
    [self.arrowRandomiser createArrowsForPeriod:10 withLambda:(1/0.2)];
}
@end
