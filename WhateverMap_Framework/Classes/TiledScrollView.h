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

@class TapDetectingView;
@class TileView;
@class PositionView;
@class ShakeView;
@class MapController;
@class WMDataSource;
@class WMMapView;

@protocol TiledScrollViewDataSource;


@interface TiledScrollView : UIScrollView <UIScrollViewDelegate> {

    WMMapView *mapView;
    id <TiledScrollViewDataSource>  dataSource;
    CGSize                          tileSize;
    TapDetectingView                *tileContainerView;
	ShakeView						*shakeView;
    NSMutableSet                    *reusableTiles;    

    int                              resolution;
    int                              maximumResolution;
    int                              minimumResolution;
	
	BOOL lockTileLoading;
	    
    // we use the following ivars to keep track of which rows and columns are visible
    int firstVisibleRow, firstVisibleColumn, lastVisibleRow, lastVisibleColumn;
	int actualFirstVisibleRow, actualFirstVisibleColumn, actualLastVisibleRow, actualLastVisibleColumn;
	
	NSArray *levelResolutions;
	
	NSInteger maxRow;
	NSInteger maxCol;
	
	PositionView *positionView;
	
	BOOL dirtyZoom;
	
	CGPoint relativePositionCenterPoint;
	float relativePositionDiameter;
}


@property (nonatomic, readonly) PositionView *positionView;
//@property (nonatomic, assign) MapController *mapController;
@property (nonatomic, assign) WMMapView *mapView;
@property (nonatomic, assign) id <TiledScrollViewDataSource> dataSource;
@property (nonatomic, assign) CGSize tileSize;
@property (nonatomic, readonly) TapDetectingView *tileContainerView;
@property (nonatomic, readonly) ShakeView *shakeView;
@property (nonatomic, assign) int minimumResolution;
@property (nonatomic, assign) int maximumResolution;
@property (nonatomic, assign) int resolution;
@property (nonatomic, retain) NSArray *levelResolutions;
@property (nonatomic, assign) NSInteger maxRow;
@property (nonatomic, assign) NSInteger maxCol;
@property (nonatomic, assign) BOOL dirtyZoom;  //if zooming layoutSubView is calling before it - this property is sign for this and first layout subview is not called
@property (nonatomic, assign) BOOL lockTileLoading;


- (void)setZoomScaleRelativeSafe:(double)scale;
- (void)setZoomScaleAbsoluteSafe:(double)scale;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

- (void) setHidePositionView;
- (void) setPositionViewRelative:(CGPoint)relativeLocationPoint withDiameter:(float)relativeDiameter;
- (void) setShowPositionView;
- (void) removeTilesFromNonActualZoomLevel;
- (void) removeAllTiles;
- (void) removeNonVisibleTiles;
- (void)reloadData;
- (void) clearReusableTile;
- (void)reloadDataWithNewContentSize:(CGSize)size;
- (TileView *)dequeueReusableTile;  // Used by the delegate to acquire an already allocated tile, in lieu of allocating a new one.

- (void) performLayoutAction;

- (void) addPositionView;
@end


@protocol TiledScrollViewDataSource <NSObject>
- (TileView *)tiledScrollView:(TiledScrollView *)scrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex;
- (TileView *)tiledScrollViewEmpty:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex;
- (WMDataSource*)wmDataSource;
@end








//////////////////////////////
/*
 tile view
 
 
                Column
         ------------------------------>
         |0,0
		 |
		 |
		 |
Row		 |
		 |
		 |
		 |
		 |
		 |
		 |                           10,10
*/