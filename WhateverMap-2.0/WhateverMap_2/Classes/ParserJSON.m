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

#import "ParserJSON.h"
#import "JSON.h"
#import "SourceNode.h"
#import "SBJsonWriter.h"
#import "constants.h"
#import "SourceData.h"

#import "Common.h"
#import "MapSourceDefinition.h"

@implementation ParserJSON


//singleton
+ (ParserJSON *)sharedInstance
{
	static ParserJSON *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[ParserJSON alloc] init];
		}
	}
	
	return instance;
}


//load root node from specified URL address
//updateBoolean - allow to load definition from new URL address
//overWriteBoolean - allow to rewrite current definition
- (void) loadAndSetRootNode:(NSString*)textURL update:(BOOL)updateBoolean overWrite:(BOOL)overWriteBoolean
{	
	//get definition and parse it 
	ParserJSON* parser = [[ParserJSON alloc] init];
	SourceNode *sourceNode = [parser loadRootNode:[NSURL URLWithString:textURL] update:updateBoolean overWrite:overWriteBoolean];
	[parser release];	
	
	//assign result to SourceData for usage
	NSMutableArray *mapSources = [[sourceNode getChild:0] maps];
    SourceData *sourceData = [[SourceData sharedInstance] retain];
	[sourceData setMapSources:mapSources];	
	[sourceData setSourceNode:sourceNode];
	[sourceData setNodeIndex:0];
    [sourceData release];
}


- (SourceNode*) loadRootNode:(NSURL*)url update:(BOOL)updateBoolean overWrite:(BOOL)overWriteBoolean
{
	NSString* comparativeDefinitionFile = [PATH_RESOURCE stringByAppendingPathComponent: @"comparativeDefinitionFile.txt"];	
	NSString* appDefinitionFile = [PATH_RESOURCE stringByAppendingPathComponent: @"mapDefinition.txt"];
	NSString* initBundleDefinitionFile = [[NSBundle mainBundle] pathForResource:@"JSONdef-katastr" ofType:@"txt"];

	BOOL fileExists;
	NSError *error = nil;
	NSString *urlDefinition = nil;	

    BOOL updateEnabled = UPDATE_VALUE_DEFINITION_ENABLED;
    
	if(updateEnabled || updateBoolean)
	{
		NSHTTPURLResponse *response = nil;
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];
        
		NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];	
		[urlRequest release];
        if (urlDefinition == nil)
            urlDefinition = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]; 		
        if (urlDefinition == nil)
            urlDefinition = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]; 		
	}	
	
	if (error)	
		NSLog(@"Error:Server is not available");
	
	if (overWriteBoolean)
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:comparativeDefinitionFile])
			if ([[NSFileManager defaultManager] fileExistsAtPath:appDefinitionFile])
				[[NSFileManager defaultManager] removeItemAtPath:appDefinitionFile error:&error];

		[[NSFileManager defaultManager] copyItemAtPath:comparativeDefinitionFile toPath:appDefinitionFile error:nil];
	}
	
	
	if (!overWriteBoolean)
	{
		//IS THERE COMPARATIVE DEFINITION?
		fileExists = [[NSFileManager defaultManager] fileExistsAtPath:comparativeDefinitionFile];
		if (!fileExists)
		{
			if (urlDefinition && !error)
			{
				//NSLog(@"url definition saved");
				[urlDefinition writeToFile:appDefinitionFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
				[urlDefinition writeToFile:comparativeDefinitionFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
			}
			else 
			{
				//if there is no file to compare, create it (new installed program)
				[[NSFileManager defaultManager] copyItemAtPath:initBundleDefinitionFile toPath:comparativeDefinitionFile error:nil];
				//and copy to file for using
				[[NSFileManager defaultManager] copyItemAtPath:initBundleDefinitionFile toPath:appDefinitionFile error:nil];			
			}
		}
		else //compare with comparative definition
		{
			//compare
			NSString* text1;
			NSString* text2;
			
			if (urlDefinition && !error)
			{
				text1 = urlDefinition;
			}
			else
			{
				text1 = [NSString stringWithContentsOfFile:appDefinitionFile encoding:NSUTF8StringEncoding error:nil];		
			}
			
			text2 = [NSString stringWithContentsOfFile:comparativeDefinitionFile encoding:NSUTF8StringEncoding error:nil];				

			
			
			BOOL equal = FALSE;
			
			if ([text1 length] == [text2 length])	
				equal = [text1 isEqualToString:text2];
			
			if (!equal)
			{
				//store new file for comparation
				if ([[NSFileManager defaultManager] fileExistsAtPath:comparativeDefinitionFile])
					[[NSFileManager defaultManager] removeItemAtPath:comparativeDefinitionFile error:&error];
				[text1 writeToFile:comparativeDefinitionFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
				
				//store  new file for using
				if ([[NSFileManager defaultManager] fileExistsAtPath:appDefinitionFile])
					[[NSFileManager defaultManager] removeItemAtPath:appDefinitionFile error:&error];
				[text1 writeToFile:appDefinitionFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
			}
		}
	}
		
	if (urlDefinition)
		[urlDefinition release];
	
#ifdef DEBUG	
	//NSLog(@"%@", urlDefinition);
#endif		
	//final check of using file - (should not be neded)
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appDefinitionFile];
	if (!fileExists) 
		[[NSFileManager defaultManager] copyItemAtPath:initBundleDefinitionFile toPath:appDefinitionFile error:nil];
	
	
	NSString* nodeText = [NSString stringWithContentsOfFile:appDefinitionFile encoding:NSUTF8StringEncoding error:nil];			
	SourceNode* rootNode = [self parseList:nodeText];
	
#ifdef DEBUG	
	//NSLog(@"%@", nodeText);
#endif	
	
	
	if (rootNode && [rootNode getNumberOfItems] > 0)
		return rootNode;
	else
	{
		NSString* alternativeText = [NSString stringWithContentsOfFile:initBundleDefinitionFile encoding:NSUTF8StringEncoding error:nil];
		SourceNode* alternativeNode = [self parseList:alternativeText];
		return alternativeNode;
		
	}
}



//generate definition from current dettings of an object and save it
- (BOOL) saveRootNode:(SourceNode*) node
{
	NSArray* obj = [self createList:node];

	NSError *error = nil;
	NSString* textJSON = nil;
	if (obj)
	{
		SBJsonWriter *writer = [SBJsonWriter new];
		textJSON = [writer stringWithObject:obj error:&error];	
		[writer release];
	}
	
	if (textJSON)
	{
		//save to file
		NSString* definitionFile = [PATH_RESOURCE stringByAppendingPathComponent: @"mapDefinition.txt"];
		
		BOOL isWritten;
		NSData *data = [textJSON dataUsingEncoding:NSUTF8StringEncoding];
		isWritten = [[NSFileManager defaultManager] createFileAtPath:definitionFile contents:data attributes:nil];
		
		if (!isWritten)
			return false;
	}
	else
	{
		NSLog(@"error while saving map definitions");
		return false;
	}
	
	return true;
}


//parse string including JSON definition to return node
- (SourceNode*) parseList:(NSString*)string
{
	id objectJSON = [string JSONValue];
	
	SourceNode *rootNode = [[[SourceNode alloc] init] autorelease];
	[rootNode setTitle:@"root"];
	[rootNode setCode:@"tmpDir-"];
	
	//if you find just single definition try to return format as required
	if ([objectJSON isKindOfClass:[NSDictionary class]])
	{
		
		SourceNode* newNode;
		if ([self isMapComposition:objectJSON])
			newNode = [self createMapCompositionNode:objectJSON];
		else 
			newNode = [self createMapNode:objectJSON];	
		
		if (newNode)
			[rootNode addNode:newNode];		
	}	
	//object is an array = it means go through all object in array and process them
	else if ([objectJSON isKindOfClass:[NSArray class]])
	{		
		for(int i = 0; i < [objectJSON count]; i++)
		{
			if ([[objectJSON objectAtIndex:i] isKindOfClass:[NSDictionary class]])
			{
				SourceNode* newNode;
				if ([self isMapComposition:[objectJSON objectAtIndex:i]])
					newNode = [self createMapCompositionNode:[objectJSON objectAtIndex:i]];
				else 
					newNode = [self createMapNode:[objectJSON objectAtIndex:i]];	
							   
				if (newNode)
					[rootNode addNode:newNode];		
			}
		}
	}
	
	return rootNode;
}



- (BOOL) isMapComposition:(NSDictionary*)objectJSON
{
	id maps = [objectJSON valueForKey:@"maps"];
	if ([maps isKindOfClass:[NSArray class]])
		return true;
	
	return false;
}




//return array of mapDefinition struct
- (MapSourceDefinition*) parseString:(NSString*)string
{
	id objectJSON = [string JSONValue];
	
	MapSourceDefinition *map = nil;
	
	
	if ([objectJSON isKindOfClass:[NSDictionary class]])
	{
		map = [self createMapSourceDefinition:objectJSON];
		return map; 
	}	
	else if ([objectJSON isKindOfClass:[NSArray class]])
	{
		if ([[objectJSON objectAtIndex:0] isKindOfClass:[NSDictionary class]])
			map = [self createMapSourceDefinition:[objectJSON objectAtIndex:0]];
		return map;
	}
	else if ([objectJSON isKindOfClass:[NSString class]])
	{
		return map;
	}
	else if ([objectJSON isKindOfClass:[NSNumber class]])
	{
		return map;
	}
	else if (objectJSON == nil)
	{
		return map;
	}
	else
	{
		return map;
	}
}



- (SourceNode*) createMapNode:(NSDictionary*)objectJSON
{
	SourceNode *newNode = [[[SourceNode alloc] init] autorelease];
	MapSourceDefinition *newMap = nil;
	newMap = [self createMapSourceDefinition:objectJSON];
	[newNode addMap:newMap];
	[newNode setTitle:newMap.title];
	return newNode;
}


- (SourceNode*) createMapCompositionNode:(NSDictionary*)objectJSON
{
	SourceNode *newNode = [[SourceNode alloc] init];
	[newNode setTitle:[objectJSON valueForKey:@"title"]];
	
	NSArray* mapArray = [objectJSON valueForKey:@"maps"];
	
	for (int i = 0; i < [mapArray count]; i++) 
	{
		if ([[mapArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) 
		{							
			MapSourceDefinition *newMap = nil;
			newMap = [self createMapSourceDefinition:[mapArray objectAtIndex:i]];
			[newNode addMap:newMap];
		}
	}
	
	return [newNode autorelease];			
}


- (MapSourceDefinition*) createMapSourceDefinition:(NSDictionary*)obj
{
	MapSourceDefinition *map = [[MapSourceDefinition alloc] init];

	
/////////////////////////////////
//source definition
	[map setTitle:[obj valueForKey:@"title"]];
	[map setTypeOfService:[obj valueForKey:@"typeOfService"]];
	[map setAddress:[obj valueForKey:@"address"]];
	[map setAddressSRS:[obj valueForKey:@"addressSRS"]];
	[map setVisibleFromLevel:[[obj valueForKey:@"visibleFromLevel"] intValue]];
	[map setVisibleToLevel:[[obj valueForKey:@"visibleToLevel"] intValue]];
	
	if( [obj valueForKey:@"visible"] == nil)
		[map setVisible:true];
	else
		[map setVisible:[[obj valueForKey:@"visible"] boolValue]];
	
	[map setLayers:[obj valueForKey:@"layers"]];
	[map setMinLevel:[[obj valueForKey:@"minLevel"] intValue]];
	[map setMaxLevel:[[obj valueForKey:@"maxLevel"] intValue]];
	[map setDeltaLevel:[[obj valueForKey:@"deltaLevel"] intValue]];
		
	NSArray *tileResolution = [[obj valueForKey:@"tileResolution"] retain];	
	CGSize tileRes = CGSizeMake([[tileResolution objectAtIndex:0] intValue], [[tileResolution objectAtIndex:1] intValue]); 
	[map setTileResolution:tileRes];
	[tileResolution release];
	
	[map setProjectionKey:[obj valueForKey:@"projectionKey"]];
	
	NSArray *boundingBox = [[obj valueForKey:@"boundingBox"] retain]; 
	BBox bbox = BBoxMake([[boundingBox objectAtIndex:0] doubleValue], [[boundingBox objectAtIndex:1] doubleValue], [[boundingBox objectAtIndex:2] doubleValue], [[boundingBox objectAtIndex:3] doubleValue]);
	[map setBoundingBox:bbox];
	[boundingBox release];	
	
	NSArray *mapResolution = [[obj valueForKey:@"mapResolution"] retain];
	CGSize mapRes = CGSizeMake([[mapResolution objectAtIndex:0] doubleValue], [[mapResolution objectAtIndex:1] doubleValue]); 
	[map setMapResolution:mapRes];
	[mapResolution release];
	
	if ([[obj valueForKey:@"alpha"] isKindOfClass:[NSNumber class]])
		[map setAlpha:[[obj valueForKey:@"alpha"] floatValue]];
	
	if( [obj valueForKey:@"alphaLock"] != nil)
		[map setAlphaLock:[[obj valueForKey:@"alphaLock"] boolValue]];


//////////////////////////////////
//georeference	
	[map setCoordToPixelX:[obj valueForKey:@"coordToPixelX"]];
	[map setCoordToPixelY:[obj valueForKey:@"coordToPixelY"]];
	[map setPixelToCoordX:[obj valueForKey:@"pixelToCoordX"]];
	[map setPixelToCoordY:[obj valueForKey:@"pixelToCoordY"]];
	
	//optimalization for users creating definitions
	[map setGeoreferencingType:[[obj valueForKey:@"georeferencingType"] intValue]];
	
	if (map.georeferencingType == 2)
	{
		//construct coordinates from bounding box		
		[map setGeoreferencingType:1];
		[map setNumberOfPoints:4];
		
		NSMutableArray *tmpPixelArray = [[NSMutableArray alloc] init];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.mapResolution.width, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, map.mapResolution.height)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.mapResolution.width, map.mapResolution.height)]];
		[map setPixelPoints:tmpPixelArray];
		[tmpPixelArray release];
		
		NSMutableArray *tmpCoordArray = [[NSMutableArray alloc] init];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.minX, map.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.maxX, map.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.minX, map.boundingBox.minY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(map.boundingBox.maxX, map.boundingBox.minY)]];
		[map setCoordinatePoints:tmpCoordArray];
		[tmpCoordArray release];		
	}
	else 
	{
		NSMutableArray *tmpPixelArray = [[NSMutableArray alloc] init];
		NSArray *pixelPoints = [obj valueForKey:@"pixelPoints"];	
		for(int i = 0; i < [pixelPoints count]; i++)
		{
			[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake([[[pixelPoints objectAtIndex:i] objectAtIndex:0] intValue], [[[pixelPoints objectAtIndex:i] objectAtIndex:1] intValue])]];
		}
		[map setPixelPoints:tmpPixelArray];
		[tmpPixelArray release];
		
		NSMutableArray *tmpCoordArray = [[NSMutableArray alloc] init];
		NSArray *coordinatePoints = [obj valueForKey:@"coordinatePoints"];	
		for(int i = 0; i < [coordinatePoints count]; i++)
		{
			[tmpCoordArray addObject:[NSValue valueWithCGPoint: CGPointMake([[[coordinatePoints objectAtIndex:i] objectAtIndex:0] intValue], [[[coordinatePoints objectAtIndex:i] objectAtIndex:1] intValue])]];
		}
		[map setCoordinatePoints:tmpCoordArray];
		[tmpCoordArray release];
		
		//use just point which have pairs
		if ([pixelPoints count] >= [coordinatePoints count])
			[map setNumberOfPoints:[coordinatePoints count]];
		else 
			[map setNumberOfPoints:[pixelPoints count]];
	}

	

///////////////////////////////////
//info
	[map setInfoSRS:[obj valueForKey:@"infoSRS"]];
	//sample info request to CUZK
	//map.infoAddress = [[NSArray alloc] initWithObjects:@"http://maps.google.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", @"{selectedcoord.y}", @"{selectedcoord.x}", nil];
	[map setInfoType:[obj valueForKey:@"infoType"]];
	[map setInfoAddress:[obj valueForKey:@"infoAddress"]];
	
		
	return [map autorelease];
}





/////////////
//SAVE METHOD
- (id) createList:(SourceNode*)node
{
	if (!node)
		return nil;
		
	if ([node isMap])
	{
		NSDictionary *tmpDict = [self createDictionaryFromMapNode:node];
		return [NSArray arrayWithObject:tmpDict];
	}
	else 
	{
		NSMutableArray *arrayOfCompositions = [[[NSMutableArray alloc] init] autorelease];
		for (int i = 0; i < [node getNumberOfItems]; i++) 
		{
			if ([[node getChild:i] isMap])
			{
				NSDictionary *tmpDict = [self createDictionaryFromMapNode:[node getChild:i]];
				if (tmpDict)
					[arrayOfCompositions addObject:tmpDict];
			}
			else 
			{
				for (int j = 0; j < [[node getChild:i] getNumberOfItems]; j++) 
				{					
					if ([[[node getChild:i] getChild:j] isMap])
					{			
						NSDictionary* tmpMapDict = [self createDictionaryFromMapNode:[[node getChild:i] getChild:j]];
						if (tmpMapDict)
							[arrayOfCompositions addObject:tmpMapDict];
					}
				}				
			}

		}
		return (NSArray*)arrayOfCompositions;
	}
}

- (NSDictionary*) createDictionaryFromMapNode:(SourceNode*)mapNode
{
	NSMutableArray* arrayOfMaps = [[NSMutableArray alloc] init];
	for (int j = 0; j < [mapNode getNumberOfItems]; j++) 
	{					
		NSDictionary* mapDefDict = [self createDictionaryFromMapDefinition:[mapNode getMap:j]];
		if (mapDefDict)
			[arrayOfMaps addObject:mapDefDict];
	}	
	
	if (!mapNode.title || ([arrayOfMaps count] <= 0))
	{
		[arrayOfMaps release];
		return nil;
	}
	
	NSDictionary* mapCompositionDict = [[[NSDictionary alloc] initWithObjectsAndKeys:										 
										[mapNode title], @"title", 										
										(NSArray*)arrayOfMaps, @"maps",
										nil] autorelease];
	[arrayOfMaps release];
	
	return mapCompositionDict;
}



- (NSDictionary*) createDictionaryFromMapDefinition:(MapSourceDefinition*)map
{
	NSMutableDictionary* mapDict = [[NSMutableDictionary alloc] init];
	
	if (map.title)
		[mapDict setValue:map.title forKey:@"title"];
	
	if (map.typeOfService)
		[mapDict setValue:map.typeOfService forKey:@"typeOfService"];
	
	
	[mapDict setValue:[NSNumber numberWithFloat:map.alpha] forKey:@"alpha"];
		
	if (!map.alphaLock)
		[mapDict setValue:@"false" forKey:@"alphaLock"];
	else
		[mapDict setValue:@"true" forKey:@"alphaLock"];
	
	
	if (!map.visible)
		[mapDict setValue:@"false" forKey:@"visible"];
	else
		[mapDict setValue:@"true" forKey:@"visible"];

	[mapDict setValue:[NSNumber numberWithInt:map.visibleFromLevel] forKey:@"visibleFromLevel"];
	[mapDict setValue:[NSNumber numberWithInt:map.visibleToLevel] forKey:@"visibleToLevel"];
	
	[mapDict setValue:[NSNumber numberWithInt:map.minLevel] forKey:@"minLevel"];
	[mapDict setValue:[NSNumber numberWithInt:map.maxLevel] forKey:@"maxLevel"];
	[mapDict setValue:[NSNumber numberWithInt:map.deltaLevel] forKey:@"deltaLevel"];
	
	
	//if (map.tileResolution)
	{
		NSArray *tileRes = [NSArray arrayWithObjects:
							 [NSNumber numberWithDouble:map.tileResolution.width],
 							 [NSNumber numberWithDouble:map.tileResolution.height],
							 nil];
		
		[mapDict setValue:tileRes forKey:@"tileResolution"];
	}
	

	
	//if (map.mapResolution)
	{
		NSArray *mapRes = [NSArray arrayWithObjects:
							[NSNumber numberWithDouble:map.mapResolution.width],
							[NSNumber numberWithDouble:map.mapResolution.height],
							nil];
		
		[mapDict setValue:mapRes forKey:@"mapResolution"];
	}
	
	
	[mapDict setValue:[NSNumber numberWithInt:map.georeferencingType] forKey:@"georeferencingType"];
	
	
	if (map.projectionKey)
		[mapDict setValue:map.projectionKey forKey:@"projectionKey"];
	
	
	if (map.address)
		[mapDict setValue:map.address forKey:@"address"];

	
	if (map.addressSRS)
		[mapDict setValue:map.addressSRS forKey:@"addressSRS"];
	
	
	//if (map.boundingBox)
	{
		NSArray *arayBBOX = [NSArray arrayWithObjects:
							  [NSNumber numberWithDouble:map.boundingBox.minX],
							  [NSNumber numberWithDouble:map.boundingBox.minY],
							  [NSNumber numberWithDouble:map.boundingBox.maxX],
							  [NSNumber numberWithDouble:map.boundingBox.maxY],
							 nil];
		[mapDict setValue:arayBBOX forKey:@"boundingBox"];
	}
	
	
	if (map.coordToPixelX)
		[mapDict setValue:map.coordToPixelX forKey:@"coordToPixelX"];
	if (map.coordToPixelY)
		[mapDict setValue:map.coordToPixelY forKey:@"coordToPixelY"];
	if (map.pixelToCoordX)
		[mapDict setValue:map.pixelToCoordX forKey:@"pixelToCoordX"];
	if (map.pixelToCoordY)
		[mapDict setValue:map.pixelToCoordY forKey:@"pixelToCoordY"];

	if (map.numberOfPoints >= 0)
	{
		[mapDict setValue:[NSNumber numberWithInt:map.numberOfPoints] forKey:@"numberOfPoints"];
		
		NSMutableArray* arrayPixel = [[NSMutableArray alloc] init];
		NSMutableArray* arrayCoord = [[NSMutableArray alloc] init];
		
		for (int i = 0; i < map.numberOfPoints; i++) 
		{
			[arrayCoord addObject:[NSArray arrayWithObjects:
								   [NSNumber numberWithDouble:[[map.coordinatePoints objectAtIndex:i] CGPointValue].x],
								   [NSNumber numberWithDouble:[[map.coordinatePoints objectAtIndex:i] CGPointValue].y],
								   nil]];
			[arrayPixel addObject:[NSArray arrayWithObjects:
								   [NSNumber numberWithDouble:[[map.pixelPoints objectAtIndex:i] CGPointValue].x],
								   [NSNumber numberWithDouble:[[map.pixelPoints objectAtIndex:i] CGPointValue].y],
								   nil]];
		}
		
		[mapDict setValue:arrayCoord forKey:@"coordinatePoints"];
		[mapDict setValue:arrayPixel forKey:@"pixelPoints"];
		
		[arrayCoord release];
		[arrayPixel release];
	}
	
	
////////////////
//INFO	
	if (map.infoSRS)
		[mapDict setValue:map.infoSRS forKey:@"infoSRS"];
	
	
	if (map.infoAddress)
		[mapDict setValue:map.infoAddress forKey:@"infoAddress"];
	
	
	if (map.infoType)
		[mapDict setValue:map.infoType forKey:@"infoType"];
	
	
	
/////////
//WMS SERVICE
	if (map.layers)
		[mapDict setValue:map.layers forKey:@"layers"];

	if (map.projectionSystem)
		[mapDict setValue:map.projectionSystem forKey:@"projectionSystem"];

	
/////////
//TMS SERVICE
	NSArray* arrayOrigin = [NSArray arrayWithObjects: 
								[NSNumber numberWithFloat:map.origin.x],
								[NSNumber numberWithFloat:map.origin.y],
								nil];
	[mapDict setValue:arrayOrigin forKey:@"origin"];
	
	if (map.levels)
		[mapDict setValue:map.levels forKey:@"levels"];

	
	return [(NSDictionary*)mapDict autorelease];
}

@end
