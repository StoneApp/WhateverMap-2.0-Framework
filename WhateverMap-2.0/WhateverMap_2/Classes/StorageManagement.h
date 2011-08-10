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
#import <CoreData/CoreData.h>


#define BATCH_SAVE_LIMIT 50

@interface StorageManagement : NSObject<NSFetchedResultsControllerDelegate> {

	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSInteger saveActionCounter;	
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (StorageManagement *)sharedInstance;

- (BOOL) saveAction; 
- (void) save;
	
//- (BOOL) addPosition:(CGPoint)offset atZoomScale:(float)zoomScale forMapID:(NSInteger)mapID;
- (BOOL) addPosition:(CGPoint)offset atZoomScale:(float)zoomScale forMapID:(NSInteger)mapID  actualIndex:(NSInteger)historyIndex;
- (BOOL) getPosition:(CGPoint*)offset atZoomScale:(float*)zoomScale forMapID:(NSInteger)mapID atIndex:(NSInteger)index;
- (NSInteger) getCountOfPositionforMapID:(NSInteger)mapID;

- (BOOL) keepOnlyRelevantHistory;

@end