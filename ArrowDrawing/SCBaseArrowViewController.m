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


#import "SCBaseArrowViewController.h"

@interface SCBaseArrowViewController ()

@property (nonatomic, strong) NSMutableArray *arrows;

@end

@implementation SCBaseArrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrows = [NSMutableArray array];
    for(int i=0; i<10; i++) {
        id arrow = [self createArrowViewFrom:CGPointMake(10, (i+1)*40)
                                          to:CGPointMake(CGRectGetWidth(self.view.bounds)-10, (i+1)*45)];
        [self.view addSubview:arrow];
        [self.arrows addObject:arrow];
    }
    
    [self.arrows[1] setBendiness:0.4];
    [self.arrows[2] setCurveType:SCArrowViewCurveTypeRight];
    [self.arrows[3] setHeadType:SCArrowViewHeadTypeFilled];
    [self.arrows[4] setHeadType:SCArrowViewHeadTypeTriangle];
    [self.arrows[5] setColor:[UIColor blueColor]];
    [self.arrows[6] setCurveType:SCArrowViewCurveTypeBoth];
    [self.arrows[7] setCurveType:SCArrowViewCurveTypeBoth];
    [self.arrows[7] setBendiness:0.4];
    [self.arrows[8] setLineThickness:5];
    [self.arrows[9] setHeadSize:50];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (id<SCArrowView> arrow in self.arrows) {
        [arrow redrawArrow];
    }
}

- (UIView<SCArrowView> *)createArrowViewFrom:(CGPoint)from to:(CGPoint)to
{
    NSException *exception = [NSException exceptionWithName:@"SubclassAndOverride" reason:@"This method should be overridden in a subclass" userInfo:nil];
    @throw exception;
}


@end
