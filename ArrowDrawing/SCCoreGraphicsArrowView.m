//
//  SCCoreGraphicsArrowView.m
//  ArrowDrawing
//
//  Created by Sam Davies on 05/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreGraphicsArrowView.h"
#import "SCVectorUtils.h"

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
    CGPoint start = self.from;
    CGPoint end   = self.to;
    
    // Calculate arrow vector
    CGPoint arrowVect = [SCVectorUtils addVector:end toVector:[SCVectorUtils multiplyVector:start byScalar:-1]];
    CGContextMoveToPoint(cxt, start.x, start.y);
    // How bendy?
    CGFloat perpLength = self.bendiness * [SCVectorUtils vectorLength:arrowVect];
    // Calculate perpendicular
    CGPoint arrowPerp = [SCVectorUtils perpendicularToVector:arrowVect length:perpLength];
    // In preparation for the head
    CGPoint endVector;
    
    if(self.curveType == SCArrowViewCurveTypeBoth) {
        CGPoint control1 = [SCVectorUtils addVector:start toVector:[SCVectorUtils multiplyVector:arrowVect byScalar:1/3.0]];
        control1 = [SCVectorUtils addVector:control1 toVector:arrowPerp];
        
        CGPoint control2 = [SCVectorUtils addVector:start toVector:[SCVectorUtils multiplyVector:arrowVect byScalar:2/3.0]];
        control2 = [SCVectorUtils addVector:control2 toVector:[SCVectorUtils multiplyVector:arrowPerp byScalar:-1]];
        
        endVector = [SCVectorUtils determinePointOnCubicBezierAtPosition:0.95 startPoint:start endPoint:end control1:control1 control2:control2];
        
        CGContextAddCurveToPoint(cxt, control1.x, control1.y, control2.x, control2.y, end.x, end.y);
    } else {
        if(self.curveType == SCArrowViewCurveTypeLeft) {
            perpLength *= -1;
        }
        
        CGPoint control = [SCVectorUtils addVector:start toVector:[SCVectorUtils multiplyVector:arrowVect byScalar:0.5]];
        control = [SCVectorUtils addVector:control toVector:arrowPerp];
        
        endVector = [SCVectorUtils determinePointOnQuadBezierAtPosition:0.95 startPoint:start endPoint:end controlPoint:control];
        
        CGContextAddQuadCurveToPoint(cxt, control.x, control.y, end.x, end.y);
    }
    
    [self.color setStroke];
    CGContextSetLineWidth(cxt, self.lineThickness);
    
    // Now draw the end
    endVector.x = endVector.x - end.x;
    endVector.y = endVector.y - end.y;
    
    // Out at right angles
    CGPoint perpVector = [SCVectorUtils perpendicularToVector:endVector length:self.headSize * 0.4];

    // Back from tip
    CGPoint footOfArrow = [SCVectorUtils addVector:end toVector:[SCVectorUtils resizeVector:endVector length:self.headSize]];
    CGPoint arrowSide1 = [SCVectorUtils addVector:footOfArrow toVector:perpVector];
    CGPoint arrowSide2 = [SCVectorUtils addVector:footOfArrow toVector:[SCVectorUtils multiplyVector:perpVector byScalar:-1]];
    
    
    
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
