//
//  SCCoreGraphicsArrowView.m
//  ArrowDrawing
//
//  Created by Sam Davies on 05/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCCoreGraphicsArrowView.h"

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
        self.backgroundColor = [UIColor whiteColor];
        self.from = from;
        self.to = to;
        // Set some defaults
        self.color = [UIColor redColor];
        self.lineThickness = 2.0;
        self.headSize = 30;
        self.headType = SCArrowViewHeadTypeFilled;
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
    CGPoint start = [self convertNormalisedPointToCurrentFrame:self.from];
    CGPoint end   = [self convertNormalisedPointToCurrentFrame:self.to];
    
    // Calculate arrow vector
    CGPoint arrowVect = [self addVector:end toVector:[self multiplyVector:start byScalar:-1]];
    // How bendy?
    CGFloat perpLength = self.bendiness * [self vectorLength:arrowVect];
    if(self.curveType == SCArrowViewCurveTypeLeft) {
        perpLength *= -1;
    }
    
    // Calculate perpendicular
    CGPoint arrowPerp = [self perpendicularToVector:arrowVect length:perpLength];
    //
    CGPoint control = [self addVector:start toVector:[self multiplyVector:arrowVect byScalar:0.5]];
    control = [self addVector:control toVector:arrowPerp];
    
    CGContextMoveToPoint(cxt, start.x, start.y);
    CGContextAddQuadCurveToPoint(cxt, control.x, control.y, end.x, end.y);
    [self.color setStroke];
    CGContextSetLineWidth(cxt, self.lineThickness);
    CGContextStrokePath(cxt);
    
    // Now draw the end
    CGPoint endVector = [self determinePointOnQuadBezierAtPosition:0.95 startPoint:start endPoint:end controlPoint:control];
    endVector.x = endVector.x - end.x;
    endVector.y = endVector.y - end.y;
    
    // Out at right angles
    CGPoint perpVector = [self perpendicularToVector:endVector length:self.headSize * 0.4];

    // Back from tip
    CGPoint footOfArrow = [self addVector:end toVector:[self resizeVector:endVector length:self.headSize]];
    CGPoint arrowSide1 = [self addVector:footOfArrow toVector:perpVector];
    CGPoint arrowSide2 = [self addVector:footOfArrow toVector:[self multiplyVector:perpVector byScalar:-1]];
    
    // Draw line to point
    CGContextMoveToPoint(cxt, arrowSide1.x, arrowSide1.y);
    CGContextAddLineToPoint(cxt, end.x, end.y);
    
    // Then to other out
    CGContextAddLineToPoint(cxt, arrowSide2.x, arrowSide2.y);
    
    if(self.headType == SCArrowViewHeadTypeTriangle) {
        CGContextClosePath(cxt);
    }
    
    if(self.headType == SCArrowViewHeadTypeFilled) {
        [self.color setFill];
        CGContextFillPath(cxt);
    }
    
    // Stroke it
    CGContextStrokePath(cxt);

    
}

- (CGPoint)convertNormalisedPointToCurrentFrame:(CGPoint)normalisedPoint
{
    CGPoint nonNormalised;
    nonNormalised.x = normalisedPoint.x * CGRectGetWidth(self.bounds);
    nonNormalised.y = normalisedPoint.y * CGRectGetHeight(self.bounds);
    return nonNormalised;
}

- (CGPoint)determinePointOnQuadBezierAtPosition:(CGFloat)t startPoint:(CGPoint)start
                                       endPoint:(CGPoint)end controlPoint:(CGPoint)control
{
    CGFloat x = (1-t) * ((1-t) * start.x + t * control.x) + t * ((1-t) * control.x + t * end.x);
    CGFloat y = (1-t) * ((1-t) * start.y + t * control.y) + t * ((1-t) * control.y + t * end.y);
    return CGPointMake(x, y);
}

- (CGPoint)perpendicularToVector:(CGPoint)vector length:(CGFloat)length
{
    CGPoint perpVector;
    perpVector.x =   vector.y;
    perpVector.y = - vector.x;
    return [self resizeVector:perpVector length:length];
}

- (CGPoint)resizeVector:(CGPoint)vector length:(CGFloat)length
{
    CGFloat currentLength = [self vectorLength:vector];
    return [self multiplyVector:vector byScalar:(length / currentLength)];
}

- (CGFloat)vectorLength:(CGPoint)vector
{
    return sqrt(vector.x * vector.x + vector.y * vector.y);
}

- (CGPoint)addVector:(CGPoint)v1 toVector:(CGPoint)v2
{
    CGPoint sum;
    sum.x = v1.x + v2.x;
    sum.y = v1.y + v2.y;
    return sum;
}

-(CGPoint)multiplyVector:(CGPoint)vector byScalar:(CGFloat)scalar
{
    return CGPointMake(vector.x * scalar, vector.y * scalar);
}


@end
