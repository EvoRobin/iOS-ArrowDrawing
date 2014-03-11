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
#define GENERATE_SETTER_WITH_LAYER_REDRAW(PROPERTY, TYPE, SETTER, UPDATE_METHOD) \
@synthesize PROPERTY = _##PROPERTY; \
\
- (void)SETTER:(TYPE)PROPERTY { \
_##PROPERTY = PROPERTY; \
[self UPDATE_METHOD]; \
}

@interface SCCoreAnimationArrowView ()

@property (nonatomic, strong) CAShapeLayer *arrowHeadLayer;
@property (nonatomic, strong) SCArrowPath *arrowPath;

@end


@implementation SCCoreAnimationArrowView

// Properties whose setters require a redraw of the layer
GENERATE_SETTER_WITH_LAYER_REDRAW(bendiness, CGFloat, setBendiness, updateArrowLayer)
GENERATE_SETTER_WITH_LAYER_REDRAW(curveType, SCArrowViewCurveType, setCurveType, updateArrowLayer)
GENERATE_SETTER_WITH_LAYER_REDRAW(from, CGPoint, setFrom, updateArrowLayer)
GENERATE_SETTER_WITH_LAYER_REDRAW(to, CGPoint, setTo, updateArrowLayer)
GENERATE_SETTER_WITH_LAYER_REDRAW(headSize, CGFloat, setHeadSize, updateArrowHead)
GENERATE_SETTER_WITH_LAYER_REDRAW(headType, SCArrowViewHeadType, setHeadType, updateArrowHead)

// Other properties
@synthesize lineThickness = _lineThickness;
@synthesize color = _color;

- (void)setColor:(UIColor *)color
{
    _color = color;
    LAYER.strokeColor = color.CGColor;
    self.arrowHeadLayer.strokeColor = color.CGColor;
    [self updateHeadType];
}

- (void)setLineThickness:(CGFloat)lineThickness
{
    _lineThickness = lineThickness;
    LAYER.lineWidth = lineThickness;
    self.arrowHeadLayer.lineWidth = lineThickness;
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
    if(self.curveType == SCArrowViewCurveTypeBoth) {
        self.arrowPath = [[SCArrowPathCubic alloc] initWithStart:self.from end:self.to];
    } else {
        self.arrowPath = [[SCArrowPathQuad alloc] initWithStart:self.from end:self.to];
        if(self.curveType == SCArrowViewCurveTypeLeft) {
            ((SCArrowPathQuad*)self.arrowPath).leftHandedCurve = YES;
        }
    }
    self.arrowPath.bendiness = self.bendiness;
    
    UIBezierPath *path = [self.arrowPath arrowBezierPath];
    
    // Now draw the end
    SC2DVector *endV = [self.arrowPath directionAtEnd];
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.to size:self.headSize];
    
    // Add the path
    [path appendPath:[arrowHead arrowHeadBezierPath]];

    LAYER.path = path.CGPath;
    
    // Also need to update the head
    [self updateArrowHead];
}

- (void)updateArrowHead
{
    if(!self.arrowHeadLayer) {
        self.arrowHeadLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.arrowHeadLayer];
    }
    // Check the size and position
    self.arrowHeadLayer.bounds = self.bounds;
    self.arrowHeadLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Create the head
    SC2DVector *endV = [self.arrowPath directionAtEnd];
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.to size:self.headSize];
    
    // Add the path
    UIBezierPath *headPath = [arrowHead arrowHeadBezierPath];
    
    [self updateHeadType];
    if(self.headType != SCArrowViewHeadTypeEdges) {
        [headPath closePath];
    }

    self.arrowHeadLayer.path = headPath.CGPath;
}

#pragma mark - Utility methods
- (void)updateHeadType
{
    if(self.headType == SCArrowViewHeadTypeFilled) {
        self.arrowHeadLayer.fillColor = self.color.CGColor;
    } else {
        self.arrowHeadLayer.fillColor = nil;
    }
}


@end
