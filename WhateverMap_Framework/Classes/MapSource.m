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

#import "MapSource.h"
#include <math.h>
#import "WMSSource.h"
#import "constants.h"

#import "Common.h"
#import "CoordConverter.h"
//#import "MapController.h"
#import "TiledScrollView.h"
#import "QueryFactory.h"
#import "MapSourceDefinition.h"

//#import "SourceData.h"
#import "WMDataSource.h"


@interface MapSource (Private)

//- (BBox) tile2BBoxByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize;
-(BBox) tile2BBoxByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize;

- (double) tile2lon:(NSInteger) x: (NSInteger) zoom MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize;
- (double) tile2lat:(NSInteger) y: (NSInteger) zoom MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize;


/*
//non-delegate version
- (NSString*) getNewRequestAddressByZoomWithParameters: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row;
- (void) getNewRequestAddressByTile:(TileObject*)tile;
- (NSString*) getNewRequestAddressByZoomForWMS: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row;
*/
 
//Delegate version
- (void) getNewRequestAddressByZoomDelegateWithParameters: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer;
- (void) getNewRequestAddressDelegateByTile:(TileObject*)tile;
- (void) getNewRequestAddressDelegateByZoomForWMS: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer;
@end



@implementation MapSource

@synthesize resultOfQueryFactory;
@synthesize delegate;
@synthesize wmDataSource;


+ (MapSource *)sharedInstance
{
	static MapSource *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[MapSource alloc] init];
		}
	}
	
	return instance;
}



//get longitude from tile coordinate x 
//minimum is -180 degree
//maximum is 180 degreee
-(double) tile2lon:(NSInteger) x: (NSInteger) zoom MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize
{
	//2* is the only change
	return (x / (2*pow(2.0, zoom)) * 360.0) - 180;
}


//get latitude from tile coordinate y
//minimum is -85.xxx //not 90 degreee
//maximum is 85.xxx
-(double) tile2lat:(NSInteger) y: (NSInteger) zoom MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize
{
	return (y / (pow(2.0, zoom)) * -180.0) + 90;
}



-(BBox) tile2BBoxByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer MapResolution:(CGSize)resolution TileSize:(CGSize)tileSize
{
	Tile tile;
	tile.zoom = zoom;
	tile.x = column;
	tile.y = row;
		
	BBox boundingBox;

	//Tile like EPSG:4326 1x2 square
	boundingBox.maxX = [self tile2lon:tile.x+1 :tile.zoom MapResolution:resolution TileSize:tileSize];
	boundingBox.maxY = [self tile2lat:tile.y :tile.zoom MapResolution:resolution TileSize:tileSize];
	boundingBox.minX = [self tile2lon:tile.x :tile.zoom MapResolution:resolution TileSize:tileSize];
	boundingBox.minY = [self tile2lat:tile.y+1 :tile.zoom MapResolution:resolution TileSize:tileSize];
	
    MapSourceDefinition *mapSource = nil;
    //mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    mapSource = [[wmDataSource getLayerAtIndex:layer] retain];
        
	CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:mapSource];
	LatLon pointLB = [coordConvertor convertPixelToLatLon:CGPointMake((tile.x) * tileSize.width, (tile.y+1) * tileSize.height) zoom:zoom];
	LatLon pointRU = [coordConvertor convertPixelToLatLon:CGPointMake((tile.x+1) * tileSize.width, (tile.y) * tileSize.height) zoom:zoom];
	[coordConvertor release];
    [mapSource release];
	
	boundingBox.maxX = pointRU.lon;
	boundingBox.maxY = pointRU.lat;
	boundingBox.minX = pointLB.lon;
	boundingBox.minY = pointLB.lat;
	
	return boundingBox;
}







/*
- (NSString*) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row
{
	MapSourceDefinition *mapSource = nil;
	mapSource = [[SourceData sharedInstance] getSelectedMapSource];

	NSString* typeOfService = [mapSource.typeOfService lowercaseString];
	
	if ([typeOfService rangeOfString:@"wms"].location != NSNotFound)
	{
		return [self getNewRequestAddressByZoomForWMS: zoom Column:column Row:row];
	}
	else if ([typeOfService rangeOfString:@"tms"].location != NSNotFound ||
			[typeOfService rangeOfString:@"coordinates"].location != NSNotFound ||
			[typeOfService rangeOfString:@"tms2"].location != NSNotFound
			)
	{
		return [self getNewRequestAddressByZoomWithParameters:zoom Column:column Row:row];
	}
	else 
	{
		return [self getNewRequestAddressByZoomWithParameters:zoom Column:column Row:row];
	}
	
}
*/


/*
- (NSString*) getNewRequestAddressByZoomWithParameters: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row
{
	TileObject *tile = [[TileObject alloc] init];
	[tile setZoom:zoom];
	[tile setColumn:column];
	[tile setRow:row];
	
	[self getNewRequestAddressByTile:tile];
	
#ifdef LOG_TEXT	
	NSLog(@"MapSource: resultOfQueryFactory:%@", resultOfQueryFactory);
#endif
	
	return resultOfQueryFactory;
}


- (void) getNewRequestAddressByTile:(TileObject*)tile
{
	MapSourceDefinition *mapSource = [[[SourceData sharedInstance] getSelectedMapSource] retain];
	
	NSArray *mapSourceAddress = nil;
	if (mapSource.typeOfService == @"TMS2")
	{
		mapSourceAddress = [[[mapSource.levels objectAtIndex:tile.zoom - mapSource.minLevel] objectAtIndex:0] copy];
	}
	else
	{
		mapSourceAddress = [mapSource.address copy];
	}
	
	QueryFactory *queryFactory = [[QueryFactory alloc] initWithDefinition:mapSource];
	
	NSString *query = nil;
	if (mapSource.addressSRS == nil || [mapSource.addressSRS isEqual:@""])		
		query = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:tile.zoom Column:tile.column Row:tile.row inCoordinateSystem:mapSource.projectionKey];
	else
		query = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:tile.zoom Column:tile.column Row:tile.row inCoordinateSystem:mapSource.addressSRS];
	
	[queryFactory release];
	[mapSourceAddress release];
	[mapSource release];
	
	
	[self setResultOfQueryFactory:query];
}	


- (NSString*) getNewRequestAddressByZoomForWMS: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row
{
	MapSourceDefinition *mapSource = nil;
	mapSource = [[SourceData sharedInstance] getSelectedMapSource];
	
	WMSSource* wms = [[WMSSource alloc] initWithWMSAddress:[mapSource.address objectAtIndex:0] Layer:mapSource.layers];
	[wms setBoundingBox:[self tile2BBoxByZoom:zoom Column:column Row:row MapResolution:mapSource.mapResolution TileSize:mapSource.tileResolution ]];
	NSString* textAddress = [wms getRequest];
	[wms release];

#ifdef LOG_TEXT 	
	NSLog(@"MapSource.m: url: %@", textAddress);
#endif	
	
	return textAddress;
}

*/










//DELEGATE ALTERNATIVE

/*
- (void) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer forDelegate:(id)aDelegate
{
    [[SourceData sharedInstance] selectMapSource:layer];    
    [self getNewRequestAddressByZoom:zoom Column:column Row:row forDelegate:aDelegate];
}


- (void) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row forDelegate:(id)aDelegate
{
	[self setDelegate:aDelegate];
	
	MapSourceDefinition *mapSource = nil;
	mapSource = [[SourceData sharedInstance] getSelectedMapSource];
	
	NSString* typeOfService = [mapSource.typeOfService lowercaseString];
	
	if ([typeOfService rangeOfString:@"wms"].location != NSNotFound)
	{
		[self getNewRequestAddressDelegateByZoomForWMS: zoom Column:column Row:row];
	}
	else if ([typeOfService rangeOfString:@"tms"].location != NSNotFound ||
			 [typeOfService rangeOfString:@"coordinates"].location != NSNotFound ||
			 [typeOfService rangeOfString:@"tms2"].location != NSNotFound
			 )
	{
		[self getNewRequestAddressByZoomDelegateWithParameters:zoom Column:column Row:row];
	}
	else 
	{
		[self getNewRequestAddressByZoomDelegateWithParameters:zoom Column:column Row:row];
	}
	
}
*/


- (void) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer forDelegate:(id)aDelegate
{
    if (wmDataSource == nil)
        return;
        
	[self setDelegate:aDelegate];
	
	MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];	
    mapSource = [[wmDataSource getLayerAtIndex:layer] retain];
    
	NSString* typeOfService = [mapSource.typeOfService lowercaseString];
    
    //NSString* typeOfService = [[wmDataSource getLayerAtIndex:layer].typeOfService lowercaseString];
    
	
	if ([typeOfService rangeOfString:@"wms"].location != NSNotFound)
	{
		[self getNewRequestAddressDelegateByZoomForWMS: zoom Column:column Row:row Layer:layer];
	}
	else if ([typeOfService rangeOfString:@"tms"].location != NSNotFound ||
			 [typeOfService rangeOfString:@"coordinates"].location != NSNotFound ||
			 [typeOfService rangeOfString:@"tms2"].location != NSNotFound
			 )
	{
		[self getNewRequestAddressByZoomDelegateWithParameters:zoom Column:column Row:row Layer:layer];
	}
	else 
	{
		[self getNewRequestAddressByZoomDelegateWithParameters:zoom Column:column Row:row Layer:layer];
	}
	
    [mapSource release];
}





- (void) getNewRequestAddressByZoomDelegateWithParameters: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer
{
	TileObject *tile = [[TileObject alloc] init];
	[tile setZoom:zoom];
	[tile setColumn:column];
	[tile setRow:row];
    [tile setPositionIndex:layer];
	
	[self getNewRequestAddressDelegateByTile:tile];
	
#ifdef LOG_TEXT	
	//NSLog(@"MapSource.m: ResourceOfQueryFActory2:%@", resultOfQueryFactory);
#endif
	
	[tile release];
}


- (void) getNewRequestAddressDelegateByTile:(TileObject*)tile
{
	//MapSourceDefinition *mapSource = [[[SourceData sharedInstance] getSelectedMapSource] retain];
    MapSourceDefinition *mapSource = nil;
    mapSource = [[wmDataSource getLayerAtIndex:[tile positionIndex]] retain];
    
	
	NSArray *mapSourceAddress = nil;
	if (mapSource.typeOfService == @"TMS2")
	{
		mapSourceAddress = [[[mapSource.levels objectAtIndex:tile.zoom - mapSource.minLevel] objectAtIndex:0] copy];
	}
	else
	{
		mapSourceAddress = [mapSource.address copy];
	}
	
	QueryFactory *queryFactory = [[QueryFactory alloc] initWithDefinition:mapSource];
	
	NSString *query = nil;
	if (mapSource.addressSRS == nil || [mapSource.addressSRS isEqual:@""])		
		query = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:tile.zoom Column:tile.column Row:tile.row inCoordinateSystem:mapSource.projectionKey];
	else
		query = [queryFactory buildQueryFromArray:mapSourceAddress WithZoom:tile.zoom Column:tile.column Row:tile.row inCoordinateSystem:mapSource.addressSRS];
	
	[queryFactory release];
	[mapSourceAddress release];
	[mapSource release];
		
	[[self delegate] prepareRequestForLoading:query];
}	


- (void) getNewRequestAddressDelegateByZoomForWMS: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer
{
	MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    mapSource = [[wmDataSource getLayerAtIndex:layer] retain];
	
	WMSSource* wms = [[WMSSource alloc] initWithWMSAddress:[mapSource.address objectAtIndex:0] Layer:mapSource.layers];
	[wms setBoundingBox:[self tile2BBoxByZoom:zoom Column:column Row:row Layer:layer MapResolution:mapSource.mapResolution TileSize:mapSource.tileResolution ]];
	NSString* textAddress = [wms getRequest];
	[wms release];
    
    [mapSource release];
	
#ifdef LOG_TEXT 	
	NSLog(@"MapSource.m: wms-url:%@", textAddress);
#endif	
	
	[[self delegate] prepareRequestForLoading:textAddress];
}




@end
