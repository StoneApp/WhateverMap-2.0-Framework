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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MapControllerProtocol.h"

#define MAX_COUNTER 10

//inspiration
//http://discussions.apple.com/thread.jspa?messageID=7407254
//http://iappdevs.blog.co.in/2008/12/06/get-current-location-sample-example-iphone-programming/
//http://www.bagonca.com/blog/tag/howto/
//http://www.mobileorchard.com/hello-there-a-corelocation-tutorial/


@interface Locator : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id<MapControllerProtocol> delegateObject;
	id mapController;
	NSInteger counter;
	BOOL isUpdating;
	CLLocation *lastUpdateLocation;
	BOOL firstLocalization;
}

@property (readonly) BOOL isUpdating;
@property (assign) BOOL firstLocalization;
@property (nonatomic, retain) id<MapControllerProtocol> delegateObject;
@property (nonatomic, retain) CLLocation *lastUpdateLocation;
@property (nonatomic, retain) id mapController;

+ (Locator *)sharedInstance;

- (id) initLocatorWithDelegate:(id)newDelegateObject;
- (BOOL) canStartLocationUpdate;
- (void) startUpdates;
- (void) stopUpdates;
- (void) startStopUpdates;


@end
