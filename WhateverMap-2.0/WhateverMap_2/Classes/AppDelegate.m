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


#import "AppDelegate.h"
#import "MapController.h"
#import "ConnectionReachability.h"
//#import "MyHTTPServer.h"
#import "constants.h"
#import "SourceData.h"
#import "ParserJSON.h"
#import "Locator.h"
#import "storageManagement.h"
#import "SourceNode.h"
#import "Common.h"
#import "FavouriteTableViewController.h"
#import "WMMapView.h"



@interface AppDelegate ()

- (void) initApp:(NSString*)textUrl;
- (void) refreshApp:(NSString*)textUrl;

@end


@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;
@synthesize firstLocalization;
@synthesize mapController;

//CoreData
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;


+ (AppDelegate *)sharedInstance
{
	static AppDelegate *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[AppDelegate alloc] init];
		}
	}
	
	return instance;
}


-(id)init
{
	self = [super init];
    if (self)
    {
	}
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
	[StorageManagement sharedInstance].managedObjectContext = self.managedObjectContext;
	
	//set black transluent status bar
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque]; //UIStatusBarStyleBlackTranslucent
	[[UIApplication sharedApplication] setStatusBarHidden:NO];

	//start HTTP server
	//[[MyHTTPServer sharedInstance] startServer];
	
	//internet connection checking
	[[ConnectionReachability sharedInstance] startUpdate];
	
    // Override point for customization after app launch        
	[[Locator sharedInstance] setFirstLocalization:YES];
	
	//initialize app
    [NSThread detachNewThreadSelector:@selector(initApp:) toTarget:self withObject:DEFAULT_UPDATE_DEFINITION_URL];
	//[self initApp:DEFAULT_UPDATE_DEFINITION_URL];	
	
	if([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."]) 
	{		
		NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		if (url)
			[self application:application handleOpenURL:url];
		return NO;
    }
		
	return YES;	
}

- (UIView*) createSplashScreen
{
	if (!splashView)
	{					
		splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        UIImage *splash = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Default.png"]];
        [splashView setImage:splash];
        [splash release];
	}
	
	return splashView;
}





- (void) initApp:(NSString*)textUrl
{
    
	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
		
	NSLog(@"init app");
    
	ParserJSON* parser = [[ParserJSON alloc] init];
	[parser loadAndSetRootNode:textUrl update:NO overWrite:NO];
	[parser release];
	

    
	//if number of definition is 1 - do not show table for select
    SourceNode *sourceNode = [[[SourceData sharedInstance] sourceNode] retain];
	if ([sourceNode getNumberOfItems] == 1)
	{
		//mapController = [[MapController sharedInstance] retain];
        mapController = [[MapController alloc] init];         
		[navigationController pushViewController:mapController animated:NO];	
        
	}
	else
	{
		FavouriteTableViewController *favouriteTableView = [[FavouriteTableViewController alloc] init];
		[favouriteTableView setSourceNode:sourceNode];	
		[navigationController pushViewController:favouriteTableView animated:NO];
		[favouriteTableView release];
	}	
    
    [sourceNode release];
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    
	[splashView release];
	splashView = nil;
	
	[pool drain];
}


- (void) refreshApp:(NSString*)textUrl
{
    [[mapController wmMapView] reloadMap];
/*    
	NSLog(@"refresh app");
	
	ParserJSON* parser = [[ParserJSON alloc] init];
	[parser loadAndSetRootNode:textUrl update:NO overWrite:NO];
	[parser release];
	

	[navigationController popViewControllerAnimated:NO];
	
	[mapController release];
	mapController = nil;
	//mapController = [[MapController refreshSharedInstance] retain];		
    mapController = [[MapController alloc] init];		
	
    SourceNode *sourceNode = [[[SourceData sharedInstance] sourceNode] retain];
	if ([sourceNode getNumberOfItems] == 1)
	{
		[navigationController pushViewController:mapController animated:NO];		
	}
	else
	{
		FavouriteTableViewController *favouriteTableView = [[FavouriteTableViewController alloc] init];
		[favouriteTableView setSourceNode:sourceNode];	
		[navigationController pushViewController:favouriteTableView animated:NO];
		[favouriteTableView release];
	}	
    
    [sourceNode release];
*/	

	NSLog(@"definition checked");
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[self saveData];
    [[mapController wmMapView] removeAllTiles];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */	
	//[self refreshApp];
	[self refreshApp:DEFAULT_UPDATE_DEFINITION_URL];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	[self saveData];
}


- (void) saveData
{	
	ParserJSON* parser = [[ParserJSON alloc] init];
	[parser saveRootNode:[[SourceData sharedInstance] sourceNode]];
	[parser release];
		
    StorageManagement *storageManagement = [[StorageManagement sharedInstance] retain];
	[storageManagement saveAction];
	[storageManagement keepOnlyRelevantHistory]; 
    [storageManagement release];
}


//calling by scheme like ikatastr:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
		NSLog(@"handle url");
	[navigationController popViewControllerAnimated:NO];

	//if ([[url scheme] isEqualToString:@"ikatastr"] || [[url scheme] isEqualToString:@"ikatastrhd"])
	{
		NSString *txt = [url absoluteString];
		if (txt)
		{
			txt = [txt lowercaseString];
			txt = [txt stringByReplacingOccurrencesOfString:@"ikatastr:" withString:@""];
			txt = [txt stringByReplacingOccurrencesOfString:@"http://" withString:@""];
			txt = [txt stringByReplacingOccurrencesOfString:@"http:" withString:@""];
			txt = [@"http://" stringByAppendingString:txt];
		}

		[self refreshApp:txt];
	}
	
	NSLog(@"DEF UPDATE");
	
	
	
    return YES;	
}








///////////////////////////////////////////
//CoreData
//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [PATH_RESOURCE stringByAppendingPathComponent: @"map.sqlite"]];
	
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel:[self managedObjectModel]];
	if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												 configuration:nil URL:storeUrl options:nil error:&error]) {
		//Error for store creation should be handled in here
		NSLog(@"Error for store creation should be handled in here");
	}
	
	return persistentStoreCoordinator;
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//CoreData
///////////////////////////////////////////



- (void)dealloc 
{
	//CoreData	
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	if (splashView)
		[splashView release];
	
	if (mapController)
		[mapController release];
	
    [viewController release];
    [window release];
    [super dealloc];
	
}


@end
