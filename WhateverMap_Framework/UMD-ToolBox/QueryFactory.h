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

@class MapSourceDefinition;

@interface QueryFactory : NSObject {
	CGPoint selectedPixel;
	CGPoint offset;
	double zoomScale;
	MapSourceDefinition *mapSource;	
	CGRect frame;
	CGRect bounds;
	UIEdgeInsets contentInset;
	CGPoint contentOffset;
	NSInteger maxCol;
	NSInteger maxRow;
	BOOL selectedPointIsPixel;
}

@property (nonatomic, retain) MapSourceDefinition *mapSource;	
@property (assign) CGPoint selectedPixel;
@property (assign) CGPoint offset;
@property (assign) CGRect frame;
@property (assign) CGRect bounds;
@property (assign) double zoomScale;
@property (assign) UIEdgeInsets contentInset;
@property (assign) CGPoint contentOffset;
@property (assign) NSInteger maxCol;
@property (assign) NSInteger maxRow;


//INITILALIZATION
- (id) initWithDefinition:(MapSourceDefinition*)definition;
- (id) initWithDefinition:(MapSourceDefinition*)definition selectedPixel:(CGPoint)selectedPoint; 
- (id) initWithDefinition:(MapSourceDefinition*)definition selectedPixel:(CGPoint)selectedPoint offset:(CGPoint)offsetPoint inset:(UIEdgeInsets)contentInsetValue contentOffset:(CGPoint)contentOffsetvalue zoomScale:(double)zoom maxColumn:(NSInteger)maxColValue maxRow:(NSInteger)maxRowValue;
- (id) initWithDefinition:(MapSourceDefinition*)definition selectedLonLat:(CGPoint)selectedPoint; 
- (id) initWithDefinition:(MapSourceDefinition*)definition selectedLonLat:(CGPoint)selectedPoint offset:(CGPoint)offsetPoint inset:(UIEdgeInsets)contentInsetValue contentOffset:(CGPoint)contentOffsetvalue zoomScale:(double)zoom maxColumn:(NSInteger)maxColValue maxRow:(NSInteger)maxRowValue;


- (NSString*) buildQueryFromArray:(NSArray*)mapSourceAddressArray WithZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row inCoordinateSystem:(NSString*) coordSystem;
- (BOOL) findKeyWordAndReplace:(NSString**) expression WithZoom:(NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row  inCoordinateSystem:(NSString*) coordSystem;
- (NSString*) TileXYToQuadKeyforTileX:(NSInteger) tileX tileY:(NSInteger) tileY level:(NSInteger) levelOfDetail;
- (NSString*) convertDec2Hex: (NSInteger)decNumber;
- (NSString *)convertDec2Bin:(NSInteger)input;


@end
