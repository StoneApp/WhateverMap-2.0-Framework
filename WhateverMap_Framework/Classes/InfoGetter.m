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

#import "InfoGetter.h"
//#import "SourceData.h"
#import "TiledScrollView.h"
#import "QueryFactory.h"
#import "MapSourceDefinition.h"
//#import "MapController.h"
#import "WMDataSource.h"

@implementation InfoGetter



/*
+ (NSString*) getInfoFromAddress:(NSArray*)addressArray atCoord:(CGPoint)coord onTileZoom:(int)zoom Column:(int)col Row:(int)row
{
	MapSourceDefinition *mapSource = nil;
	mapSource = [[SourceData sharedInstance] getSelectedMapSource];
	NSArray* mapSourceAddress = [mapSource.infoAddress copy];	
    
	QueryFactory *queryFactory = [[QueryFactory alloc] initWithDefinition:mapSource selectedPixel:coord];
	NSString* infoQuery = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:zoom Column:col Row:row inCoordinateSystem:mapSource.infoSRS];
	[queryFactory release];
	
#ifdef LOG_TEXT	
	NSLog(@"InfoGetter.m: infoQuery:%@", infoQuery);
#endif	
    
	[mapSourceAddress release];
	
	return infoQuery;
}
*/

/*
+ (NSString*) getInfoFromAddress:(NSArray*)addressArray atCoord:(CGPoint)coord onTileZoom:(int)zoom Column:(int)col Row:(int)row DataSource:(WMDataSource*)dataSource
{
	MapSourceDefinition *mapSource = nil;
	mapSource = [[SourceData sharedInstance] getSelectedMapSource];
	NSArray* mapSourceAddress = [mapSource.infoAddress copy];	
    NSString* infoSRS = [mapSource.infoSRS copy];
    
	QueryFactory *queryFactory = [[QueryFactory alloc] initWithDefinition:mapSource selectedPixel:coord];
	NSString* infoQuery = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:zoom Column:col Row:row inCoordinateSystem:infoSRS];
    [queryFactory release];
    
    MapSourceDefinition *mapSource2 = nil;
	mapSource2 = [[dataSource getLayerAtIndex:0] retain];    
    //if (mapSource == nil)
    //    return nil;
    
    NSArray* mapSourceAddress2 = [mapSource2.infoAddress retain];	
    NSString* infoSRS2 = [mapSource2.infoSRS retain];
    
    
    QueryFactory *queryFactory2 = [[QueryFactory alloc] initWithDefinition:mapSource2 selectedPixel:coord];
	//NSString* infoQuery2 = [[queryFactory2 buildQueryFromArray:mapSourceAddress2 WithZoom:zoom Column:col Row:row inCoordinateSystem:infoSRS2] retain];
    //QueryFactory *queryFactory2 = [[QueryFactory alloc] initWithDefinition:mapSource selectedPixel:coord];
    NSString* infoQuery2 = [[queryFactory2 buildQueryFromArray:mapSourceAddress2 WithZoom:zoom Column:col Row:row inCoordinateSystem:infoSRS2] retain];
    [queryFactory2 release];
	
	
#ifdef LOG_TEXT	
	NSLog(@"InfoGetter.m: infoQuery:%@", infoQuery);
#endif	
    
	[mapSourceAddress release];
    [infoSRS release];
    [mapSource2 release];
	
	return [infoQuery2 autorelease];
}
*/


+ (NSString*) getInfoFromSource:(WMDataSource*)dataSource atCoord:(CGPoint)coord onTileZoom:(int)zoom Column:(int)col Row:(int)row
{
    MapSourceDefinition *mapSource = nil;
	mapSource = [[dataSource getLayerAtIndex:0] retain];    
    NSArray* mapSourceAddress = [mapSource.infoAddress retain];	
    NSString* infoSRS = [mapSource.infoSRS retain];
    
    if (mapSourceAddress == nil || [mapSourceAddress count] == 0 || infoSRS == nil || [infoSRS length] == 0)
        return nil;
    
    
    QueryFactory *queryFactory = [[QueryFactory alloc] initWithDefinition:mapSource selectedPixel:coord];
    NSString* infoQuery = [[queryFactory buildQueryFromArray:mapSourceAddress WithZoom:zoom Column:col Row:row inCoordinateSystem:infoSRS] retain];
    [queryFactory release];
	
	
#ifdef LOG_TEXT	
    NSLog(@"InfoGetter.m: infoQuery:%@", infoQuery);
#endif	
    
	[mapSourceAddress release];
    [infoSRS release];
    [mapSource release];
	
	return [infoQuery autorelease];
}



@end
