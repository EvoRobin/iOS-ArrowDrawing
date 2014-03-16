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

#import "SCArrowRandomiser.h"

@interface SCArrowRandomiser ()

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) CGFloat lambda;
@property (nonatomic, copy) SCArrowViewCreation arrowCreator;
@property (nonatomic, strong) NSTimer *poissonTimer;
@property (nonatomic, strong) NSTimer *periodTimer;

@end

@implementation SCArrowRandomiser

- (instancetype)initWithParentView:(UIView *)parent arrowCreator:(SCArrowViewCreation)arrowCreator
{
    self = [super init];
    if(self) {
        self.parentView = parent;
        self.arrowCreator = arrowCreator;
        // Seed the random number generator
        srand48(time(0));
    }
    return self;
}

- (void)startCreatingArrowsWithLambda:(CGFloat)lambda
{
    self.lambda = lambda;
    self.poissonTimer = [[NSTimer alloc] initWithFireDate:[self nextFireTime] interval:5 target:self selector:@selector(createNewArrow:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.poissonTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopArrowCreation
{
    // Cancel the poisson timer
    [self.poissonTimer invalidate];
    self.poissonTimer = nil;
    
    // If we have a periodTimer
    [self.periodTimer invalidate];
    self.periodTimer = nil;
}

- (void)createArrowsForPeriod:(NSTimeInterval)period withLambda:(CGFloat)lambda
{
    self.periodTimer = [NSTimer scheduledTimerWithTimeInterval:period target:self selector:@selector(stopArrowCreation) userInfo:nil repeats:NO];
    [self startCreatingArrowsWithLambda:lambda];
}


#pragma mark - Timer callbacks
- (void)createNewArrow:(NSTimer *)timer
{
    UIView<SCArrowView> *arrow = self.arrowCreator(self.parentView.bounds,
                                                   [self randomCGPointWithinParentView],
                                                   [self randomCGPointWithinParentView]);
    [self.parentView addSubview:arrow];
    // Reset the timer
    [self.poissonTimer setFireDate:[self nextFireTime]];
}


#pragma mark - Utility methods
- (NSDate *)nextFireTime
{
    double uniform_rand = drand48();
    // Need this to be exponential for poisson process
    double exponential_rand = - log(1.0 - uniform_rand);
    // And now rescale this according to the rate parameter
    double time_increment = exponential_rand / self.lambda;
    // Make this into a date
    return [NSDate dateWithTimeIntervalSinceNow:time_increment];
}

- (CGPoint)randomCGPointWithinParentView
{
    double x = drand48();
    double y = drand48();
    return CGPointMake(round(x * CGRectGetWidth(self.parentView.bounds)),
                       round(y * CGRectGetHeight(self.parentView.bounds)));
}

@end
