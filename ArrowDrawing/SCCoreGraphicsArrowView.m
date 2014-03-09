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
    SC2DVector *start = [SC2DVector vectorWithPoint:self.from];
    SC2DVector *end   = [SC2DVector vectorWithPoint:self.to];
    
    // Calculate arrow vector
    SC2DVector *arrowVect = [end addVector:[start multiplyByScalar:-1]];
    CGContextMoveToPoint(cxt, start.x, start.y);
    // How bendy?
    CGFloat perpLength = self.bendiness * [arrowVect length];
    // Calculate perpendicular
    SC2DVector *arrowPerp = [arrowVect perpendicularVectorOfLength:perpLength];
    
    // In preparation for the head
    CGPoint nearEnd;
    
    if(self.curveType == SCArrowViewCurveTypeBoth) {

        SC2DVector *c1 = [[start addVector:[arrowVect multiplyByScalar:1/3.0]] addVector:arrowPerp];
        SC2DVector *c2 = [[start addVector:[arrowVect multiplyByScalar:2/3.0]] addVector:[arrowPerp multiplyByScalar:-1]];

        
        nearEnd = [SCCurveUtils determinePointOnCubicBezierAtPosition:0.95
                                                                   startPoint:start.point
                                                                     endPoint:end.point
                                                                     control1:c1.point
                                                                     control2:c2.point];
        
        
        CGContextAddCurveToPoint(cxt, c1.x, c1.y, c2.x, c2.y, end.x, end.y);
    } else {
        if(self.curveType == SCArrowViewCurveTypeLeft) {
            arrowPerp = [arrowPerp multiplyByScalar:-1];
        }
        
        SC2DVector *control = [[start addVector:[arrowVect multiplyByScalar:0.5]] addVector:arrowPerp];
        
        nearEnd = [SCCurveUtils determinePointOnQuadBezierAtPosition:0.95
                                                          startPoint:start.point
                                                                    endPoint:end.point
                                                                controlPoint:control.point];
        
        CGContextAddQuadCurveToPoint(cxt, control.x, control.y, end.x, end.y);
    }
    
    [self.color setStroke];
    CGContextSetLineWidth(cxt, self.lineThickness);
    
    // Now draw the end
    SC2DVector *endV = [end addVector:[[SC2DVector vectorWithPoint:nearEnd] multiplyByScalar:-1]];
    
    // Out at right angles
    SC2DVector *perpVector = [endV perpendicularVectorOfLength:self.headSize * 0.4];

    // Back from tip
    SC2DVector *footOfArrow = [end addVector:[endV normalisedToLength:-self.headSize]];
    SC2DVector *arrowSide1 = [footOfArrow addVector:perpVector];
    SC2DVector *arrowSide2 = [footOfArrow addVector:[perpVector multiplyByScalar:-1]];
    

    // Draw line to point
    CGContextMoveToPoint(cxt, arrowSide1.x, arrowSide1.y);
    CGContextAddLineToPoint(cxt, end.x, end.y);
    
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
    CGContextAddLineToPoint(cxt, end.x, end.y);
    CGContextAddLineToPoint(cxt, arrowSide2.x, arrowSide2.y);
    if(self.headType == SCArrowViewHeadTypeTriangle) {
        CGContextAddLineToPoint(cxt, arrowSide1.x, arrowSide1.y);
    }
    CGContextDrawPath(cxt, drawingMode);
    
}





@end
