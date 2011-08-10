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


//#import "TiledScrollView.h"
//#import "TapDetectingView.h"
#import <CoreLocation/CoreLocation.h>
#import "typeDefinitions.h"
#import "MapControllerProtocol.h"
 
//the main class for handling with map - it can zoom navigate over the map
//include some handler like GPS button and so on
@class InfoViewController;
@class WMMapView;
@class ShakeView;

@interface MapController : UIViewController <CLLocationManagerDelegate, MapControllerProtocol, UIWebViewDelegate> 
{
    WMMapView *wmMapView;
    
    ShakeView *shakeView;
    
    NSString        *currentImageName;
	CLLocationManager *locationManager;
	double lastAngle;
	BOOL isInfo;
	
	InfoViewController *infoViewController;	
	UINavigationItem *navItem;
	
	UIButton *toolBar_infoButton;
	UIBarButtonItem *toolBar_gpsButton;
	UIBarButtonItem *toolBar_compassButton;
	UIBarButtonItem *toolBar_informationButton;
	UIBarButtonItem *toolBar_prevHistoryButton;
	UIBarButtonItem *toolBar_nextHistoryButton;
	
	NSArray* toolBarButtons;
	
	UISearchBar *searchBar;
	
	BOOL headingStarted;
	BOOL hiddenTools;
	BOOL searchBarAdded;
		
	UIView* activityView;	
	NSInteger historyIndex;
}

//@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (assign) double lastAngle;
@property (nonatomic, retain) WMMapView *wmMapView;

- (void) didUserInteract;

- (BOOL) isPrevHistoryMovement;
- (BOOL) isNextHistoryMovement;

- (void) firstSetting;

- (void) makeShakeViewFirstResponder;

- (void) changeOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

- (void) goToLanLot:(LatLon)latLon atZoom:(float)zoom;

- (void) turnGPSButtonOff;

@end






