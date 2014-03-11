//
//  SCAnimatingCGArrowView.m
//  ArrowDrawing
//
//  Created by Sam Davies on 11/03/2014.
//  Copyright (c) 2014 Shinobi Controls. All rights reserved.
//

#import "SCAnimatingCGArrowView.h"
#import "SCCurveUtils.h"
#import "SC2DVector.h"
#import "SCArrowPathQuad.h"
#import "SCArrowPathCubic.h"
#import "SCArrowHead.h"

#define GENERATE_SETTER_WITH_SETNEEDSDISPLAY(PROPERTY, TYPE, SETTER) \
@synthesize PROPERTY = _##PROPERTY; \
\
- (void)SETTER:(TYPE)PROPERTY { \
_##PROPERTY = PROPERTY; \
[self setNeedsDisplay]; \
}

@interface SCAnimatingCGArrowView ()

@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CGPoint currentEnd;
@property (nonatomic, assign) BOOL shouldAnimate;
@property (nonatomic, assign) CFTimeInterval animationStartTime;

@end


@implementation SCAnimatingCGArrowView

GENERATE_SETTER_WITH_SETNEEDSDISPLAY(lineThickness, CGFloat, setLineThickness)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(bendiness, CGFloat, setBendiness)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(color, UIColor *, setColor)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(curveType, SCArrowViewCurveType, setCurveType)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(from, CGPoint, setFrom)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(to, CGPoint, setTo)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(headSize, CGFloat, setHeadSize)
GENERATE_SETTER_WITH_SETNEEDSDISPLAY(headType, SCArrowViewHeadType, setHeadType)

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
        self.animationTime = 2;
        [self animationUpdate:nil];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Some local path variables
    CGPathRef arrowCGPath;
    CGPathRef headCGPath;
    
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
        arrowPath = [[SCArrowPathCubic alloc] initWithStart:self.from end:self.currentEnd];
    } else {
        arrowPath = [[SCArrowPathQuad alloc] initWithStart:self.from end:self.currentEnd];
        if(self.curveType == SCArrowViewCurveTypeLeft) {
            ((SCArrowPathQuad*)arrowPath).leftHandedCurve = YES;
        }
    }
    
    arrowPath.bendiness = self.bendiness;
    arrowCGPath = [arrowPath arrowPath];
    CGContextAddPath(cxt, arrowCGPath);
    
    
    /* We're adding the end to this path so that the path joins are correct. It
     might seem nice to draw the arrow path and head path separately, but then
     the arrow will stick out beyond the head. Therefore we draw the arrow here
     and then re-draw it if we need to
     */
    
    // Now draw the end
    SC2DVector *endV = [arrowPath directionAtEnd];
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.currentEnd size:self.headSize];
    
    // Add the path
    headCGPath = [arrowHead arrowHeadPath];
    CGContextAddPath(cxt, headCGPath);
    
    // Stroke the arrow and head
    CGContextStrokePath(cxt);
    
    // If we only want the edges, then we're done, otherwise, need to redraw the head
    if(self.headType != SCArrowViewHeadTypeEdges) {
        CGPathDrawingMode drawingMode = (self.headType == SCArrowViewHeadTypeFilled) ? kCGPathFillStroke : kCGPathStroke;
        // Redraw the head
        CGContextAddPath(cxt, headCGPath);
        // Close the path so we cover both the triangle and filled state
        CGContextClosePath(cxt);
        CGContextDrawPath(cxt, drawingMode);
    }
    
    // Release some CGPaths
    CGPathRelease(arrowCGPath);
    CGPathRelease(headCGPath);
}

- (void)animationUpdate:(CADisplayLink *)sender
{
    if(!sender) {
        self.animationStartTime = CACurrentMediaTime();
    }
    
    CGFloat proportionComplete = (CACurrentMediaTime() - self.animationStartTime) / self.animationTime;
    
    if(proportionComplete >= 1) {
        self.currentEnd = self.to;
        self.shouldAnimate = NO;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        self.shouldAnimate = YES;
        self.currentEnd = CGPointMake((self.to.x - self.from.x) * proportionComplete + self.from.x,
                                      (self.to.y - self.from.y) * proportionComplete + self.from.y);
        // And prepare to be called back in the future
        if(!self.timer) {
            self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationUpdate:)];
            [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }
    
    [self setNeedsDisplay];
}

@end
