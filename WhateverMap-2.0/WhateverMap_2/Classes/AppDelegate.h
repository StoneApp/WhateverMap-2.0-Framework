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

#import <CoreData/CoreData.h>
#import "constants.h"

@class MapController;
@class Reachability;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
	//CoreData
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	MapController* mapController;
	
    UIWindow *window;
    MapController *viewController;
	UINavigationController *navigationController;
	
	BOOL firstLocalization;
	
	UIImageView *splashView;
    
}

//CoreData
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) MapController* mapController;
- (NSString *)applicationDocumentsDirectory;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (assign) BOOL firstLocalization;

+ (AppDelegate *)sharedInstance;
- (void) saveData;


@end

