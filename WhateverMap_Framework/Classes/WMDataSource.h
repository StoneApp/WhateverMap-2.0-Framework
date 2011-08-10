//
//  WMDataSource.h
//  WhateverMap_2
//
//  Created by Jirka on 13.7.11.
//  Copyright 2011 Mendel University in Brno. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapSourceDefinition;

@interface WMDataSource : NSObject {
    
    NSMutableArray *mapLayers;
}


- (id) init;
- (id) initWithDefaultDefinition;

- (NSArray*) getLayers;
- (BOOL) addLayer:(MapSourceDefinition*)layer;
- (BOOL) insertLayer:(MapSourceDefinition*)layer AtIndex:(int)index;
- (BOOL) updateLayerAtIndex:(int)layerIndex byLayer:(MapSourceDefinition*)layer;
- (int) getNumberOfLayers;
- (MapSourceDefinition*) getLayerAtIndex: (int) layerIndex;

@end
