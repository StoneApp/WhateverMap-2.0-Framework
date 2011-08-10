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

#import "Locator.h"
#import "constants.h"
#import "WMSSource.h"
#import "MapController.h"
#import "AppDelegate.h"
#import "PositionView.h"
#import "Common.h"
#import "WMMapView.h"

//just simplification - do not compute with curvature of earth - better to use Great Circle Metric
//Using the figures for 31 degrees North latitude, it is possible to construct the following table:
//	1 degree of latitude     =          1.000000 degree          or         110,874.40 meters
//	1/10 of a degree of latitude     =     0.100000 degree     or     11,087.44 meters
//	1/100 of a degree of latitude     =     0.010000 degree     or     1,108.74 meters
//	1/1000 of a degree of latitude     =     0.001000 degree     or     110.87 meters
//	1/10000 of a degree of latitude     =     0.000100 degree     or     11.09 meters
//	1/100000 of a degree of latitude     =     0.000010 degree     or     1.11 meters
//	1/1000000 of a degree of latitude         =     0.000001 degree     or     .11 meters




@implementation Locator

@synthesize delegateObject, mapController, isUpdating, firstLocalization, lastUpdateLocation;


+ (Locator *)sharedInstance
{
	static Locator *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[Locator alloc] initLocatorWithDelegate:self];		  
		}
	}
	
	return instance;
}


- (id) initLocatorWithDelegate:(id)newDelegateObject
{
	if ((self = [super init]))
	{		 		 
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		[self setDelegateObject:newDelegateObject];
		//[self setMapController:[MapController sharedInstance]];
		counter = 0;
		isUpdating = NO;
		lastUpdateLocation = nil;
	}	
		
	return self;
}



//stop update position
- (void) stopUpdates
{
	isUpdating = NO;
    [locationManager stopUpdatingLocation];	
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startUpdates) object:nil];
} 


//find out if it is possible to use position update - for example user denied location services for our application
- (BOOL) canStartLocationUpdate
{
	//is location service enabled by user //only in version 4 and above 
	int verNum = [Common getVersionMainNumber];
	if (verNum >= 4)
		if (!locationManager.locationServicesEnabled)
			return NO;    
    
	
	return YES;
}


//start update position
- (void) startUpdates
{
	if (![self canStartLocationUpdate])
		return;
	
	counter = 0; 
    
	//set location service precission
	//locationManager.distanceFilter = 1000;  // 1 kilometer
	//locationManager.distanceFilter = kCLDistanceFilterNone;
	//locationManager.distanceFilter = 5; //5 meters
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; //-1 meters
	
	isUpdating = YES;
	
    [locationManager startUpdatingLocation];
}


//switch between stasrt and update position
- (void) startStopUpdates
{
	if (isUpdating)
	{
		[self stopUpdates];
	}
	else
	{
		[self startUpdates];
	}
}


//http://www.iphonedevsdk.com/forum/iphone-sdk-development/3271-cllocationmanager-not-updated-frequently.htmlhttp://www.iphonedevsdk.com/forum/iphone-sdk-development/3271-cllocationmanager-not-updated-frequently.html
// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	
#ifdef DEBUG	
	NSLog(@"Locator.m: Latitude = %f\n Longitude = %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
	NSLog(@"Locator.m: counter = %d", counter);
#endif
	
	//http://codesofa.com/blog/archive/2008/07/25/a-short-note-on-cllocation-cllocationmanager.html
	NSDate* eventDate = [newLocation timestamp];
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];

	//use location only if it is new
	if (isUpdating &&
		abs(howRecent) < 5.0 )
	{		
        //[[[[MapController sharedInstance] imageScrollView] positionView] show];
        //[[[[mapController wmMapView] imageScrollView] positionView] show];
        [[mapController wmMapView] showPositionView];
		
		if (lastUpdateLocation == nil)
			lastUpdateLocation = [newLocation copy];
		else
		{
			[lastUpdateLocation release];
			lastUpdateLocation = [newLocation copy];
		}
	
		if (counter < 0)
			counter = 0;
		else
			counter++; 
	
		//accuracy in degreee = horizontalAccuracy is in meters:
		float accuracyInDegree = 0.00001 * newLocation.horizontalAccuracy;		
		float displayedAreaAccuracyInMeter = newLocation.horizontalAccuracy * 2.5;
				
		/*
		double minimalAccuracy = 0.0005;
		if (displayedAreaAccuracyInDegree < minimalAccuracy)
			displayedAreaAccuracyInDegree = minimalAccuracy;
		*/
		
		LatLon latLon = LatLonMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		
		//[mapController goToLonLat:latLon animated:YES];
        [[mapController wmMapView] goToLonLat:latLon animated:YES];
		
		if (firstLocalization)
		{
			//[mapController zoomToDistanceDelta:CGSizeMake(displayedAreaAccuracyInMeter,displayedAreaAccuracyInMeter)  animated:NO];
            [[mapController wmMapView] zoomToDistanceDelta:CGSizeMake(displayedAreaAccuracyInMeter,displayedAreaAccuracyInMeter)  animated:NO];
			firstLocalization = NO;			
		}
		
#ifdef POSITION_VIEW		
		//[[TiledScrollView sharedInstance] setShowPositionView];
        //[[mapController imageScrollView] setShowPositionView];
        //[[[mapController wmMapView] imageScrollView] setShowPositionView];
        [[mapController wmMapView] showPositionView];
		//[mapController setPositionPointer:latLon withDiameterInDegree:accuracyInDegree];
        [[mapController wmMapView] setPositionPointer:latLon withDiameterInDegree:accuracyInDegree];
#endif						
		
		[mapController storeActualHistoryMovement];
	}
}



//call on error of location service
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Locator.m: Error Core Location - location update");
}


- (void) dealloc
{
	[locationManager stopUpdatingLocation];
	[locationManager release];
	if(lastUpdateLocation != nil)
		[lastUpdateLocation release];
	
	[super dealloc];
}

@end
