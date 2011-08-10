//
//  MapView.h
//  WhateverMap_2
//
//  Created by Jirka on 9.7.11.
//  Copyright 2011 Mendel University in Brno. All rights reserved.
//



#import "typeDefinitions.h"
#import "WMMapViewProtocol.h"
#import "TiledScrollView.h"
#import "TapDetectingView.h"

@class TileView;
@class WMDataSource;

@interface WMMapView : UIView <TiledScrollViewDataSource, TapDetectingViewDelegate, WMMapViewProtocol> {
    TiledScrollView *imageScrollView;
    WMDataSource *wmDataSource;
    id mapDelegate;
    BOOL compassFeatureEnabled;
    float angleOfRotation;
}

@property (nonatomic, retain) WMDataSource *wmDataSource;


//INIT
- (void) initTiledView;
- (void) showMap;
- (void) pickImageNamed:(NSString *)name;
- (void) reloadMap;
- (void) setMapDelegate:(id)delegate;


//MAP MOVEMENT
- (void) goToLonLat:(LatLon)latLon WithDegreeDelta:(CGSize)deltaInDegree animated:(BOOL)animated;
- (void) goToLonLat:(LatLon)latLon WithDistanceDelta:(CGSize)deltaInDistance animated:(BOOL)animated;
- (void) goToLonLat:(LatLon)latLon AtLevel:(double)level animated:(BOOL)animated;
- (void) goToPixel:(CGPoint)pixel AtLevel:(double)level animated:(BOOL)animated;
- (void) goToLonLat:(LatLon)latlon animated:(BOOL)animated;
- (void) goToPixel:(CGPoint)pixel animated:(BOOL)animated;
- (void) zoomToLevel:(double)level animated:(BOOL)animated;
- (void) zoomToDegreeDelta:(CGSize)degreeDelta animated:(BOOL)animated;
- (void) zoomToDistanceDelta:(CGSize)distanceDelta animated:(BOOL)animated;
- (void) zoomToLevelRelative:(double)level animated:(BOOL)animated;
- (void) zoomToScaleRelative:(double)scale animated:(BOOL)animated;
- (void) zoomToScale:(double)scale animated:(BOOL)animated;
- (double) getZoomLevel;
- (int) getLevel;
- (CGPoint) getPixel;
- (LatLon) getLonLat;


//INTERACTION
- (void) isMovedDragging;
- (void) didUserInteract;
- (void) didZoomEnded;
- (void) willBeginDragging;
- (void) didEndDragging;
- (void) didTapAtPoint:(CGPoint) point;

//POSITION VIEW
- (void) showPositionView;
- (void) hidePositionView;
- (void) setPositionPointer:(CGPoint)relativePixelPoint withDiameteRelative:(float)pixelDiameter;
- (void) setPositionPointer:(LatLon)latlon withDiameterInDegree:(float)diameterInDegree;
- (void) setPositionPointer:(LatLon)latlon withDiameterInMeters:(float)diameterInMeters;


//MEMORY OPTIMALIZATION
- (void) removeAllTiles;
- (void) removeTilesFromNonActualZoomLevel;
- (void) clearReusableTile;
- (void) reloadMap;


//COMPASS FEATURES
- (void) setMapRotation:(double)rotationAngle;
- (void) disableCompassFeature;
- (void) enableCompassFeature;

 
@end






@protocol WMMapViewDelegate

@optional

//INTERACTION
- (void) isMovedDragging;
- (void) didUserInteract;
- (void) didZoomEnded;
- (void) willBeginDragging;
- (void) didEndDragging;
- (void) didTapAtPoint: (CGPoint) point;
- (void) didTapAtLonLat: (LatLon) latLon;

@required

@end
