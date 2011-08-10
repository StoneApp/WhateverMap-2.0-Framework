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

#import "StorageManagement.h"
#import "MovementHistory.h"

@implementation StorageManagement

@synthesize fetchedResultsController;
@synthesize managedObjectContext;



+ (StorageManagement *)sharedInstance
{
	static StorageManagement *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[StorageManagement alloc] init];
		}
	}
	
	return instance;
}


-(id)init
{
    if ((self = [super init]))
    {
		//self.managedObjectContext = self.managedObjectContext;
	}
    return self;
}


//save method - save only in casse that there is more items to save
- (void) save;
{
	saveActionCounter++;
	
	if (saveActionCounter > BATCH_SAVE_LIMIT)
		[self saveAction];
}


//perform save action
- (BOOL) saveAction 
{	
	if (saveActionCounter <= 0)
		return TRUE;
	
	
	NSError *error = nil;
	
	@try {
		if (![self.managedObjectContext save:&error]) 
		{
#ifdef DEBUG
			NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
#endif		
			return false;
		}
	}
	@catch (NSException * e) {
		return false;
		NSLog(@"Unresolved Core Data Save error - NSException: %@",e );
	}
	
	saveActionCounter = 0;
	
	return true;
} 



/////////////////////////////////////////////////////
//MOVEMENT HISTORY

//add position in map to database - store id of map, zoomScale anf offset in pixel
- (BOOL) addPosition:(CGPoint)offset atZoomScale:(float)zoomScale forMapID:(NSInteger)mapID  actualIndex:(NSInteger)historyIndex
{	
	//DELETE anything before actual position
	if (historyIndex > 0)
	{
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovementHistory" inManagedObjectContext:self.managedObjectContext];
		[fetchRequest setEntity:entity];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		[sort release];
				
		NSError *error = nil;
		NSArray *items = [self.managedObjectContext
						  executeFetchRequest:fetchRequest error:&error];
		
		[fetchRequest release]; 
		
		
		int numberOfDeletion;
		if (historyIndex > [items count])
			numberOfDeletion = [items count];
		else
			numberOfDeletion = historyIndex;

			
		for (int i = 0; i < numberOfDeletion; i++) 
		{
			[self.managedObjectContext deleteObject:[items objectAtIndex:i]];
		}
		[self save];
	}
	
	//add new entry
	MovementHistory *newManagedObject = [NSEntityDescription
						   insertNewObjectForEntityForName:@"MovementHistory"
						   inManagedObjectContext:self.managedObjectContext];

	
	[newManagedObject setOffsetX:[NSNumber numberWithInt:offset.x]];
	[newManagedObject setOffsetY:[NSNumber numberWithInt:offset.y]];
	[newManagedObject setTimeStamp:[NSDate date]];
	[newManagedObject setZoomLevel:[NSNumber numberWithFloat:zoomScale]];
	[newManagedObject setMapID:[NSNumber numberWithInt:mapID]];
	
	[self save];
	
	return YES; 
}


//get stored position for specified map id
- (BOOL) getPosition:(CGPoint*)offset atZoomScale:(float*)zoomScale forMapID:(NSInteger)mapID atIndex:(NSInteger)index
{
	[self saveAction];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovementHistory" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [sort release];
		
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mapID=%d",mapID];
	[fetchRequest setPredicate:predicate];

	NSError *error = nil;
	NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release]; 
	
	
	if (items != nil && index >= 0 && [items count] > index)
	{
		(*offset).x = [[[items objectAtIndex:index] offsetX] intValue];
		(*offset).y = [[[items objectAtIndex:index] offsetY] intValue];
		(*zoomScale) = [[[items objectAtIndex:index] zoomLevel] floatValue];		

		return true;
	}
	
	return false;
}


//return how many records is in database for specified map
- (NSInteger) getCountOfPositionforMapID:(NSInteger)mapID
{
	[self saveAction];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovementHistory" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mapID=%d",mapID];
	[fetchRequest setPredicate:predicate];
	
	
	
	NSError *error = nil;
	
	NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
	return count;
}



//save only 100 records of history and delete the oldest ones
#define NUMBER_OF_RELEVANT_HISTORY_MOVEMENTS 100
- (BOOL) keepOnlyRelevantHistory
{
	[self saveAction];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MovementHistory" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity]; 
		
	[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"mapID"]]; 
		
	[fetchRequest setResultType:NSDictionaryResultType];
	[fetchRequest setReturnsDistinctResults:YES]; 
		
	NSSortDescriptor *entrantDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mapID" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:entrantDescriptor]];
	[entrantDescriptor release];
		
	// Execute the fetch 
	NSError *error = nil;
	NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];	
	[fetchRequest release];

	if (items != nil) 
	{ 
		for (id item in items) 
		{	
			NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
			
			NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"MovementHistory" inManagedObjectContext:self.managedObjectContext];
			[fetchRequest2 setEntity:entity2];
			
			NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
			[fetchRequest2 setSortDescriptors:[NSArray arrayWithObject:sort2]];
			[sort2 release];
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"mapID=%d", [[item valueForKey:@"mapID"] intValue]];
			[fetchRequest2 setPredicate:predicate2];

			NSError *error2 = nil;
			NSArray *items2 = [self.managedObjectContext executeFetchRequest:fetchRequest2 error:&error2];
			[fetchRequest2 release];
			
			if (items2 != nil && [items2 count] > NUMBER_OF_RELEVANT_HISTORY_MOVEMENTS)
			{
				for (int i = NUMBER_OF_RELEVANT_HISTORY_MOVEMENTS; i < [items2 count]; i++) 
				{
					[self.managedObjectContext deleteObject:[items2 objectAtIndex:i]];
				}
				[self saveAction];
			}
		}
	}
	
	return true;
}

//MOVEMENT HISTORY
/////////////////////////////////////////////////////




@end
