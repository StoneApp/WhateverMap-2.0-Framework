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


@interface PositionView : UIView {
	BOOL showCircle;
	BOOL showPoint;
	BOOL showAngle;

	CGPoint centerPoint;	
	CGPoint offset;	
	float diameter;
	float lastDrawedDiameter;
	CGPoint lastCenterPoint;
	float circleScale;
	
	UIImageView *circleImageView;
	UIImageView *angleImageView;
	UIImageView *pointImageView;
	UIImageView *compositionView;

}

@property (assign) BOOL showCircle;
@property (assign) BOOL showPoint;
@property (assign) BOOL showAngle;
@property (assign) CGPoint centerPoint;
@property (assign) CGPoint offset;	
@property (assign) float diameter;	

- (void) drawCircle:(float)drawingDiameter;
- (void) drawAngle;
- (void) drawPoint;

- (void) show;
- (void) hide;
- (BOOL) isHidden;

@end
