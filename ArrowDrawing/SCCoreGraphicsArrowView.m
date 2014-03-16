/*
 Copyright 2014 Scott Logic Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "SCCoreGraphicsArrowView.h"
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

@implementation SCCoreGraphicsArrowView

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
        self.userInteractionEnabled = NO;
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

- (void)redrawArrow
{
    [self setNeedsDisplay];
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
        arrowPath = [[SCArrowPathCubic alloc] initWithStart:self.from end:self.to];
    } else {
        arrowPath = [[SCArrowPathQuad alloc] initWithStart:self.from end:self.to];
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
    SCArrowHead *arrowHead = [[SCArrowHead alloc] initWithDirection:endV tip:self.to size:self.headSize];

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

@end
