//
//  MapView.m
//  WhateverMap_2
//
//  Created by Jirka on 9.7.11.
//  Copyright 2011 Mendel University in Brno. All rights reserved.
//

#import "WMMapView.h"
#import "TiledScrollView.h"
#import "constants.h"
#import "MapSourceDefinition.h"
#import "TileView.h"
#import "CoordConverter.h"
#import "Projection.h"
#import "TapDetectingView.h"
#import "InfoGetter.h"
#import "Common.h"
#import "WMDataSource.h"
#import <QuartzCore/QuartzCore.h>




@interface WMMapView (privateFunctions)

//DataSource delegate
- (TileView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex;
- (TileView *)tiledScrollViewEmpty:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex;
- (TileView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex ReturnEmpty:(BOOL)empty;


//tap detectiong
- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingView:(TapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingView:(TapDetectingView *)view gotTrippleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingView:(TapDetectingView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;

//help functions
- (double) getBBOXWidthInDegree;

- (void) setCompassFrame;
- (void) setNonCompassFrame;

@end



@implementation WMMapView

@synthesize wmDataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTiledView];
        compassFeatureEnabled = NO;
        [self setWmDataSource:nil];
        angleOfRotation = 0;
    }
    return self;
}

- (void) initTiledView
{
    CGRect frame = [self bounds];
    imageScrollView = [[TiledScrollView alloc] initWithFrame:frame];
    [imageScrollView setMapView:self];
    [imageScrollView setDataSource:self];	
    [imageScrollView addPositionView];
    [[imageScrollView tileContainerView] setDelegate:self];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    [imageScrollView setBouncesZoom:YES];
    
    [self addSubview:imageScrollView];
    
    //inset is set because of small map - it is not under navigation bar
    [imageScrollView setContentInset:INSET_EDGE];
    //[self showMap];    

}


- (void) setMapDelegate:(id)delegate
{
    [mapDelegate release];
    mapDelegate = nil;
    mapDelegate = [delegate retain];
}


- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!compassFeatureEnabled)
    {
        [imageScrollView setFrame:frame];
        [[imageScrollView positionView] setFrame:frame];
    }
    else
    {
        [imageScrollView setTransform:CGAffineTransformIdentity]; 
        //[imageScrollView setFrame:frame];
        [self enableCompassFeature];
        //[[imageScrollView positionView] setFrame:frame];
        [imageScrollView setTransform:CGAffineTransformMakeRotation(angleOfRotation)]; 
    }
}


- (void) setWmDataSource:(WMDataSource*)dataSource
{
    [[MapSource sharedInstance] setWmDataSource:dataSource];
    
    [wmDataSource release];
    wmDataSource = nil;
    
    wmDataSource = [dataSource retain];
    
    [self showMap];    
}


- (void) showMap 
{
    if (wmDataSource == nil)
        return;
        
	if (imageScrollView == nil)
		[self initTiledView];
	
	//MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    MapSourceDefinition *mapSource = [wmDataSource getLayerAtIndex:0];
    
	
	//Build resolution for all levels
	NSMutableArray *tmpLevelsArray = [[NSMutableArray alloc] init];
	
	if (mapSource.typeOfService == @"TMS2")
	{
		double deltaX = mapSource.boundingBox.maxX - mapSource.boundingBox.minX;  
		double deltaY = mapSource.boundingBox.maxY - mapSource.boundingBox.minY;
		
		for (int i = 0; i < mapSource.minLevel ;i++) 
		{
			[tmpLevelsArray addObject:[NSValue valueWithCGSize:CGSizeZero]];
		}
		
		for (int i = 0; i < [mapSource.levels count] ;i++) 
		{
			NSNumber *UnitsPerPixel = [[mapSource.levels objectAtIndex:i] objectAtIndex:1];
			
			double width = deltaX / [UnitsPerPixel doubleValue];
			double height = deltaY / [UnitsPerPixel doubleValue];
			
			[tmpLevelsArray addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];		
		}			
	}
	else 
	{	
		for (int i = 0; i < mapSource.minLevel ;i++) 
		{
			[tmpLevelsArray addObject:[NSValue valueWithCGSize:CGSizeZero]];
		}
		for (int i = mapSource.minLevel; i <= mapSource.maxLevel ;i++) 
		{
			CGFloat sizeWidth = mapSource.mapResolution.width/pow(2,mapSource.maxLevel-i);
			CGFloat sizeHeight = mapSource.mapResolution.height/pow(2,mapSource.maxLevel-i);
			CGSize resolutionForLevel = CGSizeMake(sizeWidth, sizeHeight);	
			//CGSize resolutionForLevel = CGSizeMake(mapSource.mapResolution.width/pow(2,mapSource.maxLevel-i), mapSource.mapResolution.height/pow(2,mapSource.maxLevel-i));	
			[tmpLevelsArray addObject:[NSValue valueWithCGSize:resolutionForLevel]];				
		}
	}
	
	[imageScrollView setLevelResolutions:tmpLevelsArray];	
	[tmpLevelsArray release];
	[imageScrollView setTileSize:(mapSource.tileResolution)];	
	//[self pickImageNamed:mapSource.title];
    
    //SourceData *sourceData = [[SourceData sharedInstance] retain];
	//[self pickImageNamed:[[[sourceData sourceNode] getChild:[sourceData nodeIndex]] title]];
    //[sourceData release];
    
    //[self pickImageNamed:[wmDataSource getLayerAtIndex:0].title];
    [self pickImageNamed:@"neco"];
	
	[imageScrollView setHidePositionView];
	//[[Locator sharedInstance] setFirstLocalization:YES];
    
	//reset setting - GPS location point, ...
    [[imageScrollView positionView] setHidden:TRUE];
}

- (void) reloadMap
{
    [imageScrollView reloadData];
}

- (void) setMapNeedslayout
{
    [imageScrollView setNeedsLayout];
}

#pragma mark View handling methods

- (void)pickImageNamed:(NSString *)name
{
	MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    mapSource = [wmDataSource getLayerAtIndex:0];
	
	double deviceWidth = [imageScrollView frame].size.width;
    
	CGSize size = [[[imageScrollView levelResolutions] objectAtIndex:mapSource.minLevel] CGSizeValue];
	double sizeRatio = deviceWidth / size.width;
	NSInteger sizeLevel = mapSource.minLevel;
    
#define COMPENSE_DEGRADATION 1.0 //if we prefer to zoom out and have more quality image than set to 1.2 or 1.4 ....
	
	for (int i = 0; i < [[imageScrollView levelResolutions] count]; i++)
	{
		CGSize levelSize = [[[imageScrollView levelResolutions] objectAtIndex:i] CGSizeValue];
		if (levelSize.width > 1 && levelSize.height > 1) // if it is nonsence do not compute
		{
			double levelRatio = deviceWidth / levelSize.width;
			
			//if (abs(levelRatio-1) < abs(sizeRatio-1))
			double LR = (levelRatio<1)?(levelRatio):(levelRatio*COMPENSE_DEGRADATION);
			double SR = (sizeRatio<1)?(sizeRatio):(sizeRatio*COMPENSE_DEGRADATION);
			LR = fabs(LR-1.0);
			SR = fabs(SR-1.0);
			if(LR < SR)
			{
				sizeRatio = levelRatio;
				size = levelSize;
				sizeLevel = i;// - mapSource.minLevel; 
			}
		}
	}
    
	//set name of map
    //[currentImageName release];
    //currentImageName = [name retain];
    
	[imageScrollView setResolution:sizeLevel];
    // change the content size and reset the state of the scroll view
    // to avoid interactions with different zoom scales and resolutions. 
	[imageScrollView setContentOffset:CGPointZero];
	[imageScrollView setContentInset:INSET_EDGE];
    
    // choose minimum scale so image width fills screen
	[imageScrollView setCanCancelContentTouches:YES];
	
	[imageScrollView reloadDataWithNewContentSize:size];
	
	
	if (sizeLevel <= mapSource.minLevel)
		[imageScrollView setMinimumResolution:MIN_SCALE_FOR_FIRST_LEVEL];
	else
		[imageScrollView setMinimumResolution:MIN_SCALE_FOR_LEVEL];
	
	if (sizeLevel >= mapSource.maxLevel)
		[imageScrollView setMaximumResolution:MAX_SCALE_FOR_LAST_LEVEL];
	else
		[imageScrollView setMaximumResolution:MAX_SCALE_FOR_LEVEL];
    
	//TODO
	[imageScrollView setZoomScale:sizeRatio];   
	
	CGSize scaledSize = CGSizeMake(ceil(size.width * sizeRatio), ceil(size.height * sizeRatio));	
	CGRect scaledRect = CGRectMake(0, 0, scaledSize.width, scaledSize.height);	
	[[imageScrollView tileContainerView] setFrame:scaledRect];
	[imageScrollView setContentSize:scaledSize];
    
	//[navItem setTitle:currentImageName];
	
	//[[self navigationItem] setTitle:currentImageName];
	
	[imageScrollView reloadData];
}





#pragma mark TiledScrollViewDataSource method

- (TileView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex
{
	BOOL empty = NO;
	return  [self tiledScrollView:tiledScrollView tileForRow:row column:column resolution:resolution layerPosition:posIndex ReturnEmpty:empty];
}


- (TileView *)tiledScrollViewEmpty:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex
{
	BOOL empty = YES;
	return [self tiledScrollView:tiledScrollView tileForRow:row column:column resolution:resolution layerPosition:posIndex ReturnEmpty:empty];
}


- (TileView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution layerPosition:(int)posIndex ReturnEmpty:(BOOL)empty {
	
    // re-use a tile rather than creating a new one, if possible
    TileView *tile = (TileView *)[tiledScrollView dequeueReusableTile];
	[tile cleanTile];
	
    if (!tile) {
        // the scroll view will handle setting the tile's frame, so we don't have to worry about it
        tile = [[[TileView alloc] initWithFrame:CGRectZero] autorelease]; 
#ifdef LOG_TEXT		
		NSLog(@"Tile allocated");
#endif		
        // Some of the tiles won't be completely filled, because they're on the right or bottom edge.
        // By default, the image would be stretched to fill the frame of the image view, but we don't
        // want this. Setting the content mode to "top left" ensures that the images around the edge are
        // positioned properly in their tiles. 
        [tile setContentMode:UIViewContentModeTopLeft]; 		
    }
    
    // The resolution is stored as a power of 2, so -1 means 50%, -2 means 25%, and 0 means 100%.
    // We've named the tiles things like BlackLagoon_50_0_2.png, where the 50 represents 50% resolution.
	
	if (!empty)
	{
		TileObject *tileObj = [[TileObject alloc] init];
		[tileObj setZoom:resolution];
		[tileObj setColumn:column];
		[tileObj setRow:row];
		[tileObj setPositionIndex:posIndex];
        
		[tile loadTile:tileObj];
		
		[tileObj release];
	}
    
    [tile setActualRow:row];
    [tile setActualColumn:column];
    [tile setActualZoom:resolution];
	
#ifdef LOG_TEXT		
	NSLog(@"MapController: tileCoord: %@", [NSString stringWithFormat:@"%d-%d-%d.png", resolution, column, row]);
#endif
	
    return tile;
}





#pragma mark TapDetectingViewDelegate 


- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint 
{
	if ([self getZoomLevel] > 15)
	{
		MapSourceDefinition *mapSource = nil;
		///mapSource = [[SourceData sharedInstance] getSelectedMapSource];	
        mapSource = [wmDataSource getLayerAtIndex:0];
		
		if (mapSource.infoAddress != nil && [mapSource.infoAddress count] > 0)		
		{
			CGPoint tappedPixelPoint = CGPointMake(tapPoint.x, tapPoint.y);
            
            float scaledTileWidth  = (float)[imageScrollView tileSize].width  * [imageScrollView zoomScale];
            float scaledTileHeight = (float)[imageScrollView tileSize].height * [imageScrollView zoomScale];            
            double tileX = (tappedPixelPoint.x / (float)scaledTileHeight); // this is the maximum possible row
            double tileY = (tappedPixelPoint.y / (float)scaledTileWidth); // and the maximum possible column
            
            //NSString *infoAddress = [InfoGetter getInfoFromAddress:mapSource.infoAddress atCoord:tappedPixelPoint];			            
            //NSString *infoAddress = [InfoGetter getInfoFromAddress:mapSource.infoAddress atCoord:tappedPixelPoint onTileZoom:[imageScrollView resolution] Column:tileX Row:tileY];			            
            //NSString *infoAddress = [InfoGetter getInfoFromAddress:mapSource.infoAddress atCoord:tappedPixelPoint onTileZoom:[imageScrollView resolution] Column:tileX Row:tileY DataSource:wmDataSource];			            
            
            NSString *infoAddress = [InfoGetter getInfoFromSource:wmDataSource atCoord:tappedPixelPoint onTileZoom:[imageScrollView resolution] Column:tileX Row:tileY];			            
            
            if (infoAddress == nil)
                return;
            
			NSURL *infoURL = [NSURL URLWithString:infoAddress];
			NSError *error = nil;
			
			//WEB
			if ([[mapSource.infoType lowercaseString] rangeOfString:@"web"].location != NSNotFound)	
			{
				//show web view
				CGRect webFrame = self.bounds; 
				UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame]; 
				
				[webView setBackgroundColor:[UIColor whiteColor]]; 
				[webView setScalesPageToFit:YES];
				[webView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
				[webView setDelegate:mapDelegate];
				
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:infoURL]; 
				[webView loadRequest:requestObj]; 
				[self addSubview:webView];
				UIViewController *webViewController = [[UIViewController alloc] init];
				webViewController.view = webView;
				//[[self navigationController] pushViewController:webViewController animated:YES];
                [[mapDelegate navigationController] pushViewController:webViewController animated:YES];
				[webViewController release];
				[webView release]; 
			}
			else //TEXT - show text in alert view	
			{
				NSString *info = [NSString stringWithContentsOfURL:infoURL encoding:NSUTF8StringEncoding error:&error];
				[Common showMessage:info withTitle:@"Info"];
			}
		}
	}	
    
    [self didTapAtPoint:tapPoint];
}







- (void)tapDetectingView:(TapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint 
{
    // double tap zoom-in
	[imageScrollView setDirtyZoom:TRUE];
	
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
	
    CGRect zoomRect = [imageScrollView zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];		
	
	[self didUserInteract];
}

- (void)tapDetectingView:(TapDetectingView *)view gotTrippleTapAtPoint:(CGPoint)tapPoint 
{	
	[imageScrollView setLockTileLoading:YES];
	//[imageScrollView stopLoadingData]; //if more request of this type is genereting it could be freezed
	
	[imageScrollView setDirtyZoom:TRUE];
	
    // tripple tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [imageScrollView zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];	
	
	[self didUserInteract];
}


- (void)tapDetectingView:(TapDetectingView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint 
{
	[imageScrollView setLockTileLoading:YES];
	//[imageScrollView stopLoadingData]; //if more request of this type is genereting it could be freezed
	
	[imageScrollView setDirtyZoom:TRUE];
	//TODO BUGGGGGGGG maybe fixed
    
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    //CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    CGRect zoomRect = [imageScrollView zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
    
	[self didUserInteract];
}





//COMMUNICATION WITH DELEGATE

- (void) isMovedDragging
{
    if ([mapDelegate respondsToSelector:@selector(isMovedDragging)])
        [mapDelegate isMovedDragging];    
}

- (void) didUserInteract
{
    if ([mapDelegate respondsToSelector:@selector(didUserInteract)])
        [mapDelegate didUserInteract];
}

- (void) didZoomEnded
{
    [self didUserInteract];
    
    if ([mapDelegate respondsToSelector:@selector(didZoomEnded)])
        [mapDelegate didZoomEnded];
}

- (void) willBeginDragging
{
    if ([mapDelegate respondsToSelector:@selector(willBeginDragging)])
        [mapDelegate willBeginDragging];    
}

- (void) didEndDragging
{
    [self didUserInteract];
    
    if ([mapDelegate respondsToSelector:@selector(didEndDragging)])
        [mapDelegate didEndDragging];
}

- (void) didTapAtPoint:(CGPoint) point
{
    [self didUserInteract];
    
    int zoomLevel = [self getLevel];
    CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[wmDataSource getLayerAtIndex:0]];
    LatLon ll = [coordConvertor convertPixelToLatLon:point zoom:zoomLevel];
    [coordConvertor release];
    
    if ([mapDelegate respondsToSelector:@selector(didTapAtPoint:)])
        [mapDelegate didTapAtPoint:point];
    
    if ([mapDelegate respondsToSelector:@selector(didTapAtLonLat:)])
        [mapDelegate didTapAtLonLat:ll];        
}






#pragma mark MapControlling
#pragma mark MovementOnTheMap method 

const double _WGS84DegPerMeter = 360 / (2 * M_PI * 6378137);

static double degreeDistance(LatLon p1, LatLon p2)
{
	return sqrt(pow(p2.lat - p1.lon, 2) + pow(p2.lat - p1.lon, 2));
}

static double getPathLengthInMeters(LatLon p1, LatLon p2)
{
	return degreeDistance(p1, p2) / _WGS84DegPerMeter;
}

static double getDifferenceLengthInMetersFromDegrees(CGSize degrees)
{
	return degrees.width / _WGS84DegPerMeter;
}

static double getDifferenceLengthInDegreesFromMeters(CGSize meters)
{
	return meters.width * _WGS84DegPerMeter;
}




///////////////
//COMBINE MOVEMENT AND ZOOM

- (void) goToLonLat:(LatLon)latLon WithDegreeDelta:(CGSize)deltaInDegree animated:(BOOL)animated
{	
	[self goToLonLat:latLon animated:animated];
	[self zoomToDegreeDelta:deltaInDegree animated:animated];
}


- (void) goToLonLat:(LatLon)latLon WithDistanceDelta:(CGSize)deltaInDistance animated:(BOOL)animated
{
	[self goToLonLat:latLon animated:animated];
	[self zoomToDistanceDelta:deltaInDistance animated:animated];
}


- (void) goToLonLat:(LatLon)latLon AtLevel:(double)level animated:(BOOL)animated
{	
	[self goToLonLat:latLon animated:animated];
	[self zoomToLevel:level animated:animated];
}

- (void) goToPixel:(CGPoint)pixel AtLevel:(double)level animated:(BOOL)animated
{	
	
	[self zoomToLevel:level animated:animated];
    [self goToPixel:pixel animated:animated];
}




///////////////
//MOVEMENT
- (void) goToLonLat:(LatLon)latlon animated:(BOOL)animated
{
	NSInteger level = [imageScrollView resolution];
	
	//CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[[SourceData sharedInstance] getSelectedMapSource]];
    CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[wmDataSource getLayerAtIndex:0]];
	CGPoint coord = [coordConvertor convertLatLonToCoord:latlon];
	CGPoint pixel = [coordConvertor convertCoordToPixel:coord zoom:trunc(level)];
	[self goToPixel:pixel animated:animated];
	[coordConvertor release];
	
    [[imageScrollView positionView] setHidden:FALSE];
}


- (void) goToPixel:(CGPoint)pixel animated:(BOOL)animated
{	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:.03];
		[UIView setAnimationDuration:0.9];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self window] cache:YES];
	}
	
	double scale = [imageScrollView zoomScale];
	pixel.x *= scale;
	pixel.y *= scale;
	
	//PAN MAP
	pixel.x = (NSInteger)round(pixel.x);
	pixel.y = (NSInteger)round(pixel.y);
	
	//count with edgeInset
	//pixel.x += [imageScrollView contentInset].left;
	//pixel.y += [imageScrollView contentInset].top;
	
	
	//move it to the center of the screen
	pixel.x -= [imageScrollView bounds].size.width/2;
	pixel.y -= [imageScrollView bounds].size.height/2;
    
    [imageScrollView setContentOffset:pixel];
	
	if (animated)
	{
		[UIView commitAnimations];
	}
}






//////////
//ZOOMING


- (void) zoomToLevel:(double)level animated:(BOOL)animated
{
	double scale = pow(2, trunc(level)) + pow(2, level - trunc(level) + 1);
	[self zoomToScale:scale animated:animated];
	
    [self zoomToScale:scale animated:animated];
    
	//TODO vubec to cele zoomovani predelat
	
    /*
     //FIX if scale == 0
     double zScale = level - trunc(level);
     if (zScale > -0.0001 && zScale < 0.0001)
     zScale = 0.0001;
     
     [imageScrollView setZoomScale:zScale];	
     */
}


- (void) zoomToDegreeDelta:(CGSize)degreeDelta animated:(BOOL)animated
{
	MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    mapSource = [wmDataSource getLayerAtIndex:0];
	
	double deltaLon = [self getBBOXWidthInDegree];
    
	double oneDegreeInPixels = mapSource.mapResolution.width / deltaLon;
	
	double pixels = degreeDelta.width * oneDegreeInPixels;
	
	double scale = mapSource.mapResolution.width/pixels;
	
	[self zoomToScale:scale animated:animated];	
}


- (void) zoomToDistanceDelta:(CGSize)distanceDelta animated:(BOOL)animated
{
	double degrees = getDifferenceLengthInDegreesFromMeters(distanceDelta);
	
	CGSize degreeDelta = CGSizeMake(degrees, degrees);
	
	[self zoomToDegreeDelta:degreeDelta animated:animated];
}


- (void) zoomToLevelRelative:(double)level animated:(BOOL)animated
{
	[self zoomToScaleRelative:pow(2, level) animated:animated];
}


- (void) zoomToScaleRelative:(double)scale animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:.03];
		[UIView setAnimationDuration:0.9];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self window] cache:YES];
	}
    
	[imageScrollView setZoomScaleRelativeSafe:scale];
	
	if (animated) 
	{
		[UIView commitAnimations];
	}
}

- (void) zoomToScale:(double)scale animated:(BOOL)animated
{	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:.03];
		[UIView setAnimationDuration:0.9];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self window] cache:YES];
	}
	
	[imageScrollView setZoomScaleAbsoluteSafe:scale];
	
	if (animated) 
	{
		[UIView commitAnimations];
	}
}






//////////////////
//GET INFO

- (double) getZoomLevel
{
	//TODO overit
	double scale = [imageScrollView zoomScale] -1;
	NSInteger resolution = [imageScrollView resolution] - 1;
	double level = resolution + scale;
	return level;
}

- (int) getLevel
{
    return [imageScrollView resolution];
}


//get pixel in image which we see in the middle of the screen
- (CGPoint) getPixel
{
	//get pixel
	CGPoint pixel = [imageScrollView contentOffset];
    
	//pixel.x += [imageScrollView contentInset].left;
	//pixel.y += [imageScrollView contentInset].top;
    
	pixel.x += [imageScrollView bounds].size.width/2;
	pixel.y += [imageScrollView bounds].size.height/2;
	
	double scale = [imageScrollView zoomScale];
	pixel.x = (NSInteger)round(pixel.x/scale);
	pixel.y = (NSInteger)round(pixel.y/scale);
    
	return pixel;
}


- (LatLon) getLonLat
{
	CGPoint pixel = [self getPixel];
	double zoom = [self getZoomLevel];
	zoom = round(zoom+1);
	
	//CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[[SourceData sharedInstance] getSelectedMapSource]];
    CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[wmDataSource getLayerAtIndex:0]];
	LatLon ll = [coordConvertor convertPixelToLatLon:pixel zoom:zoom];
	[coordConvertor release];
	
	return LatLonMake(ll.lon, ll.lat);
}




///////////////////////
//POSITION CONTROL

- (void) showPositionView
{
    [[imageScrollView positionView] show];
    [[imageScrollView positionView] setHidden:FALSE];
    [imageScrollView setShowPositionView];
}


- (void) hidePositionView;
{
    [[imageScrollView positionView] setHidden:TRUE];
    [imageScrollView setHidePositionView];
}



-(void) setPositionPointer:(CGPoint)relativePixelPoint withDiameteRelative:(float)pixelDiameter
{
    if (![[imageScrollView positionView] isHidden])
	{
		[imageScrollView setPositionViewRelative:relativePixelPoint withDiameter:pixelDiameter];
	}
}


-(void) setPositionPointer:(LatLon)latlon withDiameterInDegree:(float)diameterInDegree
{
    if (![[imageScrollView positionView] isHidden])
	{		
		//CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[[SourceData sharedInstance] getSelectedMapSource]];
        CoordConverter *coordConvertor = [[CoordConverter alloc] initWithDefinition:[wmDataSource getLayerAtIndex:0]];
        CGPoint relativePixel = [coordConvertor convertLatLonToPixelRelative:latlon];
		[coordConvertor release];
		
		float deltaX = [self getBBOXWidthInDegree];
		
		float relativeDiameter = fabs(diameterInDegree/deltaX);
        
		[self setPositionPointer:relativePixel withDiameteRelative:relativeDiameter];
	}
}


-(void) setPositionPointer:(LatLon)latlon withDiameterInMeters:(float)diameterInMeters;
{
    if (![[imageScrollView positionView] isHidden])
	{
		float diameterInDegree = 0.00001 * diameterInMeters;		
		[self setPositionPointer:latlon withDiameterInDegree:diameterInDegree];
	}
}





//////////////////
//HELP FUNCTIONS

- (double) getBBOXWidthInDegree
{
	MapSourceDefinition *mapSource = nil;
	//mapSource = [[SourceData sharedInstance] getSelectedMapSource];
    mapSource = [wmDataSource getLayerAtIndex:0];
	
	CGPoint minPoint = CGPointMake(mapSource.boundingBox.minX, mapSource.boundingBox.minY);
	CGPoint maxPoint = CGPointMake(mapSource.boundingBox.maxX, mapSource.boundingBox.maxX);
	
	LatLon minLatLon, maxLatLon;
    Projection *projection =[[Projection sharedInstance] retain];
	[projection convertPoint:minPoint inFormat:mapSource.projectionKey toLatLon:&minLatLon];
	[projection convertPoint:maxPoint inFormat:mapSource.projectionKey toLatLon:&maxLatLon];
    [projection release];
	
	double minX = minLatLon.lon;
	double maxX = maxLatLon.lon;
	double deltaX = maxX - minX;  
	
	return deltaX;	
}



#pragma mark Memory optimalization features


//MEMORY OPTIMALIZATION
- (void) removeAllTiles
{
    [imageScrollView removeAllTiles];
    [imageScrollView clearReusableTile];
}

- (void) removeTilesFromNonActualZoomLevel
{
    [imageScrollView removeTilesFromNonActualZoomLevel];
    [imageScrollView clearReusableTile];
}

- (void) clearReusableTile
{
    [imageScrollView clearReusableTile];
}








#pragma mark Compass features


- (void) setCompassFrame
{   
    CGRect originalFrame = [self frame];
    float radius = sqrt(originalFrame.size.width * originalFrame.size.width + originalFrame.size.height * originalFrame.size.height);    
    
    CGRect mapViewFrame = [self frame]; 
    [imageScrollView setFrame:mapViewFrame];
    
    CGSize newSize = CGSizeMake(radius, radius);
    CGSize diffSize = CGSizeMake(newSize.width - mapViewFrame.size.width, newSize.height - mapViewFrame.size.height);
    CGPoint newOrigin = CGPointMake(mapViewFrame.origin.x - diffSize.width/2, mapViewFrame.origin.x - diffSize.height/2);
    
    CGRect newRect = CGRectZero;
    newRect.origin = newOrigin;
    newRect.size = newSize;    
    
    [imageScrollView setFrame:newRect];
}


- (void) enableCompassFeature
{
#ifdef LOG_TEXT        
    NSLog(@"setCompassBounds");
#endif
    
    compassFeatureEnabled = YES;
	//[self setNewBounds:CGSizeMake(1.75, 1.22)]; //portrait is fine
    //[self setNewBounds:CGSizeMake(1.75, 1.75)];
    //[self setNewBounds:CGSizeMake(0.5, 0.5)];
    
    /*
    CGRect originalFrame = [self frame];
    float radius = sqrt(originalFrame.size.width * originalFrame.size.width + originalFrame.size.height * originalFrame.size.height);
    float newSize = radius / sqrt(2);
    NSLog(@"newSize: %f", newSize);
     */
    //[self setNewBounds:CGSizeMake(1, 1)];
    
    [self setCompassFrame];
    
}


- (void) disableCompassFeature
{
#ifdef LOG_TEXT    
    NSLog(@"setNonCompassFrame");
#endif
    
    /*
    [self setMapRotation:0];
    compassFeatureEnabled = NO;
    //[imageScrollView setTransform:CGAffineTransformIdentity]; 
    [self setNewBounds:CGSizeMake(1, 1)];
     */
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationDidStopSelector:@selector(setNonCompassFrame)];
    
    [imageScrollView setTransform:CGAffineTransformIdentity]; 
    
    [UIView commitAnimations];

}

- (void) setNonCompassFrame
{
   //[self setNewBounds:CGSizeMake(1, 1)]; 
    [imageScrollView setFrame :[self frame]]; 
}


- (void) setMapRotation:(double)rotationAngle
{
    if (compassFeatureEnabled)
    {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
        
        angleOfRotation = rotationAngle; 
        [imageScrollView setTransform:CGAffineTransformMakeRotation(rotationAngle)]; 
        
        [UIView commitAnimations];
    }
}










- (void)dealloc
{
    [mapDelegate release];
    [super dealloc];
}

@end
