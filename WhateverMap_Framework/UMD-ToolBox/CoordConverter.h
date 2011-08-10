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

#import "typeDefinitions.h"

@class MapSourceDefinition;

@interface CoordConverter : NSObject {
	MapSourceDefinition* mapSource;
}

@property (nonatomic, retain) MapSourceDefinition* mapSource;

- (id) initWithDefinition:(MapSourceDefinition*)definition;



//////////////////////////
//LONLAT -> COORD -> PIXEL
- (CGPoint) convertLatLonToPixel:(LatLon)latLon zoom:(double)zoomLevel; //lon/lat -> pixel  
- (CGPoint) convertCoordToPixel:(CGPoint)coord zoom:(double)zoomLevel;  //coordination system of map -> pixel  
- (CGPoint) convertCoordToPixel:(CGPoint)coord zoom:(double)zoomLevel inFormat:(NSString*)format;  //specified coordination system -> pixel

- (CGPoint) convertCoordToPixel:(CGPoint)coord zoom:(double)zoomLevel;
- (CGPoint) convertLatLonToCoord:(LatLon)latLon;
- (CGPoint) convertLatLonToPixelRelative:(LatLon)latLon;
- (CGPoint) convertCoordToPixelRelative:(CGPoint)coord;
- (CGPoint) convertCoord:(CGPoint)coord inFormat:(NSString*)format;


//////////////////////////
//PIXEL -> COORD -> LONLAT
- (LatLon) convertPixelToLatLon:(CGPoint)pixel zoom:(double)zoomLevel; //pixel -> lon/lat
- (CGPoint) convertPixelToCoord:(CGPoint)pixel zoom:(double)zoomLevel; //pixel -> coordination system of map
- (CGPoint) convertPixelToCoord:(CGPoint)pixel zoom:(double)zoomLevel toFormat:(NSString*)format; //pixel -> specified coordination system

- (CGPoint) convertPixelToCoordRelative:(CGPoint) relativePixel;
- (LatLon) convertCoordToLatLon:(CGPoint)coord;
- (CGPoint) convertCoord:(CGPoint)coord toFormat:(NSString*)format;



- (NSInteger) mapSize:(NSInteger)levelOfDetail;
- (double) clipNumber:(double)number MinValue:(double)minValue MaxValue:(double)maxValue;


@end
