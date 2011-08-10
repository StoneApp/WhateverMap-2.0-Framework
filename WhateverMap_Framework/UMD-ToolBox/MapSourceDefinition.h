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

#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>
//#import <CoreGraphics/CGGeometry.h>
#import "typeDefinitions.h"





@interface MapSourceDefinition : NSObject {
	NSString *title; //title name of specified map source	
	NSString *typeOfService; //WMS, some tiling system, WFS and so on
	NSArray *address; //address of service  address + keyword as column, columInverse, row, rowInverse, loadBalnce, zoom, zoomInverse, quadKey
	NSString *addressSRS;
	
	//TILE SYSTEM
	//zoom, X, Y, loadBalance 
	NSString *projectionKey; //UTM basic - it should correspont to proj.4 projection keys
	BBox boundingBox; //Bounding box of map
 	//tilesOfFirstLevel;
	CGSize mapResolution; //resolution of whole map
	CGSize tileResolution; //resolution of tile of map e.g. 256x256
	//NSInteger numberOfLevels; //number of levels in map
	NSInteger minLevel; //minimum level in map
	NSInteger maxLevel; //minimum level in map
	NSInteger deltaLevel; //difference between levels - 1=each level is present, 2=each second level is not in map ...
	
	//WMS SERVICE
	NSString *projectionSystem;
	NSString *layers;
	
	NSInteger georeferencingType;
	
	//geoReferencingType 0
	NSString *coordToPixelX;
	NSString *coordToPixelY;
	NSString *pixelToCoordX;
	NSString *pixelToCoordY;
	
	
	//geoReferencingType 1
	NSArray *pixelPoints;
	NSArray *coordinatePoints;
	
	NSInteger numberOfPoints;
	
	
	NSInteger visibleFromLevel;
	NSInteger visibleToLevel;
	BOOL visible;
	
	float alpha;
	BOOL alphaLock;
	
	
	//TMS
	CGPoint origin;
	NSArray *levels;
	
	//just for application needs
	NSArray *levelsResolution;
	
	
	
	NSString *infoSRS;
	NSString *infoType;
	NSArray *infoAddress;
}




@property(nonatomic, retain) NSString *title; //title name of specified map source	
@property(nonatomic, retain) NSString *typeOfService; //WMS, some tiling system, WFS and so on
@property(nonatomic, retain) NSArray *address; //address of service  address + keyword as column, columInverse, row, rowInverse, loadBalnce, zoom, zoomInverse, quadKey
@property(nonatomic, retain) NSString *addressSRS;

//TILE SYSTEM
//zoom, X, Y, loadBalance 
@property(nonatomic, retain) NSString *projectionKey; //UTM basic - it should correspont to proj.4 projection keys
@property(assign) BBox boundingBox; //Bounding box of map
//tilesOfFirstLevel;
@property(assign) CGSize mapResolution; //resolution of whole map
@property(assign) CGSize tileResolution; //resolution of tile of map e.g. 256x256
//NSInteger numberOfLevels; //number of levels in map
@property(assign) NSInteger minLevel; //minimum level in map
@property(assign) NSInteger maxLevel; //minimum level in map
@property(assign) NSInteger deltaLevel; //difference between levels - 1=each level is present, 2=each second level is not in map ...

//WMS SERVICE
@property(nonatomic, retain) NSString *projectionSystem;
@property(nonatomic, retain) NSString *layers;

@property(assign) NSInteger georeferencingType;

//geoReferencingType 0
@property(nonatomic, retain) NSString *coordToPixelX;
@property(nonatomic, retain) NSString *coordToPixelY;
@property(nonatomic, retain) NSString *pixelToCoordX;
@property(nonatomic, retain) NSString *pixelToCoordY;


//geoReferencingType 1
@property(nonatomic, retain) NSArray *pixelPoints; 
@property(nonatomic, retain) NSArray *coordinatePoints;

@property(assign) NSInteger numberOfPoints;


@property(assign) NSInteger visibleFromLevel;
@property(assign) NSInteger visibleToLevel;
@property(assign) BOOL visible;

@property(assign) float alpha;
@property(assign) BOOL alphaLock;


//TMS
@property(assign) CGPoint origin;
@property(nonatomic, retain) NSArray *levels;

//just for application needs
@property(nonatomic, retain) NSArray *levelsResolution;



@property(nonatomic, retain) NSString *infoSRS;
@property(nonatomic, retain) NSString *infoType;
@property(nonatomic, retain) NSArray *infoAddress;




/*
@property(copy) NSString *title; //title name of specified map source	
@property(copy) NSString *typeOfService; //WMS, some tiling system, WFS and so on
@property(copy) NSArray *address; //address of service  address + keyword as column, columInverse, row, rowInverse, loadBalnce, zoom, zoomInverse, quadKey
@property(copy) NSString *addressSRS;

//TILE SYSTEM
//zoom, X, Y, loadBalance 
@property(copy) NSString *projectionKey; //UTM basic - it should correspont to proj.4 projection keys
@property(assign) BBox boundingBox; //Bounding box of map
//tilesOfFirstLevel;
@property(assign) CGSize mapResolution; //resolution of whole map
@property(assign) CGSize tileResolution; //resolution of tile of map e.g. 256x256
//NSInteger numberOfLevels; //number of levels in map
@property(assign) NSInteger minLevel; //minimum level in map
@property(assign) NSInteger maxLevel; //minimum level in map
@property(assign) NSInteger deltaLevel; //difference between levels - 1=each level is present, 2=each second level is not in map ...

//WMS SERVICE
@property(copy) NSString *projectionSystem;
@property(copy) NSString *layers;

@property(assign) NSInteger georeferencingType;

//geoReferencingType 0
@property(copy) NSString *coordToPixelX;
@property(copy) NSString *coordToPixelY;
@property(copy) NSString *pixelToCoordX;
@property(copy) NSString *pixelToCoordY;


//geoReferencingType 1
@property(copy) NSArray *pixelPoints; 
@property(copy) NSArray *coordinatePoints;

@property(assign) NSInteger numberOfPoints;


@property(assign) NSInteger visibleFromLevel;
@property(assign) NSInteger visibleToLevel;
@property(assign) BOOL visible;

@property(assign) float alpha;
@property(assign) BOOL alphaLock;


//TMS
@property(assign) CGPoint origin;
@property(copy) NSArray *levels;

//just for application needs
@property(copy) NSArray *levelsResolution;



@property(copy) NSString *infoSRS;
@property(copy) NSString *infoType;
@property(copy) NSArray *infoAddress;
*/


/*

 @property(retain) NSString *title; //title name of specified map source	
 @property(retain) NSString *typeOfService; //WMS, some tiling system, WFS and so on
 @property(retain) NSArray *address; //address of service  address + keyword as column, columInverse, row, rowInverse, loadBalnce, zoom, zoomInverse, quadKey
 @property(retain) NSString *addressSRS;
 
 //TILE SYSTEM
 //zoom, X, Y, loadBalance 
 @property(retain) NSString *projectionKey; //UTM basic - it should correspont to proj.4 projection keys
 @property(assign) BBox boundingBox; //Bounding box of map
 //tilesOfFirstLevel;
 @property(assign) CGSize mapResolution; //resolution of whole map
 @property(assign) CGSize tileResolution; //resolution of tile of map e.g. 256x256
 //NSInteger numberOfLevels; //number of levels in map
 @property(assign) NSInteger minLevel; //minimum level in map
 @property(assign) NSInteger maxLevel; //minimum level in map
 @property(assign) NSInteger deltaLevel; //difference between levels - 1=each level is present, 2=each second level is not in map ...
 
 //WMS SERVICE
 @property(retain) NSString *projectionSystem;
 @property(retain) NSString *layers;
 
 @property(assign) NSInteger georeferencingType;
 
 //geoReferencingType 0
 @property(retain) NSString *coordToPixelX;
 @property(retain) NSString *coordToPixelY;
 @property(retain) NSString *pixelToCoordX;
 @property(retain) NSString *pixelToCoordY;
 
 
 //geoReferencingType 1
 @property(retain) NSArray *pixelPoints; 
 @property(retain) NSArray *coordinatePoints;
 
 @property(assign) NSInteger numberOfPoints;
 
 
 @property(assign) NSInteger visibleFromLevel;
 @property(assign) NSInteger visibleToLevel;
 @property(assign) BOOL visible;
 
 @property(assign) float alpha;
 @property(assign) BOOL alphaLock;
 
 
 //TMS
 @property(assign) CGPoint origin;
 @property(retain) NSArray *levels;
 
 //just for application needs
 @property(retain) NSArray *levelsResolution;
 
 
 
 @property(retain) NSString *infoSRS;
 @property(retain) NSString *infoType;
 @property(retain) NSArray *infoAddress;
*/
@end
