//
//  SCUIImageViewArrow.m
//  ArrowDrawing
//
//  Created by Sam Davies on 23/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCUIImageViewArrow.h"

#define GENERATE_SETTER_WITH_NOOP_ERROR_LOG(PROPERTY, TYPE, SETTER) \
@synthesize PROPERTY = _##PROPERTY; \
\
- (void)SETTER:(TYPE)PROPERTY { \
_##PROPERTY = PROPERTY; \
NSLog(@"WARNING: This setter has no effect for UIImage-based arrows"); \
}

#define GENERATE_SETTER_WITH_UPDATE(PROPERTY, TYPE, SETTER, UPDATE_METHOD) \
@synthesize PROPERTY = _##PROPERTY; \
\
- (void)SETTER:(TYPE)PROPERTY { \
_##PROPERTY = PROPERTY; \
[self UPDATE_METHOD]; \
}

@interface SCUIImageViewArrow ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SCUIImageViewArrow

// Most properties are unsupported with this arrow type
GENERATE_SETTER_WITH_NOOP_ERROR_LOG(lineThickness, CGFloat, setLineThickness)
GENERATE_SETTER_WITH_NOOP_ERROR_LOG(bendiness, CGFloat, setBendiness)
GENERATE_SETTER_WITH_NOOP_ERROR_LOG(curveType, SCArrowViewCurveType, setCurveType)
GENERATE_SETTER_WITH_NOOP_ERROR_LOG(headSize, CGFloat, setHeadSize)
GENERATE_SETTER_WITH_NOOP_ERROR_LOG(headType, SCArrowViewHeadType, setHeadType)

// But these will work, and will need to update the arrow
GENERATE_SETTER_WITH_UPDATE(from, CGPoint, setFrom, redrawArrow)
GENERATE_SETTER_WITH_UPDATE(to, CGPoint, setTo, redrawArrow)
GENERATE_SETTER_WITH_UPDATE(color, UIColor *, setColor, redrawArrow)

- (id)initWithFrame:(CGRect)frame from:(CGPoint)from to:(CGPoint)to
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.from = from;
        self.to   = to;
        
        // Set defaults
        self.color = [UIColor blackColor];
        
        // Import the arrow image
        self.image = [self preColoredArrowImage];
        
        // Redraw the arrow correctly
        [self redrawArrow];
    }
    return self;
}

- (void)redrawArrow
{
    if(!self.arrowImageView && self.image) {
        self.arrowImageView = [[UIImageView alloc] initWithImage:self.image];
        [self addSubview:self.arrowImageView];
    }
    
    // Work out the centre of the arrow image
    CGPoint ivCentre = CGPointZero;
    ivCentre.x = (self.from.x + self.to.x) / 2.0;
    ivCentre.y = (self.from.y + self.to.y) / 2.0;
    self.arrowImageView.center = ivCentre;
    
    // Work out the 'width' of the arrow
    CGFloat arrowLength = sqrt(pow((self.to.y - self.from.y),2) +
                               pow((self.to.x - self.from.x),2)   );
    CGRect arrowBounds = self.arrowImageView.bounds;
    arrowBounds.size.width = arrowLength;
    self.arrowImageView.bounds = arrowBounds;
    
    // Need to rotate the arrow
    CGFloat arrowAngle = atan2((self.to.y - self.from.y),
                               (self.to.x - self.from.x));
    self.arrowImageView.transform = CGAffineTransformMakeRotation(arrowAngle);
    
    // Can recolour the arrow as well
    UIImage *preColoredArrow = [self preColoredArrowImage];
    // Prep the tint colour
    self.tintColor = self.color;
    // Set the rendering mode to respect tint color
    self.image = [preColoredArrow imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // And set to the image view
    self.arrowImageView.image = self.image;
    
}

- (UIImage *)preColoredArrowImage
{
    return [UIImage imageNamed:@"arrow_image"];
}

@end
