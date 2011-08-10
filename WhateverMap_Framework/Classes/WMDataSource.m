//
//  WMDataSource.m
//  WhateverMap_2
//
//  Created by Jirka on 13.7.11.
//  Copyright 2011 Mendel University in Brno. All rights reserved.
//

#import "WMDataSource.h"
#import "MapSourceDefinition.h"


@interface WMDataSource(Private)

- (MapSourceDefinition*) buildDefaultConfiguration;
- (MapSourceDefinition*) buildDefaultConfiguration2;

@end



@implementation WMDataSource



- (id) init
{
    self = [super init];
    if (self)
    {
        mapLayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id) initWithDefaultDefinition
{
    self = [super init];
    if (self)
    {
        mapLayers = [[NSMutableArray alloc] init];
        [self addLayer:[self buildDefaultConfiguration]];
        [self addLayer:[self buildDefaultConfiguration2]];
    }
    
    return self;
}


- (NSArray*) getLayers
{
    return [[mapLayers retain] autorelease];
}


- (BOOL) addLayer:(MapSourceDefinition*)layer;
{
    if (layer == nil)
        return NO;
    
    [mapLayers addObject:layer];
    return YES;
}


- (BOOL) insertLayer:(MapSourceDefinition*)layer AtIndex:(int)layerIndex;
{
    if (layerIndex < 0)
        layerIndex = 0;
    else if (layerIndex > [mapLayers count] -1)
        layerIndex = [mapLayers count] -1;
    
    if (layer == nil)
        return NO;
    
    [mapLayers insertObject:layer atIndex:layerIndex];
    return YES;
}

- (BOOL) updateLayerAtIndex:(int)layerIndex byLayer:(MapSourceDefinition*)layer
{
    if (layerIndex < 0 || layerIndex > [mapLayers count] -1)
        return NO;        
    
    if (layer == nil)
        return NO;
    
    [mapLayers removeObjectAtIndex:layerIndex];
    [mapLayers insertObject:layer atIndex:layerIndex];
    
    return YES;
}

- (int) getNumberOfLayers
{
    return [mapLayers count];
}


- (MapSourceDefinition*) getLayerAtIndex: (int) layerIndex
{
    if (layerIndex < 0 || layerIndex > [mapLayers count] -1)
        return nil;
    
    return [mapLayers objectAtIndex:layerIndex];
}


- (void) dealloc
{
    [mapLayers release]; 
    mapLayers = nil;
    
    [super dealloc];
}



////////////EXAMPLE CONFIGURATION///////////


/*
 {
 "title":"Open Street Maps",
 "typeOfService":"TMS",
 "addressGoogle":["http://mt0.google.com/vt/lyrs=m&z=%@&x=%@&y=%@", 
 "{zoom}", 
 "{column}", 
 "{row}"],
 
 "address":["http://tile.openstreetmap.org/%@/%@/%@.png", 
 "{zoom}", 
 "{column}", 
 "{row}"],
 "minLevel":1,
 "maxLevel":21,
 "deltaLevel":1,
 "tileResolution":[256, 256],
 
 "alphaLock":true,
 
 
 "projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",
 "georeferencingType":2,	
 "boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924]
 
 
 "mapResolution18":[67108864, 67108864],
 "mapResolution20":[268435456, 268435456],
 "mapResolution21":[536870912, 536870912],
 "mapResolution22":[1073741824, 1073741824],
 "mapResolution23":[2147483648, 2147483648],
 "mapResolution24":[4294967296, 4294967296],
 
 "mapResolution":[536870912, 536870912],
 
 
 "infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +units=m +no_defs",
 "infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
 "round({selectedcoord.x})", 
 "round({selectedcoord.y})"],
 "infoType":"web"
 }
*/



- (MapSourceDefinition*) buildDefaultConfiguration
{
    MapSourceDefinition *layer = [[MapSourceDefinition alloc] init];
    
    [layer setTitle:@"OSM"];
    [layer setTypeOfService:@"TMS"];
    NSArray *addressArray = [[NSArray alloc] initWithObjects:@"http://tile.openstreetmap.org/%@/%@/%@.png", @"{zoom}", @"{column}", @"{row}", nil];
    [layer setAddress:addressArray]; 
    [addressArray release];
    
    [layer setMinLevel:1];
    [layer setMaxLevel:21];
    [layer setDeltaLevel:1];
    [layer setTileResolution:CGSizeMake(256, 256)];
    [layer setAlphaLock:YES];
    [layer setProjectionKey:@"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"];
    [layer setGeoreferencingType:2];
    [layer setBoundingBox:BBoxMake(-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924)];
    [layer setMapResolution:CGSizeMake(536870912, 536870912)];
    
    if (layer.georeferencingType == 2)
	{
		//construct coordinates from bounding box		
		[layer setGeoreferencingType:1];
		[layer setNumberOfPoints:4];
		
		NSMutableArray *tmpPixelArray = [[NSMutableArray alloc] init];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.mapResolution.width, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, layer.mapResolution.height)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.mapResolution.width, layer.mapResolution.height)]];
		[layer setPixelPoints:tmpPixelArray];
		[tmpPixelArray release];
		
		NSMutableArray *tmpCoordArray = [[NSMutableArray alloc] init];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.minX, layer.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.maxX, layer.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.minX, layer.boundingBox.minY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.maxX, layer.boundingBox.minY)]];
		[layer setCoordinatePoints:tmpCoordArray];
		[tmpCoordArray release];		
	}
    
    [layer setInfoSRS:@"+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +units=m +no_defs"];    
    [layer setInfoType:@"web"];
    NSArray *infoAddressArray = [[NSArray alloc] initWithObjects:@"http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", @"round({selectedcoord.x})", @"round({selectedcoord.y})", nil];
    [layer setInfoAddress:infoAddressArray];
    [infoAddressArray release];
    

    return [layer autorelease];
}








/*
 {
 "title":"Katastr - mapy",
 "typeOfService":"TMS",
 
 "address":["http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
 "{tileLU.x}", 
 "{tileRB.y}", 
 "{tileRB.x}", 
 "{tileLU.y}"],
 
 
 "visibleFromLevel":17,
 "visibleToLevel":22,
 "addressSRS":"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs",
 
 "minLevel":1,
 "maxLevel":21,
 "deltaLevel":1,
 "tileResolution":[256, 256],
 "mapResolution":[536870912, 536870912],
 
 "alphaLock":true,
 
 "projectionKey":"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs",			
 
 "georeferencingType":2,	
 "boundingBox":[-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924],
 
 
 
 
 
 "infoSRS":"+proj=krovak +lat_0=49.5 +lon_0=42.5 +alpha=30.28813972222222 +k=0.9999 +x_0=-0 +y_0=-0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro +to_meter=-1 +no_defs",
 "infoAddress":["http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", 
 "round(-{selectedcoord.x})", 
 "round(-{selectedcoord.y})"],
 "infoType":"web"
 }
*/
- (MapSourceDefinition*) buildDefaultConfiguration2
{
    MapSourceDefinition *layer = [[MapSourceDefinition alloc] init];
    
    
    [layer setTitle:@"CUZK - Katastr"];
    [layer setTypeOfService:@"TMS"];
    NSArray *addressArray = [[NSArray alloc] initWithObjects:
                                    @"http://wms.cuzk.cz/wms.asp?REQUEST=GetMap&SERVICE=wms&VERSION=1.1.1&SRS=EPSG:4326&WIDTH=256&HEIGHT=256&FORMAT=image/png&BBOX=%@,%@,%@,%@&LAYERS=KN&TRANSPARENT=TRUE", 
                                    @"{tileLU.x}", 
                                    @"{tileRB.y}", 
                                    @"{tileRB.x}", 
                                    @"{tileLU.y}",
                                    nil
                             ];
    [layer setAddress:addressArray]; 
    [addressArray release];
    [layer setAddressSRS:@"+proj=latlong +ellps=WGS84 +towgs84=0,0,0 +nodefs"];    
    
    [layer setMinLevel:1];
    [layer setMaxLevel:21];
    [layer setDeltaLevel:1];
    
    [layer setVisibleFromLevel:17];
    [layer setVisibleToLevel:21];    
    
    [layer setTileResolution:CGSizeMake(256, 256)];
    //[layer setAlpha:0.5];
    [layer setAlphaLock:YES];
    [layer setProjectionKey:@"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"];
    [layer setGeoreferencingType:2];
    [layer setBoundingBox:BBoxMake(-20037508.34278924,-20037508.34278924,20037508.34278924,20037508.34278924)];
    [layer setMapResolution:CGSizeMake(536870912, 536870912)];
    
    if (layer.georeferencingType == 2)
	{
		//construct coordinates from bounding box		
		[layer setGeoreferencingType:1];
		[layer setNumberOfPoints:4];
		
		NSMutableArray *tmpPixelArray = [[NSMutableArray alloc] init];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.mapResolution.width, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, layer.mapResolution.height)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.mapResolution.width, layer.mapResolution.height)]];
		[layer setPixelPoints:tmpPixelArray];
		[tmpPixelArray release];
		
		NSMutableArray *tmpCoordArray = [[NSMutableArray alloc] init];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.minX, layer.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.maxX, layer.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.minX, layer.boundingBox.minY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(layer.boundingBox.maxX, layer.boundingBox.minY)]];
		[layer setCoordinatePoints:tmpCoordArray];
		[tmpCoordArray release];		
	}
    
    [layer setInfoSRS:@"+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +units=m +no_defs"];    
    [layer setInfoType:@"web"];
    NSArray *infoAddressArray = [[NSArray alloc] initWithObjects:@"http://nahlizenidokn.cuzk.cz/MapaIdentifikace.aspx?l=KN&x=%@&y=%@", @"round({selectedcoord.x})", @"round({selectedcoord.y})", nil];
    [layer setInfoAddress:infoAddressArray];
    [infoAddressArray release];
    
    
    return [layer autorelease];
}


@end
