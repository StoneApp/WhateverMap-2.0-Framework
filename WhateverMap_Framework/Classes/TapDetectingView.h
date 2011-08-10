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
#import <Foundation/Foundation.h>

@protocol TapDetectingViewDelegate;

//detect finger movements or taping on the screen of the device 
@interface TapDetectingView : UIView 
{	
    id <TapDetectingViewDelegate> delegate;
    
    // Touch detection
    CGPoint tapLocation;         // Needed to record location of single tap, which will only be registered after delayed perform.
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).
	 NSDate *timeOfLastAction; 
}

@property (nonatomic, assign) id <TapDetectingViewDelegate> delegate;
@end



@protocol TapDetectingViewDelegate <NSObject>

@optional
- (void) tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void) tapDetectingView:(TapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void) tapDetectingView:(TapDetectingView *)view gotTrippleTapAtPoint:(CGPoint)tapPoint;
- (void) tapDetectingView:(TapDetectingView *)view gotDecaTapAtPoint:(CGPoint)tapPoint;
- (void) tapDetectingView:(TapDetectingView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;
- (void) setMapNeedslayout;
@end


@interface TapDetectingView ()
- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTrippleTap;
- (void)handleTwoFingerTap;
//- (void)handleQuadroTap;
//- (void)handleDecaTap;
@end

