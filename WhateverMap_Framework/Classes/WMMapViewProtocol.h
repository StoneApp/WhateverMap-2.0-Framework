//
//  WMMapViewProtocol.h
//  WhateverMap_2
//
//  Created by Jirka on 11.7.11.
//  Copyright 2011 Mendel University in Brno. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>


@protocol WMMapViewProtocol <NSObject>

@required

- (void) setPositionPointer:(LatLon)latlon withDiameterInMeters:(float)diameterInMeters;
- (void) setPositionPointer:(LatLon)latlon withDiameterInDegree:(float)diameterInDegree;


- (void) goToLonLat:(LatLon)latLon WithDegreeDelta:(CGSize)deltaInDegree animated:(BOOL)animated;
- (void) goToLonLat:(LatLon)latLon WithDistanceDelta:(CGSize)deltaInDistance animated:(BOOL)animated;

- (void) goToLonLat:(LatLon)latlon animated:(BOOL)animated;
- (void) goToPixel:(CGPoint)pixel animated:(BOOL)animated;

- (void) zoomToScale:(double)scale animated:(BOOL)animated;
- (void) zoomToLevel:(double)level animated:(BOOL)animated;
- (void) zoomToLevelRelative:(double)level animated:(BOOL)animated;
- (void) zoomToScaleRelative:(double)scale animated:(BOOL)animated;
- (void) zoomToDegreeDelta:(CGSize)degreeDelta animated:(BOOL)animated;
- (void) zoomToDistanceDelta:(CGSize)distanceDelta animated:(BOOL)animated;


- (void) didUserInteract;

- (void) showPositionView;



@end
