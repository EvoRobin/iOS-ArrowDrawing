//
//  SCCoreAnimationArrowView.m
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreAnimationArrowView.h"
#import "SCArrowPathCubic.h"
#import "SCArrowPathQuad.h"
#import "SCArrowHead.h"

#define LAYER ((CAShapeLayer*)self.layer)
#define GENERATE_SETTER_WITH_LAYER_REDRAW(PROPERTY, TYPE, SETTER) \
@synthesize PROPERTY = _##PROPERTY; \
\
- (void)SETTER:(TYPE)PROPERTY { \
_##PROPERTY = PROPERTY; \
[self updateArrowLayer]; \
}


@implementation SCCoreAnimationArrowView

// Properties whose setters require a redraw of the layer
GENERATE_SETTER_WITH_LAYER_REDRAW(bendiness, CGFloat, setBendiness)
GENERATE_SETTER_WITH_LAYER_REDRAW(curveType, SCArrowViewCurveType, setCurveType)
GENERATE_SETTER_WITH_LAYER_REDRAW(from, CGPoint, setFrom)
GENERATE_SETTER_WITH_LAYER_REDRAW(to, CGPoint, setTo)
GENERATE_SETTER_WITH_LAYER_REDRAW(headSize, CGFloat, setHeadSize)
GENERATE_SETTER_WITH_LAYER_REDRAW(headType, SCArrowViewHeadType, setHeadType)

// Other properties
@synthesize lineThickness = _lineThickness;
@synthesize color = _color;

- (void)setColor:(UIColor *)color
{
    _color = color;
    LAYER.strokeColor = color.CGColor;
}

- (void)setLineThickness:(CGFloat)lineThickness
{
    _lineThickness = lineThickness;
    LAYER.lineWidth = lineThickness;
}


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame from:(CGPoint)from to:(CGPoint)to
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.from = from;
        self.to = to;
        // Set some defaults
        self.color = [UIColor redColor];
        self.lineThickness = 2.0;
        self.headSize = 30;
        self.headType = SCArrowViewHeadTypeEdges;
        self.bendiness = 0.2;
        self.curveType = SCArrowViewCurveTypeLeft;
        
        // Prepare the layer
        [self updateArrowLayer];
    }
    return self;
}


- (void)updateArrowLayer
{
    // Set some properties
    LAYER.strokeColor = self.color.CGColor;
    LAYER.lineWidth = self.lineThickness;
    LAYER.fillColor = nil; // Don't allow filling for now
    
    // Create the path of the arrow
    SCArrowPath *arrowPath;
    if(self.curveType == SCArrowViewCurveTypeBoth) {
        arrowPath = [[SCArrowPathCubic alloc] initWithStart:self.from end:self.to];
    } else {
        arrowPath = [[SCArrowPathQuad alloc] initWithStart:self.from end:self.to];
        if(self.curveType == SCArrowViewCurveTypeLeft) {
            ((SCArrowPathQuad*)arrowPath).leftHandedCurve = YES;
        }
    }
    arrowPath.bendiness = self.bendiness;
    
    UIBezierPath *path = [arrowPath arrowBezierPath];
    
    // Now draw the end
    SC2DVector *endV = [arrowPath directionAtEnd];
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.to size:self.headSize];
    
    // Add the path
    [path appendPath:[arrowHead arrowHeadBezierPath]];

    LAYER.path = path.CGPath;
}


@end
