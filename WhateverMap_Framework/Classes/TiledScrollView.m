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

#import <QuartzCore/QuartzCore.h>
#import "TiledScrollView.h"
#import "TapDetectingView.h"
#import "constants.h"
#import "TileView.h"
//#import "SourceData.h"
//#import "MapController.h"
#import "typeDefinitions.h"
#import "PositionView.h"
#import "MapSourceDefinition.h"
#import "TileDispatcher.h"
#import "WMDataSource.h"
#import "WMMapView.h"



@interface TiledScrollView ()
- (void)annotateTile:(TileView *)tile;
- (void)updateResolution;
- (void)changeZoom:(NSInteger)delta;
- (void)setZoomScale:(float)scale animated:(BOOL)animated;
- (void)setZoomLevel:(int)newResolution;
- (void)loadTileIfMissingIn:(NSValue*)tileValue;
- (void)loadTileIfMissingInRow: (int)row Column:(int)col;


- (void) rescaleTile:(TileView*)tile;
- (CGSize) getSizeInTiles;
- (void) removeNonVisibleTiles;
- (void) removeTile:(TileView*)tile;

//PositionView
- (void) setPositionView:(CGPoint)locationPoint withDiameter:(float)diameter;
- (void) updatePositionView;

- (void) stopLoadingData;
@end




/////////////////////
//IMPLEMENTATION


@implementation TiledScrollView

@synthesize mapView;
@synthesize tileSize;
@synthesize tileContainerView;
@synthesize shakeView;
@synthesize dataSource;
@dynamic minimumResolution;
@dynamic maximumResolution;
@synthesize resolution;
@synthesize levelResolutions;
@synthesize maxRow;
@synthesize maxCol;
@synthesize dirtyZoom;
@synthesize lockTileLoading;
@synthesize positionView;


- (id)initWithFrame:(CGRect)frame 
{	
    self = [super initWithFrame:frame];
    if (self) 
	{
		//deceleration - movement on map will continue after touch release
		self.decelerationRate = UIScrollViewDecelerationRateFast; //UIScrollViewDecelerationRateNormal
		
		self.dirtyZoom = FALSE;
		lockTileLoading = FALSE;
        [self setScrollsToTop:NO];
		
        // we will recycle tiles by removing them from the view and storing them here
        reusableTiles = [[NSMutableSet alloc] init];

//		shakeView = [[ShakeView alloc] initWithFrame:CGRectZero];		
//		[self addSubview:shakeView];

		
        // we need a tile container view to hold all the tiles. This is the view that is returned
        // in the -viewForZoomingInScrollView: delegate method, and it also detects taps.
        tileContainerView = [[TapDetectingView alloc] initWithFrame:CGRectZero];
		[self addSubview:tileContainerView];
		
		
		//color of background 
		[tileContainerView setBackgroundColor:MAP_BACKGROUND_COLOR]; //[UIColor whiteColor] blackColor		

#ifdef HIDE_SCROLLERS		
		[self setShowsHorizontalScrollIndicator:NO];
		[self setShowsVerticalScrollIndicator:NO];
#endif		
		
		
#ifdef POSITION_VIEW		
		[self addPositionView];
#endif

        // no rows or columns are visible at first; note this by making the firsts very high and the lasts very low
        firstVisibleRow = firstVisibleColumn = NSIntegerMax;
        lastVisibleRow  = lastVisibleColumn  = NSIntegerMin;
                
        // the TiledScrollView is its own UIScrollViewDelegate, so we can handle our own zooming.
        // We need to return our tileContainerView as the view for zooming, and we also need to receive
        // the scrollViewDidEndZooming: delegate callback so we can update our resolution.
        [super setDelegate:self];
    }
    return self;
}




// we don't synthesize our minimum/maximum resolution accessor methods because we want to police the values of these ivars
- (int)minimumResolution 
{ 
	return minimumResolution; 
}


- (int)maximumResolution 
{ 
	return maximumResolution; 
}


- (void)setMinimumResolution:(int)res 
{ 
	minimumResolution = MIN(res, 0); // you can't have a minimum resolution greater than 0
} 


- (void)setMaximumResolution:(int)res 
{ 
	maximumResolution = MAX(res, 0); // you can't have a maximum resolution less than 0
} 


//reuse tile - improve performace of releasing and reallocing of new tile
- (TileView *)dequeueReusableTile 
{
    TileView *tile = [[reusableTiles anyObject] retain];
    if (tile) {
        // the only object retaining the tile is our reusableTiles set, so we have to retain/autorelease it
        // before returning it so that it's not immediately deallocated when we remove it from the set		
        //[[tile retain] autorelease];
        [reusableTiles removeObject:tile];
		[tile setTransform:CGAffineTransformIdentity];
    }
    return [tile autorelease];
}

- (void) clearReusableTile 
{
    [reusableTiles removeAllObjects];
}

//reload data
- (void)reloadData 
{
   // recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (id tile in [tileContainerView subviews]) 
	{
		[self removeTile:tile];
    }
    
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
    firstVisibleRow = firstVisibleColumn = NSIntegerMax;
    lastVisibleRow  = lastVisibleColumn  = NSIntegerMin;
    
    [self setNeedsLayout]; //TODO do we really need it here?
}


- (void)rescaleData 
{
    // recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (TileView *tile in [tileContainerView subviews]) 
	{
		if ([tile isKindOfClass:[TileView class]])
		{
#ifdef MAX_ZOOM_DIFFERENCE		
			if ([tile frame].size.width < ([self tileSize].width*MAX_ZOOM_DIFFERENCE) && [tile frame].size.width >([self tileSize].width/MAX_ZOOM_DIFFERENCE)) 
#endif			
			{
                [self rescaleTile:tile];
			}
		}
    }
	
	firstVisibleRow = firstVisibleColumn = NSIntegerMax;
    lastVisibleRow  = lastVisibleColumn  = NSIntegerMin;
	//[self setNeedsLayout]; //TODO do we really need it here?
}


- (void) rescaleTile:(TileView*)tile
{
	int oldColumn = [tile actualColumn];
	int oldRow = [tile actualRow];	
	int oldZoom = [tile actualZoom];
	int newZoom = [self resolution];
	
	//scale factor for scale transform of tiles
	int zoomDiff = newZoom - oldZoom;
	double scaleFactor = pow(2, zoomDiff);	
	
	double col = oldColumn*scaleFactor;// * scaleFactor2;
	double row = oldRow*scaleFactor;// * scaleFactor2;

	//set new position and scale to tile (set new frame)
	[tile setTransform:CGAffineTransformMakeScale(scaleFactor, scaleFactor)];
		
	CGRect frame = CGRectMake(([self tileSize].width * col), ([self tileSize].height * row), [self tileSize].width * scaleFactor, [self tileSize].height * scaleFactor);
	[tile setFrame:frame];	
}

//reload data with new content
- (void)reloadDataWithNewContentSize:(CGSize)size 
{    
    // since we may have changed resolutions, which changes our maximum and minimum zoom scales, we need to 
    // reset all those values. After calling this method, the caller should change the maximum/minimum zoom scales
    // if it wishes to permit zooming.
    
    //[self setZoomScale:1.0]; //good for one map with more level - bad for map with different level when this is called for each level
	[self setMinimumZoomScale:MIN_SCALE_FOR_LEVEL];
    [self setMaximumZoomScale:MAX_SCALE_FOR_LEVEL];
    
    // now that we've reset our zoom scale and resolution, we can safely set our contentSize. 
    [self setContentSize:size];
	    
    // we also need to change the frame of the tileContainerView so its size matches the contentSize
    //[tileContainerView setFrame:CGRectMake(0, 0, size.width, size.height)]; //done in updateResolution
    
#ifndef KEEP_OLD_LEVELS
    [self reloadData];
#endif	
}


/***********************************************************************************/
/* Most of the work of tiling is done in layoutSubviews, which we override here.   */
/* We recycle the tiles that are no longer in the visible bounds of the scrollView */
/* and we add any tiles that should now be present but are missing.                */
/***********************************************************************************/
- (void)layoutSubviews 
{
	//should be only here for reolution change
	//[self performSelector:@selector(updatePositionView)];
		
	//zoomto rect call layout subwiew sometime it is not necessary
	if (dirtyZoom)
	{
		dirtyZoom = FALSE;
		return;
	}
	
    [super layoutSubviews];
    
	//[self removeNonVisibleTiles];

    //[self performSelector:@selector(performLayoutAction) withObject:nil afterDelay:0.02]; //problem with first view
    [self performLayoutAction]; //ook in first view
}


- (void) performLayoutAction
{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	

    
    if (lockTileLoading)
    {      
		return;
    }
    
    // calculate which rows and columns are visible by doing a bunch of math.
    double scaledTileWidth  = (float)[self tileSize].width  * [self zoomScale];
    double scaledTileHeight = (float)[self tileSize].height * [self zoomScale];
    
	double maxRowF = ([tileContainerView frame].size.height / (double)scaledTileHeight); // this is the maximum possible row
	double maxColF = ([tileContainerView frame].size.width  / (double)scaledTileWidth);  // and the maximum possible column
    
#ifdef	DEBUG
    //NSLog(@"maxRow, MaxColumn: %f, %f", maxRowF, maxColF);
#endif	
	
	//NSInteger maxRow; // this is the maximum possible row
	//NSInteger maxCol;  // and the maximum possible column
	if (maxRowF - trunc(maxRowF) < TILE_PRECISION)
	{
		maxRow = floorf(maxRowF);
	}
	else 
	{
		maxRow = ceilf(maxRowF);
	}
    
	if (maxColF - trunc(maxColF) < TILE_PRECISION)
	{
		maxCol = floorf(maxColF);
	}
	else 
	{
		maxCol = ceilf(maxColF);
	}
	maxRow--;
	maxCol--;
	
#ifdef LOG_TEXT	
	//NSLog(@"rounded maxRow, MaxColumn: %d, %d", maxRow, maxCol);
#endif	
	
	CGRect visibleBounds = [self bounds];
    int firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / scaledTileHeight));
    int firstNeededCol = MAX(0, floorf(visibleBounds.origin.x / scaledTileWidth));
    int lastNeededRow  = MIN(maxRow, floorf(CGRectGetMaxY(visibleBounds) / scaledTileHeight));
    //int lastNeededCol  = MIN(maxCol, floorf(CGRectGetMaxX(visibleBounds) / scaledTileWidth));	
    int lastNeededCol  = MIN(maxCol, floorf(CGRectGetMaxX(visibleBounds) / scaledTileWidth));	
	
	// update our record of which rows/cols are visible
    actualFirstVisibleRow = firstNeededRow; actualFirstVisibleColumn = firstNeededCol;
    actualLastVisibleRow  = lastNeededRow;  actualLastVisibleColumn  = lastNeededCol;            
	
	
#ifdef LOG_TEXT	
	//NSLog(@"Last needed Row, Column: %d, %d", lastNeededRow, lastNeededCol);
#endif
	
	
	
    
    
    
#ifdef OPTIMALIZED_TILE_LOADING
    //////////////////////////////////	
    //OPTIMALIZED TILE LOADING
	//load center tile first then continue in spiral way 
	
	//determine tile located in center of the screen
	//determine number of tiles in the border
	int deltaCol = lastNeededCol - firstNeededCol + 1;
	int deltaRow = lastNeededRow - firstNeededRow + 1;
	
	int middleTileRow, middleTileColumn;	
	middleTileColumn = floorf(0.1+deltaCol*0.5);
	middleTileRow = floorf(0.1+deltaRow*0.5);
	
	middleTileRow += firstNeededRow;
	middleTileColumn += firstNeededCol;
	
#ifdef LOG_TEXT	
	NSLog(@"MIN MAX ROW %d, %d", firstNeededRow, lastNeededRow);
	NSLog(@"MIN MAX COL %d, %d", firstNeededCol, lastNeededCol);
	NSLog(@"MIDDLE COL ROW %d, %d", middleTileColumn, middleTileRow);
#endif	
	
	int row = middleTileRow;
	int col = middleTileColumn;
	
	int addCol = 0;
	int addRow = 1;
	
	int borderCol, borderRow;
	
	//go from the center in spiral way and load tiles if it is needed
	//while (deltaCol > addCol && deltaRow > addRow) 
	while (!((col < firstNeededCol || col > lastNeededCol) && (row < firstNeededRow || row > lastNeededRow)))
	{
		borderCol = col + addCol++; 
		while (col < borderCol)
		{
			[self loadTileIfMissingInRow:row Column:col];
			col++;
		}
		
		borderRow = row - addRow++; 
		while (row > borderRow)
		{
			[self loadTileIfMissingInRow:row Column:col];	
			row--;
		}
        
		borderCol = col - addCol++; 
		while (col > borderCol)
		{
			[self loadTileIfMissingInRow:row Column:col];
			col--;
		}
        
		borderRow = row + addRow++; 
		while (row < borderRow)
		{
			[self loadTileIfMissingInRow:row Column:col];
			row++;
		}
	}
	
    //OPTIMALIZED TILE LOADING			
    //////////////////////////////////	
#else	
    //////////////////////////////////
    //NOT OPTIMALIZED_TILE_LOADING			
	//just single oading row by row from top-left corner
	// iterate through needed rows and columns, adding any tiles that are missing
	for (int row = firstNeededRow; row <= lastNeededRow; row++) 
	{
		for (int col = firstNeededCol; col <= lastNeededCol; col++) 
		{			
			NSValue *tileValue = [NSValue valueWithCGPoint:CGPointMake(col, row)]; 
			
			[self performSelectorOnMainThread:@selector(loadTileIfMissingIn:) withObject:tileValue waitUntilDone:YES];
        }
    }
    //NOT OPTIMALIZED_TILE_LOADING				
    //////////////////////////////////
#endif
    
	
	// update our record of which rows/cols are visible
    //firstVisibleRow = firstNeededRow; firstVisibleColumn = firstNeededCol;
    //lastVisibleRow  = lastNeededRow;  lastVisibleColumn  = lastNeededCol;            
    
    [self removeNonVisibleTiles];
    
    //[pool drain];
}


//recycle all tiles that are no longer visible
- (void) removeNonVisibleTiles
{
#ifdef LOG_TEXT
	NSLog(@"removeNonVisibleTiles");
#endif
	
	CGRect visibleBounds = [self bounds];
	CGFloat buffer = 0;
	if (buffer != 0)
	{
		visibleBounds = CGRectMake(visibleBounds.origin.x - buffer, 
									  visibleBounds.origin.y - buffer, 
									  visibleBounds.size.width + 2*buffer, 
									  visibleBounds.size.height + 2*buffer);
	}
		
	// first recycle all tiles that are no longer visible
    for (UIView *tile in [tileContainerView subviews]) 
	{
		if ([tile isKindOfClass:[TileView class]])
		{
			// We want to see if the tiles intersect our (i.e. the scrollView's) bounds, so we need to convert their
			// frames to our own coordinate system
			CGRect scaledTileFrame = [tileContainerView convertRect:[tile frame] toView:self];
			
			// If the tile doesn't intersect, it's not visible, so we can recycle it
			if (! CGRectIntersectsRect(scaledTileFrame, visibleBounds)) 
				[self removeTile:(TileView*)tile];
		}
    }
}



- (void) removeTilesFromNonActualZoomLevel
{
#ifdef LOG_TEXT
	NSLog(@"removeTilesFromNonActualZoomLevel");
#endif
	// first recycle all tiles that are no longer visible
    for (UIView *tile in [tileContainerView subviews]) 
	{
		if ([tile isKindOfClass:[TileView class]])
		{			
			if ([(TileView*)tile actualZoom] != resolution) 
				[self removeTile:(TileView*)tile];
		}
    }
}

- (void) removeAllTiles
{
#ifdef LOG_TEXT
	NSLog(@"removeAllTiles");
#endif
	// first recycle all tiles that are no longer visible
    for (UIView *tile in [tileContainerView subviews]) 
	{
		if ([tile isKindOfClass:[TileView class]])
		{			
            [self removeTile:(TileView*)tile];
		}
    }
}


- (void) removeTile:(TileView*)tile
{
	if ([tile isKindOfClass:[TileView class]])
	{
		for (id subTile in [tile subviews])			
			[self removeTile:subTile];

		[reusableTiles addObject:tile];
		[tile removeFromSuperview];
		[tile stopLoading];
		//[tile cleanTile];		
	}
}


- (void) loadTileIfMissingIn:(NSValue*)tileValue
{
	if (lockTileLoading)
		return;

	CGPoint tile = [tileValue CGPointValue];
	
	[self loadTileIfMissingInRow:tile.y Column:tile.x];
}


- (void) loadTileIfMissingOnThreadIn:(NSValue*)tileValue
{
	NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];	
	
	CGPoint tile = [tileValue CGPointValue];
	
	[self loadTileIfMissingInRow:tile.y Column:tile.x];
	
	[pool drain];
}




//load tile if mising - called from layoutSubViews - just load image and place UIImageView into a UIScrollView in the right coordination based on row and column number
- (void) loadTileIfMissingInRow: (int)row Column:(int)col
{
	BOOL tileIsInView = (actualFirstVisibleRow <= row && actualFirstVisibleColumn <= col && 
						 actualLastVisibleRow >= row && actualLastVisibleColumn >= col);
	
/*    
	BOOL tileIsMissing = (firstVisibleRow > row || firstVisibleColumn > col || 
						  lastVisibleRow  < row || lastVisibleColumn  < col);
*/    
    
    
    
    
        
	
	//load only if missing
	//if (tileIsMissing && tileIsInView) 
    if (tileIsInView) 
	{		
        // if tile is in view REUSE it
        for (UIView *tile in [tileContainerView subviews]) 
        {
            if ([tile isKindOfClass:[TileView class]])
            {
                if ([((TileView*)tile) actualRow] == row && [((TileView*)tile) actualColumn] == col && [((TileView*)tile) actualZoom] == resolution)
                {
                    CGRect frame = CGRectMake([self tileSize].width * col , [self tileSize].height * row, [self tileSize].width, [self tileSize].height);
                    
                    
                    [tile setFrame:frame];
                    [tileContainerView bringSubviewToFront:tile];
#ifdef LOG_TEXT                    
                    NSLog(@"--tile reused--");
#endif                    
                    return;
                    
                    //[self removeTile:(TileView*)tile];
                    //NSLog(@"--tile removed--");
                    
                }
            }
        }
        
		//remember map source (it should be equal to 0)
		//NSInteger startIndex = [[SourceData sharedInstance] getSelectedMapSourceIndex];
		//TileView *tile = nil;
		
		
/*		
//MASTER tile with image		 
		MapSourceDefinition mapSource = [[SourceData sharedInstance] getSelectedMapSource];
		//ALWAYS VISIBLE if (mapSource.visible && (mapSource.visibleFromLevel == 0 && mapSource.visibleToLevel == 0) || mapSource.visibleFromLevel <= resolution && mapSource.visibleToLevel >= resolution)
		{
			//load main tile (the only tile if there is jus one layer in map composition)
			tile = [dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution layerPosition:startIndex];	
			//TileView *tile = [dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution];			
		
			CGRect frame = CGRectMake([self tileSize].width * col , [self tileSize].height * row, [self tileSize].width, [self tileSize].height);
			[tile setFrame:frame];			
			float alpha = mapSource.alpha;
			[tile setAlpha:alpha];
		}
		 //choose next map source
		 [[SourceData sharedInstance] nextMapSource];
*/		 
		
		
		
        TileView *tile = nil;
//MASTER tile without image		
		tile = [dataSource tiledScrollViewEmpty:self tileForRow:row column:col resolution:resolution layerPosition:-1];	
		CGRect frame = CGRectMake([self tileSize].width * col , [self tileSize].height * row, [self tileSize].width, [self tileSize].height);
		[tile setFrame:frame];	
		[tile setAlpha:1];	
		
		//SourceData *sourceData = [[SourceData sharedInstance] retain];        
		//NSInteger mapCount = [sourceData getMapCount];
        //[sourceData release];
        
        NSInteger mapCount = 0;
        if ([dataSource wmDataSource] != nil)
            mapCount = [[dataSource wmDataSource] getNumberOfLayers];
        
		//load another tiles if there are any
		CGRect anotherFrame = CGRectMake(0, 0, [self tileSize].width, [self tileSize].height);
		for (int i = 0; i < mapCount; i++)
		{
			MapSourceDefinition *mapSource = nil;
			//mapSource = [[SourceData sharedInstance] getMapSource:i];
            mapSource = [[[dataSource wmDataSource] getLayerAtIndex:i] retain];
			if (mapSource.visible && ((mapSource.visibleFromLevel == 0 && mapSource.visibleToLevel == 0) || mapSource.visibleFromLevel <= resolution && mapSource.visibleToLevel >= resolution))
			{                
				TileView *anotherTile = [dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution layerPosition:i];					
				[anotherTile setFrame:anotherFrame];
				float alpha = mapSource.alpha;
				[anotherTile setAlpha:alpha];
				//[anotherTile setAlpha:0.99];		
				[tile addSubview:anotherTile];
			}
            [mapSource release];
		}		
        
        /*
		//load another tiles if there are any
		CGRect anotherFrame = CGRectMake(0, 0, [self tileSize].width, [self tileSize].height);
		NSInteger currentIndex = [[SourceData sharedInstance] getSelectedMapSourceIndex];
		BOOL firstRun = true;
		while (firstRun || startIndex != currentIndex)
		{
			MapSourceDefinition *mapSource = nil;
			mapSource = [[SourceData sharedInstance] getSelectedMapSource];
			if (mapSource.visible && ((mapSource.visibleFromLevel == 0 && mapSource.visibleToLevel == 0) || mapSource.visibleFromLevel <= resolution && mapSource.visibleToLevel >= resolution))
			{
				TileView *anotherTile = [dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution layerPosition:currentIndex];					
				[anotherTile setFrame:anotherFrame];
				float alpha = mapSource.alpha;
				[anotherTile setAlpha:alpha];
				//[anotherTile setAlpha:0.99];		
				[tile addSubview:anotherTile];
                [tile set]
			}
			
			if (firstRun)
				firstRun = false;
			
			[[SourceData sharedInstance] nextMapSource];	
			currentIndex = [[SourceData sharedInstance] getSelectedMapSourceIndex];
		}
		*/
		[tileContainerView addSubview:tile];
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
#ifdef ANNOTATE_TILES				
		// annotateTile draws green lines and tile numbers on the tiles for illustration purposes. 
		[self annotateTile:tile];
#endif				
		
	}
}

	
/*
//update reslution - if scale of uiscrollview is more than LEVEL_UPPER (for example 200%) or lower than LEVEL_LOWER (50%) than we need to change images (get a new level)
//if the scale is not between <LEVEL_LOWER, LEVEL_UPPER> we need to switch level
//we divide scale until it is in the range - the number of iteration is equal to delta which is a equal to level differencion
//example: scale is 20 -> 10, 5, 2.5, 1.25 -> delta = 4 & scale = 1,25  (it should be -4 if we have 0,02)
*/
- (void)updateResolution 
{    
	[self setScrollEnabled:NO]; //fix conflict while scrolling and changing zoom int the same time
	
    // delta will store the number of steps we should change our resolution by. If we've fallen below
    // a 25% zoom scale, for example, we should lower our resolution by 2 steps so delta will equal -2.
    // (Provided that lowering our resolution 2 steps stays within the limit imposed by minimumResolution.)
	
	int delta = 0;
	
	//actual zoom = resolution
	
	//ekvivalent - jen zacina od 1 ne od minimalniho resolution
	//>>1 == divide by 2  >>2 divide by 4 ....
	float zoom;
	int counter = 0;
	float scrollViewZoom = [self zoomScale];
    
    if (scrollViewZoom < LEVEL_MIN_ZOOM_SCALE)
    {
        zoom = scrollViewZoom * pow(2, LEVEL_UPPER_DIFFERENCE);;
        counter = -1;
        
        while (zoom < LEVEL_MIN_ZOOM_SCALE && counter < MAX_LEVEL_DELTA && counter > -MAX_LEVEL_DELTA)
		{	
            zoom *= pow(2, LEVEL_UPPER_DIFFERENCE);
            counter -= LEVEL_UPPER_DIFFERENCE;
		}
    }
    else if (scrollViewZoom > LEVEL_MAX_ZOOM_SCALE)
    {
        zoom = scrollViewZoom / pow(2, LEVEL_LOWER_DIFFERENCE);;
        counter = 1;
        
        while (zoom > LEVEL_MAX_ZOOM_SCALE && counter < MAX_LEVEL_DELTA && counter > -MAX_LEVEL_DELTA)
		{	
            zoom /= pow(2, LEVEL_LOWER_DIFFERENCE);
            counter += LEVEL_LOWER_DIFFERENCE;
		}
    }
        
    delta = counter;
	    
#ifdef LOG_TEXT	
	NSLog(@"delta: %d", delta);	
	NSLog(@"self zoomScale: %f", [self zoomScale]);
#endif	
	
	//if delta is not null than resolution should by changed -> call changeZoom to change resolution about delta
	if (delta != 0) 
	{        
		//MapSourceDefinition *mapSource = nil;
		//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
		//if(!((resolution <= mapSource.minLevel && delta <= 1) || (resolution >= mapSource.maxLevel && delta >= 1)))
        if(!((resolution <= [[mapView wmDataSource] getLayerAtIndex:0].minLevel && delta <= 1) || (resolution >= [[mapView wmDataSource] getLayerAtIndex:0].maxLevel && delta >= 1)))
		{
			//DO INSIDE changeZoom[self stopLoadingData]; //stop loading tiles of previous zoom level 
			[self changeZoom:delta];
		}
    }  

	[self setScrollEnabled:YES];
	lockTileLoading = FALSE;
	
	//[self layoutSubviews];
    [self setNeedsLayout];
	
#ifdef POSITION_VIEW	
	//should be only here for reolution change
	//[self performSelector:@selector(updatePositionView)]; //TODO maybe not necessary
#endif
}
        


//change level with new resolution
- (void) changeZoom:(NSInteger) delta
{
	//MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
	
	//if delta is over the limits -> we must repair it 
    
    //int minLevel = mapSource.minLevel;
    //int maxLevel = mapSource.maxLevel;
    if ([mapView wmDataSource] == nil)
        return;
    int minLevel = [[mapView wmDataSource] getLayerAtIndex:0].minLevel;
    int maxLevel = [[mapView wmDataSource] getLayerAtIndex:0].maxLevel;
    if (resolution + delta > maxLevel)
	{		
		delta = maxLevel - resolution; 
	}
	else if (resolution + delta < minLevel)
	{
		delta = minLevel - resolution; 
	}
	
	if (delta == 0)
		return;
	
	
	[self stopLoadingData]; //stop loading tiles of previous zoom level

    //update resolution
	resolution += delta;
    
	
	

	
	// save content offset, content size, and tileContainer size so we can restore them when we're done
	// (contentSize is not equal to containerSize when the container is smaller than the frame of the scrollView.)
	//CGPoint contentOffset = [self contentOffset];   
	
#ifdef LOG_TEXT	
	NSLog(@"RESOLUTION: %d", resolution );			
	NSLog(@"DELTA: %d", delta );
	CGPoint contentOffset = [self contentOffset];
	NSLog(@"ContentOffset: %f, %f, %f", contentOffset.x, contentOffset.y , pow(2, delta));
#endif	
	
	//get relative position of current view on the map
	CGSize oldContentSize = [tileContainerView frame].size;
	CGPoint oldOffset = [self contentOffset];   
	CGPoint oldOffsetCenter = CGPointMake(oldOffset.x + [self bounds].size.width/2, oldOffset.y + [self bounds].size.height/2); //we must compute center of view (content offset is in corner)
	CGPoint relPosition = CGPointMake((oldOffsetCenter.x)/oldContentSize.width, (oldOffsetCenter.y)/oldContentSize.height);

	//get resolution for actual level
	//
	//CGSize  contentSize2 = CGSizeMake(mapSource.mapResolution.width/pow(2,mapSource.maxLevel-res), mapSource.mapResolution.height/pow(2,mapSource.maxLevel-res));	
	//NSValue *valueWithResolution = [mapSource.levelsResolution objectAtIndex:resolution];
	
	//float res = resolution;
	NSValue *valueWithResolution = [levelResolutions objectAtIndex:resolution];
	CGSize  contentSizeForLevel = [valueWithResolution CGSizeValue];
	
	
	[self reloadDataWithNewContentSize:contentSizeForLevel];

	CGSize  containerSize = [tileContainerView frame].size;
	
	//set min and max scale for level
	
	
	
	//if it is Minimal or Maximal level set other values - it has no sense to zoom las level 100x times but it is possible
	if (resolution >= maxLevel)
    //if (resolution >= [[mapView wmDataSource] getLayerAtIndex:0].maxLevel)
    
		[self setMaximumZoomScale:MAX_SCALE_FOR_LAST_LEVEL];
	else
		[self setMaximumZoomScale:MAX_SCALE_FOR_LEVEL];//def max zoom to set
	
	if (resolution <= minLevel)	
    //if (resolution <= [[mapView wmDataSource] getLayerAtIndex:0].minLevel)	
		[self setMinimumZoomScale:MIN_SCALE_FOR_FIRST_LEVEL];
	else
		[self setMinimumZoomScale:MIN_SCALE_FOR_LEVEL];

	
	
	//get zoom factor - it must be repaired by delta value - if we set scale to 5 -> 2.5, 1.25 -> scale will be 1.25 and we change resolution by delta - 1
	float zoomFactor = pow(2, delta * -1); 
	double currentScale = [self zoomScale];
	double zScale = currentScale * zoomFactor;


	
	//if we try to set bigger or smaller resolution than it is max or min - it can make a mistake sometime
	if (zScale > [self maximumZoomScale])
	{
		zScale = [self maximumZoomScale];
	}
	else if (zScale < [self minimumZoomScale])
	{
		zScale = [self minimumZoomScale];
	}
	
	//set new scale	
	[super setZoomScale:zScale];		
 	
#ifdef LOG_TEXT	
	NSLog(@"scale: %f, level: %d, resolution: %f, %f", zScale, resolution, contentSizeForLevel.width, contentSizeForLevel.height);		
#endif //DEBUG
	
	//set size of cntainer - the same as resolution of map in this zoom level (not smaller)
	containerSize.width = ceil(contentSizeForLevel.width * zScale); 
	containerSize.height = ceil(contentSizeForLevel.height * zScale); 
	[tileContainerView setFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];    

	// restore content offset, content size, and container size
	//[self setContentOffset:contentOffset]; //get image to the last position

	//compute and set position of view on the map	
	CGPoint absoluteCenterPosition = CGPointMake(relPosition.x * containerSize.width, relPosition.y * containerSize.height);
	CGPoint newContentOffset = CGPointMake(absoluteCenterPosition.x - [self bounds].size.width*0.5, absoluteCenterPosition.y - [self bounds].size.height*0.5); //now we must compute corner from center (reverse)
	[self setContentOffset:newContentOffset];
	[self setContentSize:containerSize]; //set size of content	
	[self setContentInset:INSET_EDGE]; //set inset - it make possible to show map corner out of the toolbar or navigation bar 
	
	// throw out all tiles so they'll reload at the new resolution
#ifdef KEEP_OLD_LEVELS
    [self rescaleData];
#else
	[self reloadData];  	
#endif	
}

- (void) analyzeView:(UIView*)view level:(NSInteger)level
{	
	CGRect frame = [view frame];
	CGRect bounds = [view bounds];
	NSLog(@"%d - frame: %f, %f", level, frame.size.width, frame.size.height);
	NSLog(@"   - bounds: %f, %f", bounds.size.width, bounds.size.height);
	
	for (id subview in [view subviews])
	{
		[self analyzeView:subview level:(level+1)];		
	}
}







#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return tileContainerView;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	//start zooming
	lockTileLoading = TRUE;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{
	if (scrollView == self) 
	{
        // the following two lines are a bug workaround that will no longer be needed after OS 3.0.
        [super setZoomScale:scale+0.01 animated:NO];
        [super setZoomScale:scale animated:NO];

        // after a zoom, check to see if we should change the resolution of our tiles
        [self updateResolution];
    }
	
    [mapView didZoomEnded];
}


#pragma mark UIScrollView overrides

// the scrollViewDidEndZooming: delegate method is only called after an *animated* zoom. We also need to update our 
// resolution for non-animated zooms. So we also override the new setZoomScale:animated: method on UIScrollView
- (void)setZoomScale:(float)scale animated:(BOOL)animated 
{
    [super setZoomScale:scale animated:animated];
	
    // the delegate callback will catch the animated case, so just cover the non-animated case
    if (!animated) {
		[self updateResolution];
    }
}


//set relative scale - if there is some nonsence in scale - nothing happen
- (void)setZoomScaleRelativeSafe:(double)scale
{
	double newScale = [self zoomScale] * scale;	

	if (scale > 0)
		[super setZoomScale:newScale];
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;// / [imageScrollView zoomScale];
    zoomRect.size.width  = [self frame].size.width  / scale;// / [imageScrollView zoomScale];
	
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


//set absolute value of scale to the map - it simply compute relative scale and apply
- (void)setZoomScaleAbsoluteSafe:(double)scale
{
	double actualScale = pow(2, [self resolution]);
	double scaleForActualLevel = [self zoomScale];  
	actualScale *= scaleForActualLevel; 
	double relativeScale = scale / actualScale;
	[self setZoomScaleRelativeSafe:relativeScale];
}


// We override the setDelegate: method because we can't manage resolution changes unless we are our own delegate.
- (void)setDelegate:(id)delegate 
{
#ifdef LOG_TEXT		
    NSLog(@"You can't set the delegate of a TiledZoomableScrollView. It is its own delegate.");
#endif	
}


#pragma mark
#define LABEL_TAG 3

//draw tile and number of tile
- (void)annotateTile:(TileView *)tile 
{	
    static int totalTiles = 0;
    
    UILabel *label = (UILabel *)[tile viewWithTag:LABEL_TAG];
    if (!label) 
	{  
        totalTiles++;  // if we haven't already added a label to this tile, it's a new tile
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 256, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTag:LABEL_TAG];
        [label setTextColor:[UIColor greenColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label setFont:[UIFont boldSystemFontOfSize:40]];
        [label setText:[tile getDescription]]; //zoom-column-row
        [tile addSubview:label];
        [label release];
        [[tile layer] setBorderWidth:2];
        [[tile layer] setBorderColor:[[UIColor greenColor] CGColor]];
    }
    
    [tile bringSubviewToFront:label];	 
}


- (void)setZoomLevel:(int)newResolution
{
	int currentResolution = [self resolution];
	int diff = newResolution - currentResolution;
	int scaleDiff = pow(2, (double) diff);
	[self setZoomScale:scaleDiff animated:YES];
}


//return size in tiles of current view
- (CGSize) getSizeInTiles
{
	double scaledTileWidth  = (double)[self tileSize].width  * [self zoomScale];
    double scaledTileHeight = (double)[self tileSize].height * [self zoomScale];

	int maximumRow = floorf([tileContainerView frame].size.height / scaledTileHeight)-1; // this is the maximum possible row
	int maximumCol = floorf([tileContainerView frame].size.width  / scaledTileWidth)-1;  // and the maximum possible column
	
	return CGSizeMake(maximumRow, maximumCol);
}



//on scrolling (moving on the map)
- (void)scrollViewDidScroll:(UIScrollView *)inscrollView
{

#ifdef POSITION_VIEW	
    [self updatePositionView];
#endif
	
#ifdef LOG_TEXT	
	//NSLog(@"scrolling: x = %f, y = %f", p.x, p.y);
#endif	
	
    [self setNeedsLayout];
    [mapView isMovedDragging];
    
}


    

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[mapView willBeginDragging];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[mapView didEndDragging];
}

- (void) updatePositionView
{
	[self setPositionViewRelative:relativePositionCenterPoint withDiameter:relativePositionDiameter];

	[positionView setNeedsDisplay];
}


- (void) setPositionViewRelative:(CGPoint)relativeLocationPoint withDiameter:(float)relativeDiameter
{
	relativePositionCenterPoint = relativeLocationPoint;
	relativePositionDiameter = relativeDiameter;
	
	CGPoint absolutePixelPoint = CGPointMake([tileContainerView frame].size.width * relativeLocationPoint.x, [tileContainerView frame].size.height * relativeLocationPoint.y);
	[self setPositionView:absolutePixelPoint withDiameter:relativeDiameter*[tileContainerView frame].size.width];
}


- (void) setPositionView:(CGPoint)locationPoint withDiameter:(float)diameter
{
	[positionView setCenterPoint:locationPoint];
	[positionView setDiameter:diameter];
}


- (void) addPositionView
{
	//add point navigation view    
    CGRect frame = [mapView frame];
    positionView = [[PositionView alloc] initWithFrame:frame];
    
	[self addSubview:positionView];	
	[self setHidePositionView];
}


- (void) setShowPositionView
{
	[positionView setShowAngle:true];
	[positionView setShowCircle:true];
	[positionView setShowPoint:true];
}


- (void) setHidePositionView
{
	[positionView setShowAngle:false];
	[positionView setShowCircle:false];
	[positionView setShowPoint:false];
}


- (void) stopLoadingData
{
#ifdef LOG_TEXT	
	NSLog(@"stopLoadingData");
#endif
	
    [[TileDispatcher sharedInstance] cancelAllTasks];
    
	//send stop loading to each tile in view container
	for (TileView *tile in [tileContainerView subviews]) 
	{
		if ([tile isKindOfClass:[TileView class]])
		{
			[tile stopLoading];
		}				
    }
    
    [[TileDispatcher sharedInstance] cancelAllTasks];
    
    [TileView resetConnections];
}


- (void)dealloc 
{
    [reusableTiles release];
    [tileContainerView release];
	[shakeView release];
    [positionView release];
    [super dealloc];
}


@end
