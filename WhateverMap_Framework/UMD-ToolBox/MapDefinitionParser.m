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

#import "MapDefinitionParser.h"
#import "JSON.h"
#import "typeDefinitions.h"
#import "MapSourceDefinition.h"

@implementation MapDefinitionParser



- (NSArray*) parseMapList:(NSString*)string
{
	id objectJSON = [string JSONValue];
	
	NSArray *layers = [self parseObject:objectJSON];	
		
	return layers;	
}


- (NSArray*) parseObject:(id)objectJSON
{
	NSMutableArray *layers = [[[NSMutableArray alloc] init] autorelease];
	
	//if you find just single definition try to return format as required
	if ([objectJSON isKindOfClass:[NSDictionary class]])
	{
		if ([self isMapSourceDefinition:objectJSON])
		{
			MapSourceDefinition *newNode = [self createMapSourceDefinition:objectJSON];			
			[layers addObject:newNode];		
		}
		else 
		{
			id maps = [objectJSON valueForKey:@"maps"];
			for (NSDictionary *map in maps)
			{
				MapSourceDefinition *newNode = [self createMapSourceDefinition:map];			
				[layers addObject:newNode];
			}
		}
	}	
	
	//object is an array = it means go through all object in array and process them
	else if ([objectJSON isKindOfClass:[NSArray class]])
	{	
		
		for(id object in objectJSON)
		{
			if ([object isKindOfClass:[NSDictionary class]])
			{
				NSArray* newLayers = [self parseObject:object];
				for (id newLayer in newLayers)
					[layers addObject:newLayer];		
			}
		}
	}
	
	return layers;	
}


- (BOOL) isMapSourceDefinition:(NSDictionary*)dictionary
{
	id maps = [dictionary valueForKey:@"maps"];
	
	if (maps && [maps isKindOfClass:[NSArray class]])
		return NO;
	else
		return YES;

}

- (MapSourceDefinition*) createMapSourceDefinition:(NSDictionary*)dictionary
{
	MapSourceDefinition* map = [[[MapSourceDefinition alloc] init] autorelease];
	
	/////////////////////////////////
	//source definition
	
	[map setTitle:[dictionary valueForKey:@"title"]];
	[map setTypeOfService:[dictionary valueForKey:@"typeOfService"]];
	[map setAddress:[dictionary valueForKey:@"address"]];
	//for each item in array - set ...
	[map setAddressSRS:[dictionary valueForKey:@"addressSRS"]];

	[map setVisibleFromLevel:[[dictionary valueForKey:@"visibleFromLevel"] intValue]];
	[map setVisibleToLevel:[[dictionary valueForKey:@"visibleToLevel"] intValue]];

	if( [dictionary valueForKey:@"visible"] == nil)
		[map setVisible:true];
	else
		[map setVisible:[[dictionary valueForKey:@"visible"] boolValue]];

	[map setLayers:[dictionary valueForKey:@"layers"]];
	
	[map setMinLevel:[[dictionary valueForKey:@"minLevel"] intValue]];	
	[map setMaxLevel:[[dictionary valueForKey:@"maxLevel"] intValue]];
	[map setDeltaLevel:[[dictionary valueForKey:@"deltaLevel"] intValue]];

	NSArray *tileResolution = [dictionary valueForKey:@"tileResolution"];	
	CGSize tileResolutionSize = CGSizeMake([[tileResolution objectAtIndex:0] intValue], [[tileResolution objectAtIndex:1] intValue]);
	[map setTileResolution:tileResolutionSize];
	
	[map setProjectionKey:[dictionary valueForKey:@"projectionKey"]];
	
	NSArray *boundingBox = [dictionary valueForKey:@"boundingBox"]; 
	BBox bBox = BBoxMake([[boundingBox objectAtIndex:0] doubleValue], [[boundingBox objectAtIndex:1] doubleValue], [[boundingBox objectAtIndex:2] doubleValue], [[boundingBox objectAtIndex:3] doubleValue]);
	[map setBoundingBox:bBox];

	
	NSArray *mapResolution = [dictionary valueForKey:@"mapResolution"];
	CGSize mapResolutionSize = CGSizeMake([[mapResolution objectAtIndex:0] doubleValue], [[mapResolution objectAtIndex:1] doubleValue]); 
	[map setMapResolution:mapResolutionSize];
	
	if ([[dictionary valueForKey:@"alpha"] isKindOfClass:[NSNumber class]])
		[map setAlpha:[[dictionary valueForKey:@"alpha"] floatValue]];
	
	if( [dictionary valueForKey:@"alphaLock"] != nil)
		[map setAlphaLock:[[dictionary valueForKey:@"alphaLock"] boolValue]];
	
	//////////////////////////////////
	//georeference
	
	[map setCoordToPixelX:[dictionary valueForKey:@"coordToPixelX"]];
	[map setCoordToPixelY:[dictionary valueForKey:@"coordToPixelY"]];
	[map setPixelToCoordX:[dictionary valueForKey:@"pixelToCoordX"]];
	[map setPixelToCoordY:[dictionary valueForKey:@"pixelToCoordY"]];
	
	
	
	
	
	
	//optimalization for user
	map.georeferencingType = [[dictionary valueForKey:@"georeferencingType"] intValue];
	if (map.georeferencingType == 2)
	{
		map.georeferencingType = 1;
		//construct coordinates from bounding box
		
		map.numberOfPoints = 4;
		
		NSMutableArray *tmpPixelPoints = [[NSMutableArray alloc] init];
		[tmpPixelPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
		[tmpPixelPoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.mapResolution.width, 0)]];
		[tmpPixelPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, map.mapResolution.height)]];
		[tmpPixelPoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.mapResolution.width, map.mapResolution.height)]];				
		[map setPixelPoints:tmpPixelPoints];
		[tmpPixelPoints release];

		NSMutableArray *tmpCoordinatePoints = [[NSMutableArray alloc] init];
		[tmpCoordinatePoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.minX, map.boundingBox.maxY)]];
		[tmpCoordinatePoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.maxX, map.boundingBox.maxY)]];
		[tmpCoordinatePoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.minX, map.boundingBox.minY)]];
		[tmpCoordinatePoints addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.maxX, map.boundingBox.minY)]];				
		[map setCoordinatePoints:tmpCoordinatePoints];
		[tmpCoordinatePoints release];
	}
	else 
	{
		NSArray *pixelPoints = [dictionary valueForKey:@"pixelPoints"];	
		NSMutableArray *tmpPixelPoints = [[NSMutableArray alloc] init];
		for(int i = 0; i < [pixelPoints count]; i++)
		{
			[tmpPixelPoints addObject:[NSValue valueWithCGPoint:CGPointMake([[[pixelPoints objectAtIndex:i] objectAtIndex:0] intValue], [[[pixelPoints objectAtIndex:i] objectAtIndex:1] intValue])]];
		}
		[map setPixelPoints:tmpPixelPoints];
		[tmpPixelPoints release];
		
		
		NSArray *coordinatePoints = [dictionary valueForKey:@"coordinatePoints"];	
		NSMutableArray *tmpCoordinatePoints = [[NSMutableArray alloc] init];
		for(int i = 0; i < [coordinatePoints count]; i++)
		{
			[tmpCoordinatePoints addObject:[NSValue valueWithCGPoint:CGPointMake([[[coordinatePoints objectAtIndex:i] objectAtIndex:0] intValue], [[[coordinatePoints objectAtIndex:i] objectAtIndex:1] intValue])]];
		}
		[map setCoordinatePoints:tmpCoordinatePoints];
		[tmpCoordinatePoints release];
		
		//use just point which have pairs
		if ([pixelPoints count] >= [coordinatePoints count])
			map.numberOfPoints = [coordinatePoints count];
		else 
			map.numberOfPoints = [pixelPoints count];
	}
	
	
	///////////////////////////////////
	//info
	[map setInfoSRS:[dictionary valueForKey:@"infoSRS"]];

	NSArray *defaultInfoAddress = [[NSArray alloc] initWithObjects:@"http://maps.google.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", @"{selectedcoord.y}", @"{selectedcoord.x}", nil];
	[map setInfoAddress:defaultInfoAddress];
	[defaultInfoAddress release];

	[map setInfoAddress:[dictionary valueForKey:@"infoAddress"]];
	
	[map setInfoType:[dictionary valueForKey:@"infoType"]];
	
	
	
	
	return map;
}




@end
