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


#import "TapDetectingView.h"
#import "constants.h"

 
CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);



@implementation TapDetectingView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
  		 timeOfLastAction = [[NSDate date] retain];
    }
    return self;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if ([delegate respondsToSelector:@selector(setMapNeedslayout)])
        [delegate performSelector:@selector(setMapNeedslayout)];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{		
    // cancel any pending handleSingleTap messages 
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleDoubleTap) object:nil];	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTrippleTap) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleTwoFingerTap) object:nil];

	
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
	
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if ([[NSDate date] timeIntervalSinceDate:timeOfLastAction] < GEST_DELAY) 
	{
		return;
	}
	 

	
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:SINGLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
			[self performSelector:@selector(handleDoubleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
            //[self handleDoubleTap];        
		} else if([touch tapCount] == 3) {
			[self performSelector:@selector(handleTrippleTap) withObject:nil afterDelay:TRIPPLE_TAP_DELAY];
			//[self handleTrippleTap];
		}
		/*
		else if([touch tapCount] == 4) {
			[self handleQuadroTap];
		} else if([touch tapCount] == 10) {
			[self handleDecaTap];
		}
		*/
    }    
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
    else if (multipleTouches && twoFingerTapIsPossible) { 
        
        // case 1: this is the end of both touches at once 
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0; 
			
            int tapCounts[2]; 
			for (int k = 0; k < 2; k++)
				tapCounts[k] = -1;
			
			CGPoint tapLocations[2];
            
			for (UITouch *touch in touches) 
			{
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
			
            if (tapCounts[0] == 1 && tapCounts[1] == 1) 
			{ // it's a two-finger tap if they're both single taps
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
				  [self performSelector:@selector(handleTrippleTap) withObject:nil afterDelay:TWO_FINGERS_SINGLE_TAP_DELAY];
                //[self handleTwoFingerTap];
            }
        }
        
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }

        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self]);
				  [self performSelector:@selector(handleTwoFingerTap) withObject:nil afterDelay:TWO_FINGERS_SINGLE_TAP_DELAY];
                //[self handleTwoFingerTap];
            }
        }
    }
        
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;

}

#pragma mark Private

//if we do double tap we call the right method in MapController to perform it
- (void)handleSingleTap 
{
	if ([delegate respondsToSelector:@selector(tapDetectingView:gotSingleTapAtPoint:)])
		[delegate tapDetectingView:self gotSingleTapAtPoint:tapLocation];
	
#ifdef LOG_TEXT	
	double start = [[NSDate date] timeIntervalSince1970];	
	NSLog(@"time of fire - handleSingleTap: %f", start);
#endif	
}

- (void)handleDoubleTap 
{
	[timeOfLastAction release];		
	timeOfLastAction = [[NSDate date] retain];
	
		if ([delegate respondsToSelector:@selector(tapDetectingView:gotDoubleTapAtPoint:)])
			[delegate tapDetectingView:self gotDoubleTapAtPoint:tapLocation];
	
#ifdef LOG_TEXT	
	double start = [[NSDate date] timeIntervalSince1970];
	NSLog(@"time of fire - handleDoubleTap: %f", start);
#endif	
}




- (void)handleTrippleTap 
{
	[timeOfLastAction release];		
	timeOfLastAction = [[NSDate date] retain];
	
		if ([delegate respondsToSelector:@selector(tapDetectingView:gotTrippleTapAtPoint:)])
			[delegate tapDetectingView:self gotTrippleTapAtPoint:tapLocation];

#ifdef LOG_TEXT	
	double start = [[NSDate date] timeIntervalSince1970];
	NSLog(@"time of fire - handleTrippleTap: %f", start);
#endif	
}

- (void)handleTwoFingerTap 
{
	[timeOfLastAction release];		
	timeOfLastAction = [[NSDate date] retain];
	
	   if ([delegate respondsToSelector:@selector(tapDetectingView:gotTwoFingerTapAtPoint:)])
		   [delegate tapDetectingView:self gotTwoFingerTapAtPoint:tapLocation];
	
#ifdef LOG_TEXT	
	double start = [[NSDate date] timeIntervalSince1970];
	NSLog(@"time of fire - handleTwoFingerTap: %f", start);
#endif	
}

/*
- (void)handleQuadroTap 
{
}

- (void)handleDecaTap 
{
}
*/

    



//compute center of line between two points - it is good for tap with two fingers - it is more precise coordination than
CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}


- (void)dealloc {
    [timeOfLastAction release];
    [super dealloc];
}

@end
                    
