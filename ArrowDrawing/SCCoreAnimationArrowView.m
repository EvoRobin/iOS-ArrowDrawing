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

@implementation SCCoreAnimationArrowView

@synthesize lineThickness = _lineThickness;
@synthesize bendiness = _bendiness;
@synthesize color = _color;
@synthesize curveType = _curveType;
@synthesize from = _from;
@synthesize to = _to;
@synthesize headSize = _headSize;
@synthesize headType = _headType;

#define LAYER ((CAShapeLayer*)self.layer)

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


#pragma mark - Property setters
- (void)setFrom:(CGPoint)from
{
    _from = from;
    [self updateArrowLayer];
}

- (void)setTo:(CGPoint)to
{
    _to = to;
    [self updateArrowLayer];
}

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

- (void)setHeadSize:(CGFloat)headSize
{
    _headSize = headSize;
    [self updateArrowLayer];
}

- (void)setHeadType:(SCArrowViewHeadType)headType
{
    _headType = headType;
    [self updateArrowLayer];
}

- (void)setBendiness:(CGFloat)bendiness
{
    _bendiness = bendiness;
    [self updateArrowLayer];
}

- (void)setCurveType:(SCArrowViewCurveType)curveType
{
    _curveType = curveType;
    [self updateArrowLayer];
}

@end
