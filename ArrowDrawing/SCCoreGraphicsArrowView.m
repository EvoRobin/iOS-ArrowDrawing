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
    // Drawing code
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextBeginPath(cxt);
    
    // Which kind of path are we going to use?
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
    
    [self.color setStroke];
    CGContextSetLineWidth(cxt, self.lineThickness);
    
    if(arrowPath) {
        // Now draw the end
        SC2DVector *endV = [arrowPath directionAtEnd];
        
        // Out at right angles
        SC2DVector *perpVector = [endV perpendicularVectorOfLength:self.headSize * 0.4];

        // Back from tip
        SC2DVector *footOfArrow = [[SC2DVector vectorWithPoint:self.to] addVector:[endV normalisedToLength:-self.headSize]];
        SC2DVector *arrowSide1 = [footOfArrow addVector:perpVector];
        SC2DVector *arrowSide2 = [footOfArrow addVector:[perpVector multiplyByScalar:-1]];
        

        // Draw line to point
        CGContextMoveToPoint(cxt, arrowSide1.x, arrowSide1.y);
        CGContextAddLineToPoint(cxt, self.to.x, self.to.y);
        
        // Then to other out
        CGContextAddLineToPoint(cxt, arrowSide2.x, arrowSide2.y);
        
        
        // Stroke it
        CGContextStrokePath(cxt);
        
        CGPathDrawingMode drawingMode;
        if(self.headType == SCArrowViewHeadTypeFilled) {
            drawingMode = kCGPathFillStroke;
        } else {
            drawingMode = kCGPathStroke;
        }
        
        [self.color setFill];
        // Redraw the head
        CGContextMoveToPoint(cxt, arrowSide1.x, arrowSide1.y);
        CGContextAddLineToPoint(cxt, self.to.x, self.to.y);
        CGContextAddLineToPoint(cxt, arrowSide2.x, arrowSide2.y);
        if(self.headType == SCArrowViewHeadTypeTriangle) {
            CGContextAddLineToPoint(cxt, arrowSide1.x, arrowSide1.y);
        }
        CGContextDrawPath(cxt, drawingMode);
    } else {
        CGContextStrokePath(cxt);
    }
    
}





@end
