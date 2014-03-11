//
//  SCCoreGraphicsArrowView.m
//  ArrowDrawing
//
//  Created by Sam Davies on 05/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreGraphicsArrowView.h"
#import "SCCurveUtils.h"
#import "SC2DVector.h"
#import "SCArrowPathQuad.h"
#import "SCArrowPathCubic.h"
#import "SCArrowHead.h"

@implementation SCCoreGraphicsArrowView

@synthesize lineThickness = _lineThickness;
@synthesize bendiness = _bendiness;
@synthesize color = _color;
@synthesize curveType = _curveType;
@synthesize from = _from;
@synthesize to = _to;
@synthesize headSize = _headSize;
@synthesize headType = _headType;

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
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Obtain the drawing context
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    // Prepare some settings
    [self.color setStroke];
    [self.color setFill];
    CGContextSetLineWidth(cxt, self.lineThickness);
    
    // Start a path
    CGContextBeginPath(cxt);
    
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
    CGContextAddPath(cxt, [arrowPath arrowPath]);
    
    
    /* We're adding the end to this path so that the path joins are correct. It
     might seem nice to draw the arrow path and head path separately, but then
     the arrow will stick out beyond the head. Therefore we draw the arrow here
     and then re-draw it if we need to
     */
    
    // Now draw the end
    SC2DVector *endV = [arrowPath directionAtEnd];
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.to size:self.headSize];

    // Add the path
    CGContextAddPath(cxt, arrowHead.arrowHeadPath);
    
    // Stroke the arrow and head
    CGContextStrokePath(cxt);
    
    // If we only want the edges, then we're done, otherwise, need to redraw the head
    if(self.headType != SCArrowViewHeadTypeEdges) {
        CGPathDrawingMode drawingMode = (self.headType == SCArrowViewHeadTypeFilled) ? kCGPathFillStroke : kCGPathStroke;
        // Redraw the head
        CGContextAddPath(cxt, arrowHead.arrowHeadPath);
        // Close the path so we cover both the triangle and filled state
        CGContextClosePath(cxt);
        CGContextDrawPath(cxt, drawingMode);
    }
}





@end
