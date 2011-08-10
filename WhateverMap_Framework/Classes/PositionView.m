//Copyright 2011 Jiří Kamínek / Mendel University in Brno - kaminek.jiri@stoneapp.com
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "UIKit/UIKit.h"
#import "PositionView.h"
//#import "MapController.h"

#define SAFE_FRAME 5
#define MAX_CIRCLE_DIAMETER	150

@implementation PositionView

@synthesize showPoint, showCircle, showAngle;
@synthesize centerPoint, diameter;
@synthesize offset;



- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		showCircle = NO;
		showPoint = NO;
		showAngle = NO;

		//TODO test
		//showCircle = YES;
		//showPoint = YES;
		//showAngle = YES;
			
		centerPoint = CGPointMake(0, 0);			
		lastCenterPoint = centerPoint;
		diameter = 0;
		lastDrawedDiameter = diameter;
		
		circleScale = 1.0;
		
		circleImageView = [[UIImageView alloc] initWithImage:nil];		
		angleImageView = [[UIImageView alloc] initWithImage:nil];		
		pointImageView = [[UIImageView alloc] initWithImage:nil];
		
		compositionView = [[UIImageView alloc] initWithImage:nil];
		[compositionView addSubview:circleImageView]; //add circle determine position precission
		//[compositionView addSubview:angleImageView]; //add angle for compass view 
		[compositionView addSubview:pointImageView]; //add point showing coordinates received from receiver
		
		[self hide];
				
		[self addSubview:compositionView];
		
		[self drawAngle];
		[self drawPoint];
        
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		
    }
    return self;
}



//#define FIX_POINT CGPointMake(0, -20)
#define FIX_POINT CGPointMake(0, 0)

-(void) drawRect:(CGRect)rect 
{
	if (lastCenterPoint.x != centerPoint.x || lastCenterPoint.y != centerPoint.y)	
	{
		CGAffineTransform newPointTransform = CGAffineTransformMakeTranslation(centerPoint.x + FIX_POINT.x , centerPoint.y + FIX_POINT.y);
		if (!CGAffineTransformEqualToTransform(compositionView.transform, newPointTransform))
			[compositionView setTransform:newPointTransform];
		
		lastCenterPoint = centerPoint;		
	}
	
	
	if (lastDrawedDiameter == diameter && lastCenterPoint.x == centerPoint.x && lastCenterPoint.y == centerPoint.y)
		return;

	
	if (showCircle)
	{
		if (circleImageView.hidden)
			[circleImageView setHidden:false];
		
		if (diameter < MAX_CIRCLE_DIAMETER)
		{		
			[self drawCircle:diameter];
			[circleImageView setTransform:CGAffineTransformIdentity];
			circleScale = 1.0;
		}
		else 
		{
			if (lastDrawedDiameter < MAX_CIRCLE_DIAMETER)
				[self drawCircle:MAX_CIRCLE_DIAMETER];
				
			circleScale = diameter/MAX_CIRCLE_DIAMETER;
		}	
		
		CGAffineTransform newCircleTransform = CGAffineTransformMakeScale(circleScale, circleScale);
		if (!CGAffineTransformEqualToTransform(circleImageView.transform, newCircleTransform))
			[circleImageView setTransform:newCircleTransform];				
	}
	else 
	{
		if (!circleImageView.hidden)
			[circleImageView setHidden:true];
	}
	
	if (lastCenterPoint.x == centerPoint.x && lastCenterPoint.y == centerPoint.y)
		return;	
	
	if (showAngle)
	{
		if (angleImageView.hidden)
			[angleImageView setHidden:false];		
	}
	else 
	{
		if (!angleImageView.hidden)
			[angleImageView setHidden:true];
	}
	
	if (showPoint)
	{
		if (pointImageView.hidden)
			[pointImageView setHidden:false];
	}
	else 
	{
		if (!pointImageView.hidden)
			[pointImageView setHidden:true];
	}
	
	lastCenterPoint = centerPoint;
	
#ifdef LOG_TEXT	
	NSLog(@"position redrawed");
#endif	
}


- (void) drawCircle:(float)drawingDiameter
{
	if (drawingDiameter > MAX_CIRCLE_DIAMETER)
		drawingDiameter = MAX_CIRCLE_DIAMETER;
	
	if (lastDrawedDiameter != drawingDiameter)
		lastDrawedDiameter = drawingDiameter;
	
	CGSize contextSize = CGSizeMake(2*(MAX_CIRCLE_DIAMETER+SAFE_FRAME),2*(MAX_CIRCLE_DIAMETER+SAFE_FRAME));
	UIGraphicsBeginImageContext(contextSize);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetAllowsAntialiasing(context, true);
	//CGContextSetShouldAntialias(context, true);
	
	CGRect circleFrame = CGRectMake(contextSize.width/2 - drawingDiameter , contextSize.height/2 - drawingDiameter, 2 * drawingDiameter, 2 * drawingDiameter);

	//set color of inside fill
	CGContextSetRGBFillColor(context, 0.06, 0.35, 0.65 , 0.09);
	CGContextFillEllipseInRect(context, circleFrame);		
	
	//set color of outside circle
	CGContextSetLineWidth(context, 1.0); // line width
	CGContextSetRGBStrokeColor(context, 0.05, 0.35, 0.65 , 0.8);		
	CGContextStrokeEllipseInRect(context, circleFrame);
	
	
	CGImageRef myImageRef = CGBitmapContextCreateImage (context);
	
	
	if (circleImageView.image == nil)
	{ 
        UIImage *image = [[UIImage alloc] initWithCGImage:myImageRef];
        [circleImageView setImage:image];
        [image release];
        
		[circleImageView setFrame:CGRectMake(-[circleImageView.image size].width/2, -[circleImageView.image size].height/2, [circleImageView.image size].width, [circleImageView.image size].height)];
	}	
	else 
	{
        UIImage *image = [[UIImage alloc] initWithCGImage:myImageRef];
        [circleImageView setImage:image];
        [image release];
	}
	 

		
	CGImageRelease (myImageRef);
	
	UIGraphicsEndImageContext(); //end context	
}


- (void) drawAngle
{
	CGPoint centerOfAngle = CGPointMake(25, 100);
	
	UIGraphicsBeginImageContext(CGSizeMake(50,100));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetShouldAntialias(context, true);

	//angle for compass
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = 
	{ 
		0.85, 0.85, 0.95 , 0.0,  // outer color
		0.95, 0.95, 0.95 , 0.35   // inner color
	};
	
	
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef glossGradient =	CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGPoint difference = CGPointMake(0, 0);
	CGPoint innerCenter = CGPointMake(centerOfAngle.x + difference.x, centerOfAngle.y + difference.y);	
	
	float compassDiff = 100;
	difference = CGPointMake(0, -compassDiff);	
	CGPoint outerCenter = CGPointMake(centerOfAngle.x + difference.x, centerOfAngle.y + difference.y);
	
	CGFloat innerRadius = 0.0;
	CGFloat outerRadius = 20.0;
	
	CGContextDrawRadialGradient(context, glossGradient, outerCenter, outerRadius, innerCenter, innerRadius, kCGGradientDrawsAfterEndLocation);
	
	
	// line arround angle
	NSInteger count = 8; //use x-times alpha line (is there a gradient for line? - this should be replaced)
	CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2 , 0.04);		
	for (int i = 1; i <= count; i++) 
	{
		CGContextSetLineWidth(context, i * 0.2);
		NSInteger xDiff = (outerRadius/count) * i; 
		NSInteger yDiff = (compassDiff/count) * i;
		CGPoint points[4] = { CGPointMake(centerOfAngle.x, centerOfAngle.y), CGPointMake(centerOfAngle.x+xDiff, centerOfAngle.y-yDiff), CGPointMake(centerOfAngle.x, centerOfAngle.y), CGPointMake(centerOfAngle.x-xDiff, centerOfAngle.y-yDiff)};
		CGContextStrokeLineSegments(context, points, 4);
	}
	
	CGImageRef myImageRef = CGBitmapContextCreateImage (context);
	
    UIImage *image = [[UIImage alloc] initWithCGImage:myImageRef];
    [angleImageView setImage:image];
    [image release];
	[angleImageView setFrame:CGRectMake(-25, -100, [angleImageView.image size].width, [angleImageView.image size].height)];
	
	CGImageRelease (myImageRef);
	CGColorSpaceRelease(rgbColorspace);
	CGGradientRelease(glossGradient);
	
	UIGraphicsEndImageContext(); //end context
}

- (void) drawPoint
{
	CGPoint centerOfPoint = CGPointMake(10, 10);
	UIGraphicsBeginImageContext(CGSizeMake(20,20));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetShouldAntialias(context, true);

	//point
	size_t num_locations = 4;
	//outer --> inner
	CGFloat locations[4] = { 0.0, 0.2, 0.3, 1.0 };
	CGFloat components[20] = 
	{ 
		0.05, 0.35, 0.65 , 1.0,  // outer color
		
		0.07, 0.37, 0.67 , 1.0,
		0.05, 0.35, 0.65 , 1.0,
		
		0.25, 0.55, 0.95 , 1.0   // inner color
	}; 
	
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef glossGradient =	CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGPoint difference = CGPointMake(1, -3);
	CGPoint innerCenter = CGPointMake(centerOfPoint.x + difference.x, centerOfPoint.y + difference.y);	
	
	difference = CGPointMake(0, 0);	
	CGPoint outerCenter = CGPointMake(centerOfPoint.x + difference.x, centerOfPoint.y + difference.y);
	
	CGFloat innerRadius = 0.0;
	CGFloat outerRadius = 8.0;
	
	CGContextDrawRadialGradient(context, glossGradient, outerCenter, outerRadius, innerCenter, innerRadius, kCGGradientDrawsAfterEndLocation);
	
	//line arnoud the point - support antialiasing (gradient do not)
	CGContextSetLineWidth(context, 1.0); // line width
	CGContextSetRGBStrokeColor(context, 0.05, 0.35, 0.65 , 0.8);		
	float pointRadius = outerRadius + 0.2;
	CGRect pointFrame = CGRectMake(centerOfPoint.x - pointRadius , centerOfPoint.y - pointRadius, 2 * pointRadius, 2 * pointRadius);
	CGContextStrokeEllipseInRect(context, pointFrame);	
	
	
	CGImageRef myImageRef = CGBitmapContextCreateImage (context);
	
    UIImage *image = [[UIImage alloc] initWithCGImage:myImageRef];
    [pointImageView setImage:image];
    [image release];
	[pointImageView setFrame:CGRectMake(-10, -10, [pointImageView.image size].width, [pointImageView.image size].height)];
	
	CGImageRelease (myImageRef);
	CGColorSpaceRelease(rgbColorspace);
	CGGradientRelease(glossGradient);	
	
	UIGraphicsEndImageContext(); //end context
}


- (void) show
{
	showCircle = YES;
	showPoint = YES;
	showAngle = NO;
	[circleImageView setHidden:false];
	[angleImageView setHidden:false];
	[pointImageView setHidden:false];	
}

- (void) hide
{
	showCircle = NO;
	showPoint = NO;
	showAngle = NO;	
	[circleImageView setHidden:true];
	[angleImageView setHidden:true];
	[pointImageView setHidden:true];	
}

- (BOOL) isHidden
{
	return !(showCircle && showPoint && showAngle);
}


- (void)dealloc 
{
   [super dealloc];
}


@end
