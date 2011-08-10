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

#import "SourceData.h"
#import "SourceNode.h"
#import "MapSourceDefinition.h"

@implementation SourceData

@synthesize mapSources, sourceNode, nodeIndex;


+ (SourceData *)sharedInstance
{
	static SourceData *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[SourceData alloc] init];
		}
	}
	
	return instance;
}


- (id)init 
{
    self = [super init];
    if (self) 
	{
		mapSources = [[NSMutableArray alloc] init];
		selectedMapSourceIndex = 0;
    }
    return self;
}


- (void) addMapSource:(MapSourceDefinition*)mapSource
{
	[mapSources addObject:mapSource];
}


- (void) removeMapSource:(NSInteger)mapSourceIndex
{
	[mapSources removeObjectAtIndex:mapSourceIndex];
}


- (void)moveMapSource:(NSInteger)indexOfSource To:(NSInteger)indexOfDestination
{
	if (indexOfSource == indexOfDestination) 
		return;
	
	MapSourceDefinition *tmpSource = [mapSources objectAtIndex:indexOfSource];
	[mapSources insertObject:tmpSource atIndex:indexOfDestination];
	[mapSources removeObjectAtIndex:indexOfSource];
}


- (MapSourceDefinition*)getMapSource:(NSInteger)mapSourceIndex
{
	MapSourceDefinition *mapSource = nil;
	mapSource = [mapSources objectAtIndex:mapSourceIndex];
	
	return mapSource;
}


- (void)clearMapSources
{
	if (mapSources)
	{
		[mapSources release];
		mapSources = nil;
	}
	
	mapSources = [[NSMutableArray alloc] init];
	selectedMapSourceIndex = 0;
}


- (MapSourceDefinition*)getSelectedMapSource
{
	return [self getMapSource:selectedMapSourceIndex];
}


- (void)selectMapSource:(NSInteger)index
{
	if (index >= 0 && index < [mapSources count])
		selectedMapSourceIndex = index;
}


- (NSInteger)getSelectedMapSourceIndex;
{
	return selectedMapSourceIndex;
}


- (void)nextMapSource
{
	if ([mapSources count]-1 > selectedMapSourceIndex)
		selectedMapSourceIndex++;
	else
		selectedMapSourceIndex = 0;
}


- (void)previousMapSource
{
	if (selectedMapSourceIndex > 0)
		selectedMapSourceIndex--;
	else
		selectedMapSourceIndex = [mapSources count]-1;
}


- (void)nextNode
{
	if ([sourceNode getNumberOfItems]-1 > nodeIndex)
		nodeIndex++;
	else
		nodeIndex = 0;

	if (![sourceNode isMap])
	{
		if (![[sourceNode getChild:nodeIndex] isMap])
			[self nextNode];
		else
			[self setNodeWithIndex:nodeIndex];		
	}
	else
		[self setNodeWithIndex:nodeIndex];		

}


- (void)previousNode
{
	if (nodeIndex > 0)
		nodeIndex--;
	else
		nodeIndex = [sourceNode getNumberOfItems]-1;
	
	if (![sourceNode isMap])
	{
		if (![[sourceNode getChild:nodeIndex] isMap])
			[self previousNode];
		else 		
			[self setNodeWithIndex:nodeIndex];		
	}
	else
		[self setNodeWithIndex:nodeIndex];		
}


-(void)setNodeWithIndex:(NSInteger)index
{
	if ([sourceNode isMap])
	{		
		[self clearMapSources];
		[self addMapSource:[sourceNode getMap:nodeIndex]];
	}
	else 
	{
		[self setMapSources:[[sourceNode getChild:nodeIndex] maps]];
	}
}


- (BOOL) isSingleMap
{
	if ([sourceNode isMap])
		return true;
	else
		return false;
}

- (NSInteger)getMapCount
{
    NSInteger count = [mapSources count];
    return count;
}

- (void)dealloc 
{
	[mapSources release];
	[super dealloc];
}

@end
