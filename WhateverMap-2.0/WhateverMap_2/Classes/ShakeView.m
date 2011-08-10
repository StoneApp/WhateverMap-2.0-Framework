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

#import "ShakeView.h"
#import "constants.h" 
#import "WMMapView.h"


@implementation ShakeView

@synthesize delegate;


/*
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}
*/

/*
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}
*/


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event 
{
	
	
#ifdef DEBUG	
	NSLog(@"shake end");
#endif	 
	
	
	if (event.type == UIEventSubtypeMotionShake) 
	{
		//test zoom:6 LonLat:LatLonMake(50, 15.4)
		[[self.delegate wmMapView] zoomToLevel:HOME_AREA_ZOOM animated:NO];
		[[self.delegate wmMapView] goToLonLat:HOME_AREA_LATLON animated:NO];			
		[self.delegate storeActualHistoryMovement];		
		[[self.delegate wmMapView] didUserInteract];
	}
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}


@end
