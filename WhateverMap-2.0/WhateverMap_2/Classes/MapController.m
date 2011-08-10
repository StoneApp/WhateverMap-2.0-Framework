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


#import "MapController.h"
#import "TapDetectingView.h"
#import "constants.h"
#import "TileView.h"
#import "MapSource.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#import "SourceData.h"
#import "CoordConverter.h"
#import "Locator.h"
#import "PositionView.h"
#import "Projection.h"
#import "InfoGetter.h"
#import "QueryFactory.h"
#import "SearchBarDelegate.h"
#import "StorageManagement.h"
#import "DetailedTableViewController.h"
#import "MapUI.h"
#import "SourceNode.h"
#import "MapSourceDefinition.h"
#import "typeDefinitions.h"
#import "TileDispatcher.h"
#import "WMMapView.h"
#import "ShakeView.h"
#import "WMDataSource.h"

#import "Common.h"

//private methods for MapController

//BUTTON CONTROLL
@interface MapController (ControlButton)
- (void) eventCompass: (id) target;
- (void) eventInformation: (id) target;
- (void) eventGPS: (id) target;
- (void) turnInformationButtonOn;
- (void) turnInformationButtonOff;
- (void) turnGPSButtonOn;
- (void) turnGPSButtonOff;
- (void) turnCompassButtonOn;
- (void) turnCompassButtonOff;
//history
- (void) checkHistoryButtonState;
- (void) prevHistoryMovement;
- (void) nextHistoryMovement;
- (BOOL) isPrevHistoryMovement;
- (BOOL) isNextHistoryMovement;
- (void) revealHistoryMovement:(NSInteger)index;
- (void) storeActualHistoryMovement;
@end


//COMPASS
@interface MapController (CompassFunctionality)
- (void) turnCompassOn;
- (void) turnCompassOff;
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading;
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@end

@interface MapController (ViewHandlingMethods)
- (void)pickImageNamed:(NSString *)name;
- (NSArray *)imageData;
@end


@interface MapController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end


//USER INTERFACE CONTROL - BUTTONS, ...
@interface MapController (UserInterface)
- (void) addButtonsToToolBar;
- (void) addButtonToNavigationbar;
- (void) addSearchBar;
- (void) removeSearchBar;
- (void) hideTools;
- (void) showTools;
- (void) changeToCurrentOrientation;
@end


@interface MapController (other)

//HELP FUNCTION
static double degreeDistance(LatLon p1, LatLon p2);
static double getPathLengthInMeters(LatLon p1, LatLon p2);
static double getDifferenceLengthInMetersFromDegrees(CGSize degrees);
static double getDifferenceLengthInDegreesFromMeters(CGSize meters);

- (void) setNewBounds:(CGSize)boundsSizeRelative;
- (void) setNonCompassBounds;
- (void) setCompassBounds;
- (void) composeMail;

- (void) showPreviousSource;
- (void) showNextSource;
- (void) showInfo;

- (TileView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex ReturnEmpty:(BOOL)empty;

@end












/////////////////
//IMPLEMENTATION
@implementation MapController

@synthesize navItem;
@synthesize lastAngle;
@synthesize wmMapView;
 

-(id)init
{
	self = [super init];
    if (self)
    {
		searchBarAdded = false; 
		historyIndex = -1;		
        [[Locator sharedInstance] setMapController:self];        
	}
    return self;
}


- (void)viewDidLoad 
{	
    [wmMapView showMap];
    
	// Add the following line if you want the list to be editabl
	[self firstSetting];
    
    
    shakeView = [[ShakeView alloc] initWithFrame:CGRectZero];		
    [shakeView becomeFirstResponder];
    [shakeView setDelegate:self];
    [wmMapView addSubview:shakeView];
    [shakeView release];
    
    [wmMapView reloadMap];
}


- (void) firstSetting
{
	//set title of navigation bar
	self.title = [[[[SourceData sharedInstance] sourceNode] getChild:0] title];		
	
	//load position from history movement and aply	
	if ([self isPrevHistoryMovement])
	{
		[self revealHistoryMovement:0];
	}
	else 
	{
        [wmMapView goToLonLat:HOME_AREA_LATLON AtLevel:HOME_AREA_ZOOM animated:NO];		
		[self storeActualHistoryMovement];
	}
	
	[self checkHistoryButtonState];
	[self turnInformationButtonOn];
}


- (void) addButtonToNavigationbar
{
	//add segmented control for switching layers to the navigation bar
    UIImage *image_up = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"up.png"]];
    UIImage *image_down = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"down.png"]];
    
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											 [NSArray arrayWithObjects:
											  image_up,
											  image_down,
											  nil]];
    
    [image_up release];
    [image_down release];
    
	[segmentedControl addTarget:self action:@selector(NavBarAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	segmentedControl.tintColor = [UIColor blackColor];
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	[segmentedControl release];
	
	[self.navigationItem setRightBarButtonItem:segmentBarItem];	
	[segmentBarItem release];
}


- (void) addSearchBar
{	
	searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,44,[self.view frame].size.width,34)];
    [searchBar setAutoresizesSubviews:YES];
    [searchBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth) ];
    
	SearchBarDelegate* searchBarDelegate = [[SearchBarDelegate alloc] init];
    [searchBarDelegate setMapDelegate:self];
	[searchBar setDelegate:searchBarDelegate];	
	[searchBar setBarStyle:UIBarStyleBlackTranslucent];	
	[searchBar setPlaceholder:@"Search"];
	[searchBar setAutocorrectionType:UITextAutocorrectionTypeDefault];
	[searchBar setShowsScopeBar:YES];
	[searchBar setTranslucent:YES];	
	[searchBar resignFirstResponder]; //if there was keyboard hide it
	[searchBar setShowsCancelButton:NO animated:YES];
	
	if (!searchBarAdded)
	{
		searchBarAdded = true;
		[self.view addSubview:searchBar];
	}
}


- (void) makeShakeViewFirstResponder
{
    [shakeView becomeFirstResponder];
}


- (void) removeSearchBar
{	
	searchBarAdded = false;
	[searchBar removeFromSuperview];
}


- (void) hideTools
{	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:.03];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDelegate:self];

	float alpha = 0.2;

	[searchBar setAlpha:alpha]; 
	[[[self navigationController] navigationBar] setAlpha:alpha]; 
	[[[self navigationController] toolbar] setAlpha:alpha]; 
	
	[UIView commitAnimations];	
	
	hiddenTools = true;
}

- (void) showTools
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:.03];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];	
		
	float alpha = 1.0;
	[searchBar setAlpha:alpha]; 
	[[[self navigationController] navigationBar] setAlpha:alpha]; 
	[[[self navigationController] toolbar] setAlpha:alpha]; 
	
	[UIView commitAnimations];

	hiddenTools = false;
}






#pragma mark CompassFunctionality method

//turn on compass and rotate mapControl view
-(void) turnCompassOn
{
#ifdef DEBUG		
    NSLog(@"turning compas on...");
#endif	
    
	headingStarted = true;
	
	if ([Common isHeadingAvailable])
	{
        [wmMapView enableCompassFeature];
        
        locationManager = [[CLLocationManager alloc] init];
        // setup delegate callbacks
        [locationManager setDelegate:self];    
        // heading service configuration
        locationManager.headingFilter = kCLHeadingFilterNone;
        // start the compass       
		[locationManager startUpdatingLocation]; //fix issue with compass - without location it is unable to get corrections
        [locationManager startUpdatingHeading];
    }
	else
	{
		// No compass is available. This application cannot function without a compass, 
        // so a dialog will be displayed and no magnetic data will be measured.
		UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!" message:@"This device does not have the ability to measure magnetic fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCompassAlert show];
        [noCompassAlert release];		
	} 
}


- (void) turnCompassOff
{
#ifdef DEBUG		
    NSLog(@"turning compas off...");
#endif	  	

	headingStarted = false;
   
	if ([Common isHeadingAvailable]) 
	{
		[locationManager stopUpdatingHeading];
		[locationManager stopUpdatingLocation]; //fix issue with compass - without location it is unable to get corrections

        lastAngle = 0;
        
        [wmMapView disableCompassFeature];
        
        [locationManager release];
        locationManager = nil;
        
        [wmMapView setMapRotation:0];
	}
}


// This delegate method is invoked when the location manager has heading data.
//part of compass functionality
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
#ifdef DEBUG	
	NSLog(@"MapSource.m: reduce : %f", newHeading.trueHeading);
#endif
	
	double newAngle = (newHeading.trueHeading * M_PI) / 180.0;

#define COMPASS_CHANGE_LEVEL 17

	if (headingStarted && (fabs(lastAngle - newAngle) > 0.01) )
	{				
		lastAngle = newAngle;				
        [wmMapView setMapRotation:(-lastAngle)];
	}
}


//ask about calibration of compass
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager 
{
	return YES;
}


// This delegate method is invoked when the location managed encounters an error condition.
//part of compass functionality
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } 
    else if ([error code] == kCLErrorHeadingFailure) 
    {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}


- (void)loadView 
{
	[super loadView];
	
    [[MapUI sharedInstance] createToolBarButtonsForTarget:self];	

	//Quality //TODO not implemented yet - idea to load higher resolution and use scale transform to fit it in tile
    
    CGRect frame = [[self view] bounds];
    WMMapView *tmpMapView = [[WMMapView alloc] initWithFrame:frame];
    
    
    WMDataSource *wmDataSource = [[WMDataSource alloc] init];
    SourceData *sourceData = [[SourceData sharedInstance] retain];        
    NSInteger mapCount = [sourceData getMapCount];
    for (int i = 0; i < mapCount; i++)
    {
        MapSourceDefinition *mapSource = nil;
        mapSource = [[SourceData sharedInstance] getMapSource:i];
        [wmDataSource addLayer:mapSource];
    }
    [sourceData release];
    
    
    //WMDataSource *wmDataSource = [[WMDataSource alloc] initWithDefaultDefinition];
    
    [tmpMapView setMapDelegate:self];
    [tmpMapView setWmDataSource:wmDataSource];
    [wmDataSource release];
    
    [tmpMapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tmpMapView setAutoresizesSubviews:YES];

    [[self view] addSubview:tmpMapView];
    [self setWmMapView:tmpMapView];
    [tmpMapView release];
	
	//inset is set because of small map - it is not under navigation bar
	//[imageScrollView setContentInset:INSET_EDGE];
	
	isInfo = FALSE;
}


#pragma mark UI toolbar buttons method 

- (void)NavBarAction:(id)sender
{    
	switch ([sender selectedSegmentIndex]) 
	{        
		case 0: //arrow up
			[[SourceData sharedInstance] nextNode];			
			[wmMapView showMap];
			break;
		case 1: //arrow down
			[[SourceData sharedInstance] previousNode];
			[wmMapView showMap];
			break;
	}
}


- (void) showPreviousSource 
{
	//mapNumber -= 1;
	//TODO
	//[[TileView sharedInstance] setTileDirectory:[DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", mapNumber]]];
	[wmMapView showMap];	
}


- (void) showNextSource
{
	//mapNumber += 1;
	//TODO
	//[[TileView sharedInstance] setTileDirectory:[DOCUMENT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", mapNumber]]];
	[wmMapView showMap];
}


- (void) addButtonsToToolBar
{
	[[self.navigationController toolbar] setItems:[[MapUI sharedInstance] createToolBarButtonsForTarget:self] animated:YES];
}


//show info view
- (void) showInfo
{
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
	[self makeShakeViewFirstResponder];
	
	//add animation of flip window
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:.03];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.view window] cache:YES];

	if (infoViewController == nil)
		infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
		
	if ([Common isiPadDevice])
	
		[self.navigationController pushViewController:infoViewController animated:NO];
	else
	
		[[self.view window] addSubview:infoViewController.view];	
		
	[UIView commitAnimations];
}


- (void) eventInformation: (id) target
{
	if (!hiddenTools) 
	{
		[self hideTools];
	}
	else
	{
		[self showTools];
	}
}


- (void) turnInformationButtonOff
{
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_show_hide.png"]];

	[[[MapUI sharedInstance] toolBar_informationButton] setImage:selectedImage];	
    
    [selectedImage release];
}


- (void) turnInformationButtonOn
{ 
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_show_hide.png"]];

	[[[MapUI sharedInstance] toolBar_informationButton] setImage:selectedImage];
	
    [selectedImage release];
}


- (void) checkHistoryButtonState
{
    MapUI *factoryUI = [[MapUI sharedInstance] retain];
	if ([self isPrevHistoryMovement])
		[[factoryUI toolBar_prevHistoryButton] setEnabled:YES];
	else
		[[factoryUI toolBar_prevHistoryButton] setEnabled:NO];

	if ([self isNextHistoryMovement])
		[[factoryUI toolBar_nextHistoryButton] setEnabled:YES];
	else
		[[factoryUI toolBar_nextHistoryButton] setEnabled:NO];
    
    [factoryUI release];
}


- (void) setHistoryMovementSavedButtonState
{
    MapUI *factoryUI = [[MapUI sharedInstance] retain];
	[[factoryUI toolBar_nextHistoryButton] setEnabled:NO];
	[[factoryUI toolBar_prevHistoryButton] setEnabled:YES];
    [factoryUI release];
}


- (void) prevHistoryMovement
{
	[NSThread detachNewThreadSelector:@selector(prevHistoryMovementThreadMethod) toTarget:self withObject:nil];
}


- (void) prevHistoryMovementThreadMethod
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	

	if ([self isPrevHistoryMovement])
	{
		historyIndex++;
		[self revealHistoryMovement:historyIndex];
	}
	[self didUserInteract];
	
	[pool drain];
}


- (void) nextHistoryMovement
{
	[NSThread detachNewThreadSelector:@selector(nextHistoryMovementThreadMethod) toTarget:self withObject:nil];
}


- (void) nextHistoryMovementThreadMethod
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	

	if ([self isNextHistoryMovement])
	{
		historyIndex--;
		[self revealHistoryMovement:historyIndex];
	}
	[self didUserInteract];
	
	[pool drain];
}


- (BOOL) isPrevHistoryMovement
{	
	NSInteger count = [[StorageManagement sharedInstance] getCountOfPositionforMapID:[[SourceData sharedInstance] nodeIndex]];
	
	if (count <= 0)
		return false;
	
	if (historyIndex+1 < count)
		return true;
	
	return false;
}


- (BOOL) isNextHistoryMovement
{
	if (historyIndex-1 >= 0)
		return true;
	
	return false;
}


- (void) revealHistoryMovement:(NSInteger)index
{
#ifdef	DEBUG
	NSLog(@"revealHistoryMovement-2");
#endif
	
	CGPoint pixel;
	float zoomScale;
	
	[[StorageManagement sharedInstance] getPosition:&pixel atZoomScale:&zoomScale forMapID:[[SourceData sharedInstance] nodeIndex] atIndex:index];
		
	[self checkHistoryButtonState];
		
	if (zoomScale >= 0 && pixel.x >= 0 & pixel.y >= 0)
	{
		double zoomLevel = (zoomScale+1.0);
		
		//no thread version - safer
		//[self zoomToLevel:zoomLevel animated:NO];
		//[self goToPixel:pixel animated:NO];
		
		//thread - more user friendly
		NSArray *paramArray = [NSArray arrayWithObjects:
			[NSNumber numberWithDouble:zoomLevel],
			[NSValue valueWithCGPoint:pixel],
			nil];
		[self performSelectorOnMainThread:@selector(performHistoryMovement:) withObject:paramArray waitUntilDone:NO];
	}
}


- (void) performHistoryMovement:(NSArray*)paramArray
{
    [wmMapView goToPixel:[[paramArray objectAtIndex:1] CGPointValue] AtLevel:[[paramArray objectAtIndex:0] doubleValue] animated:NO];
}


- (void) storeActualHistoryMovement
{
	CGPoint pixel = [wmMapView getPixel];
	float zoomScale = [wmMapView getZoomLevel];
	[[StorageManagement sharedInstance] addPosition:pixel atZoomScale:zoomScale forMapID:[[SourceData sharedInstance] nodeIndex] actualIndex:historyIndex];
	
	//because of override next history movements it is the first one
	historyIndex = 0;
	[self setHistoryMovementSavedButtonState];
}


- (void) eventGPS: (id) target
{
	if ([[Locator sharedInstance] isUpdating])
		[self turnGPSButtonOff];
	else
		[self turnGPSButtonOn];
}


- (void) turnGPSButtonOn
{
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_gps_on.png"]];
	[[[MapUI sharedInstance] toolBar_gpsButton] setImage:selectedImage];
    [selectedImage release];
    
	[[Locator sharedInstance] startUpdates];	
}


- (void) turnGPSButtonOff
{
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_gps_off.png"]];
	[[[MapUI sharedInstance] toolBar_gpsButton] setImage:selectedImage];
    [selectedImage release];
    
	[[Locator sharedInstance] stopUpdates];
}



- (void) eventCompass: (id) target
{
#ifdef COMPASS_TURN_ON_WITH_GPS			
	if (headingStarted)
		[self turnCompassButtonOff];
	else
		[self turnCompassButtonOn];
#endif	
}


- (void) turnCompassButtonOn
{
	[self turnCompassOn];
	headingStarted = TRUE;
    
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_compass_on.png"]];
	[[[MapUI sharedInstance] toolBar_compassButton] setImage:selectedImage];
    [selectedImage release];
}


- (void) turnCompassButtonOff
{
	[self turnCompassOff];
	headingStarted = FALSE;
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_compass_off.png"]];
	[[[MapUI sharedInstance] toolBar_compassButton] setImage:selectedImage];
    [selectedImage release];
}



///////////////
//SYSTEM CALL
- (void)viewWillDisappear:(BOOL)animated
{
    [self turnCompassOff];
	//remove each button from toolbar
	
	//default setup
#ifdef TURN_OFF_FUNCTION_ON_LEAVE_MAP	
	if (informationEnabled)
		[self turnInformationButtonOff];	
	if (headingStarted)
		[self turnCompassButtonOff];
#endif	

	if ([[Locator sharedInstance] isUpdating])
		[self turnGPSButtonOff];
	
	if (hiddenTools) 
		[self showTools]; 

	[self removeSearchBar];
	
	 for(UIView *subview in [[self.navigationController toolbar] subviews]) 
	 {
		 [subview removeFromSuperview];
	 }
}


- (void)viewWillAppear:(BOOL)animated
{
    SourceData *sourceData = [[SourceData sharedInstance] retain];
    
	if ([sourceData isSingleMap])
		[self addButtonToNavigationbar];

/*
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(showSettings)];	
	UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] init];
	//settingsBarButton.style = UIBarButtonItemStyleBordered;
	settingsBarButton.style = UIBarButtonItemStylePlain;
	[settingsBarButton setImage:[UIImage imageNamed:@"icon_settings.png"]];
	[settingsBarButton setWidth:44];	
	[settingsBarButton setTarget:self];
	[settingsBarButton setAction:@selector(showSettings)];
	[self.navigationItem setRightBarButtonItem:settingsBarButton];
	[settingsBarButton release];
*/	 
	
	if ([[sourceData sourceNode] getNumberOfItems] == 1)
	{
        UIImage *infoBg = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_about.png"]];
		UIButton *buttonInfo=[[UIButton alloc] init];
		buttonInfo.frame=CGRectMake(0, 0, infoBg.size.width, infoBg.size.height);
		[buttonInfo setBackgroundImage:infoBg forState:UIControlStateNormal];
		[buttonInfo addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonInfo];
        [infoBg release];
		[buttonInfo release];
	}
	
    UIImage *settingsBg = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_settings.png"]];
	UIButton *buttonSettings=[[UIButton alloc] init];
	buttonSettings.frame=CGRectMake(0, 0, settingsBg.size.width, settingsBg.size.height);
	[buttonSettings setBackgroundImage:settingsBg forState:UIControlStateNormal];
	[buttonSettings addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonSettings];
    [settingsBg release];
	[buttonSettings release];
		
	/*
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											 [NSArray arrayWithObjects:
											  [UIImage imageNamed:@"icon_about.png"],
											  [UIImage imageNamed:@"icon_mail.png"],
											  nil]];
	[segmentedControl addTarget:self action:@selector(RightNavBarAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	segmentedControl.tintColor = [UIColor blackColor];
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];	
	[segmentedControl release];
	[self.navigationItem setLeftBarButtonItem:segmentBarItem];	
	[segmentBarItem release];
	*/ 
    
    [sourceData release];
    
    [wmMapView reloadMap];
}


- (void)RightNavBarAction:(id)sender
{    
	switch ([sender selectedSegmentIndex]) 
	{        
		case 0: //left
			[self showInfo];
			break;
		case 1: //right
			[self composeMail];
			break;
	}
}


- (void) showSettings
{	
	DetailTableViewController* detailTableViewController = [[DetailTableViewController alloc] init];
    
    SourceData *sourceData = [[SourceData sharedInstance] retain];
	int selectedSource = [sourceData nodeIndex];
	[detailTableViewController setSourceNode:[[sourceData sourceNode] getChild:selectedSource]];
    [sourceData release];
	
	[self.navigationController pushViewController:detailTableViewController animated:YES];
	[detailTableViewController release];
}


- (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(
											kCFAllocatorDefault, 
											(CFStringRef)str,
											NULL, 
											CFSTR(":/?#[]@!$&’()*+,;="), 
											kCFStringEncodingUTF8);
	return [result autorelease];
}

- (void) composeMail
{
	//SUBJECT
	NSString* subject = @"iKatastr informace";
	subject = [self urlEncodeValue:subject];
	
	//CONTENT OF MAIL
	LatLon latlon = [wmMapView getLonLat];
	NSInteger zoom = [wmMapView getZoomLevel] + 2;
	NSString* body = [NSString stringWithFormat:@"http://www.ikatastr.cz/ikatastr.htm#zoom=%d&lat=%f&lon=%f&layers=000FFFF0BTTTT", zoom, latlon.lon, latlon.lat];
	
	body = [self urlEncodeValue:body];
	
	//COMPOSE WHOLE MAIL
	NSString* textURL = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject, body];	
		
	//CALL MAIL CLIENT
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:textURL]];
}


- (void) goToLanLot:(LatLon)latLon atZoom:(float)zoom
{
    [wmMapView goToLonLat:latLon AtLevel:zoom animated:YES];
}


//if user interact did something - e.g. stop update location
- (void) didUserInteract
{
	//if GPS is on -> turn it Off
	[self turnGPSButtonOff];
	
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
	[self makeShakeViewFirstResponder];
}

- (void) didZoomEnded
{
    [self storeActualHistoryMovement];
}

- (void) willBeginDragging;
{
    [self storeActualHistoryMovement];
}

- (void) didEndDragging;
{
    [self storeActualHistoryMovement];
}



- (void)viewDidAppear:(BOOL)animated
{
	[self addButtonsToToolBar];
	[self addSearchBar];
    [wmMapView reloadMap];
}


- (void) changeOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Common startNetworkActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Common stopNetworkActivityIndicator];
}


- (void)didReceiveMemoryWarning 
{

    NSLog(@"received memory warning");
    [[TileDispatcher sharedInstance] pauseTasks];
    [wmMapView removeTilesFromNonActualZoomLevel];
    [[TileDispatcher sharedInstance] unpauseTasks];
    
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return [Common isiPadDevice];
}


- (void)dealloc 
{	
	if (toolBar_infoButton)
		[toolBar_infoButton release];
	if (toolBar_gpsButton)
		[toolBar_gpsButton release];
	if (toolBar_compassButton)
		[toolBar_compassButton release];
	if (toolBar_prevHistoryButton)
		[toolBar_compassButton release];
	if (toolBar_nextHistoryButton)
		[toolBar_compassButton release];
	
	if (toolBarButtons)
		[toolBarButtons release];
    
    [shakeView release];

	[infoViewController release];
    
    [locationManager release];
    [super dealloc];
}


@end
