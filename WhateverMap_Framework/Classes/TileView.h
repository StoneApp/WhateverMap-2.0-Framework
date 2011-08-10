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

#import "MapSource.h"
//@protocol MapSourceDelegate;
@class TileObject;


//tile view represent single tiles in a scrollview - it perform loading of image from URL or storing of it in right directory
@interface TileView : UIImageView <MapSourceDelegate>{
	NSMutableData *data;
	NSURLConnection *dataConnection;
	
	NSInteger actualZoom;
	NSInteger actualColumn;
	NSInteger actualRow;
    NSInteger actualLayer;
	
	NSString *path;
	
	BOOL isLoading;
    int numberOfTries;
	
	NSInteger nodeIndex;
	NSInteger layerIndex;
	
	NSString *tileDirectory;
    
}

@property (retain) NSString *path;
@property (assign) NSInteger actualZoom;
@property (assign) NSInteger actualColumn;
@property (assign) NSInteger actualRow;
@property (assign) NSInteger actualLayer;
@property (nonatomic, retain) TileObject *currentTileObj;


- (void) loadTile:(TileObject*)tileObj;
- (void) loadTile:(NSInteger)zoom column:(NSInteger)column row:(NSInteger)row layerPosition:(NSInteger)posIndex;
- (void) stopLoading;
- (void) cleanTile;
- (void) setLoadingTileImage;
+ (void) resetConnections;
- (void) finishTask;
- (void) tileBlockOffline;
- (void) finishTaskNoTile;
- (NSString*) getDescription;
- (void) showTileImage:(NSData*)imageData;
- (void) loadTileOffline;
- (void) increaseConnectionNumber;
- (void) decreaseConnectionNumber;
- (void) startAddressGenerating;

@end
