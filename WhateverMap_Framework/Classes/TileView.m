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


#import "TileView.h"
#import "ConnectionReachability.h"
#import "Common.h"
#import "ConnectionReachability.h"
#import "constants.h"
#import "typeDefinitions.h"
#import <ImageIO/CGImageSource.h>
#import <QuartzCore/QuartzCore.h>

//random
#import <stdlib.h>
#import <time.h>
#import <Foundation/Foundation.h>
#import "TileDispatcher.h"

#import "MapSource.h"
//#import "SourceData.h"



@interface TileView ()
    - (void) loadTileThread:(TileObject*)tileObj;
    - (void) tileBlock;
@end

@implementation TileView

@synthesize path;
@synthesize actualRow, actualZoom, actualColumn, actualLayer;
@synthesize currentTileObj;

static NSInteger numberOfConnections = 0;
static UIImage* noTileImage;




- (id) init
{
	self = [super init];
	if (self != nil) {
		isLoading = FALSE;
        numberOfTries = 0;
	}
	return self;
}





- (void) loadTile:(TileObject*)tileObj
{
    [self setCurrentTileObj:tileObj];
    //[self tileBlock];
    
    [self setActualRow:[tileObj row]];
    [self setActualColumn:[tileObj column]];
    [self setActualZoom:[tileObj zoom]];
    [self setActualLayer:[tileObj positionIndex]];
    
    [[TileDispatcher sharedInstance] addOperationBlockToDownloadingQueue:       
     ^{
         [self tileBlock];
     }
     ];
}


- (void) tileBlock
{
    [self loadTileThread:currentTileObj];
    [self setCurrentTileObj:nil];
}


- (void) loadTileThread:(TileObject*)tileObj
{    
	//[self loadTile:tileObj.zoom column:tileObj.column row:tileObj.row layerPosition:tileObj.positionIndex];
    [self loadTile:actualZoom column:actualColumn row:actualRow layerPosition:actualLayer];
}



- (void) loadTile:(NSInteger)zoom column:(NSInteger)column row:(NSInteger)row layerPosition:(NSInteger)posIndex;
{	
	isLoading = TRUE;
    
/*
 //TODO index identifikujici kompozici pro jednoznacne ukladani do adresare
    @synchronized([SourceData sharedInstance])
    {
        nodeIndex = [[SourceData sharedInstance] nodeIndex];
    }
*/
 
	layerIndex = posIndex; 
	
	//tile loading URL	
	[self setActualRow:row];
	[self setActualColumn:column];
	[self setActualZoom:zoom];
    [self setActualLayer:posIndex];
    
    if (data)
    {
        [data release];
        data = nil;
    }
    [self setImage:nil];
    
    
	//OSM has only 18 zoom level - hack for now
	//if (zoom > 18 && nodeIndex == 0 && layerIndex == 0)
    if (zoom > 18 && layerIndex == 0)
	{
        if(![[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."])
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{                
                [self finishTaskNoTile];
            }];

        }
        else
        {
            [self finishTaskNoTile];
        }

		return;
	}
	
	
    
	//check connection
	if(![[ConnectionReachability sharedInstance] isConnected])
	{
		[Common showConnectionIsNotAvailableMessage];
	}
	
	
	{
		
		if ([Common showConnectionDidFail]) 
		{
			[Common setShowConnectionDidFail:TRUE];
		}
		else if ([Common showConnectionIsNotAvailable]) 
		{
			[Common setShowConnectionIsNotAvailable:TRUE];
		}
		 
		
		
		
#ifdef LOG_TEXT 			
		//NSLog(@"start loading data");			
#endif					
		
		
		
	
		BOOL isDir = YES;
		NSString* tileCompositionDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", nodeIndex]];
		tileDirectory = [tileCompositionDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", layerIndex]];
		 
		
		//Create directory if necessary
		if(![[NSFileManager defaultManager] fileExistsAtPath:tileDirectory isDirectory:&isDir])
		{
			if(![[NSFileManager defaultManager] fileExistsAtPath:tileCompositionDirectory isDirectory:&isDir])
			{
				if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
				{								
					NSLog(@"Error: Create folder failed: %@", tileCompositionDirectory);		
				}
			}
			
			if(![[NSFileManager defaultManager] createDirectoryAtPath:tileDirectory withIntermediateDirectories:YES attributes:nil error:nil])
			{								
				NSLog(@"Error: Create folder failed: %@", tileDirectory);		
			}
		}
		
		if (actualRow == 0 && actualZoom == 0)
        {
            actualZoom = 0;
        }
            
		[self setPath:[tileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"tile-%d-%d-%d.png", actualZoom, actualColumn, actualRow]]];
		
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
                
		if (fileExists)
		{		
            //[self loadTileOffline];
            [[TileDispatcher sharedInstance] addOperationBlockToDrawingQueue:
             ^{
                 [self tileBlockOffline];
             }
             ];

		}
		else
		{	
            if(![[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."])
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self startAddressGenerating];
                }];
            }
            else
            {
                [self startAddressGenerating];
            }
		}		
	}
}

- (void) startAddressGenerating
{
    //MapSource* mapSource = [[MapSource alloc] init];
    MapSource* mapSource = [[MapSource sharedInstance] retain];
    [mapSource getNewRequestAddressByZoom:actualZoom Column:actualColumn Row:actualRow Layer:actualLayer forDelegate:self];
    [mapSource release];
    mapSource = nil;
}


//after generating this method is called by MapSource asynchonously
- (void) prepareRequestForLoading:(NSString*)textUrl
{
	if (textUrl == nil) {
		NSLog(@"TileView: Error: testURL is nil - bad parameter may occure");
		return;
	}	
	
	
	NSURL *url = [NSURL URLWithString: textUrl];
	NSURLRequest *tileRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
	
	if (dataConnection)
	{
		//if there is active connection than stop it
		[dataConnection cancel];
		[dataConnection release];
		dataConnection = nil;
	}
	
	[self performSelectorOnMainThread:@selector(startDownloadingWithRequest:) withObject:tileRequest waitUntilDone:YES];
    //[self startDownloadingWithRequest:tileRequest];
}


//always start connection on main thread
- (void) startDownloadingWithRequest:(NSURLRequest*)request
{
	//dataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
    
    //fix //start connection during scrolling
    dataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [dataConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dataConnection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self increaseConnectionNumber];
	
	data = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)partialData
{
	[data appendData: partialData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self decreaseConnectionNumber];
    
    NSLog(@"Tile loading failed: try number %d", numberOfTries);			
    
	isLoading = FALSE;
	
	[dataConnection release];
	dataConnection = nil;
	
	[data release];
	data = nil;
	
	[Common showConnectionDidFailMessage];
	
	
    
    //try downloading again if number of tries is below limit
    if (numberOfTries < 3)
    {
        numberOfTries++;
        //[self loadTile:currentTileObj];
        [[TileDispatcher sharedInstance] addOperationBlockToDownloadingQueue:
         ^{
             [self tileBlock];
         }
         ];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self decreaseConnectionNumber];
    
	[dataConnection release];
	dataConnection = nil;
	
	//[self finishTask];
      
    [[TileDispatcher sharedInstance] addOperationBlockToDrawingQueue:
     ^{
         [self finishTask];
     }
     ];

}


- (void) finishTask
{
    [self performSelectorOnMainThread:@selector(showTileImage:) withObject:data waitUntilDone:YES];
    //[self showTileImage:data];
    
	
#ifdef STORE_TILES	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	
	if(!fileExists)
	{
		[data writeToFile:path atomically:YES];
	}
#endif	
}


- (void) tileBlockOffline
{
    [self performSelectorOnMainThread:@selector(loadTileOffline) withObject:nil waitUntilDone:YES];
    //[self loadTileOffline];
}

- (void) loadTileOffline
{
	if (!isLoading)
		return;
		
	data = [[NSData alloc] initWithContentsOfFile:path];
	
#ifdef LOG_TEXT    
    NSLog(@"offline path to load tile: %@", path);
#endif    
	[self performSelectorOnMainThread:@selector(showTileImage:) withObject:data waitUntilDone:YES];
    //[self showTileImage:data];
    
	isLoading = FALSE;
}

- (void) showTileImage:(NSData*)imageData
{
	if (!isLoading)
		return;

	if (!data || [data length] == 0)
	{
		NSLog(@"TileView: no data for loading tile");
		return;
	}

#ifdef FADE_IN_TILE	
	double storedAlpha = [self alpha];
	@synchronized(self)
	{
		[self setAlpha:0.0];
	}
#endif	
	
    UIImage *currentTileImage = [[UIImage alloc] initWithData:data];
	[self setImage:currentTileImage];
    [currentTileImage release];
	
	[data release];
	data = nil;
	
#ifdef FADE_IN_TILE	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:FADE_IN_TILE_DURATION];
	[UIView setAnimationDelay:0.05];
	@synchronized(self)
	{
		[self setAlpha:storedAlpha];
	}
	
	[UIView commitAnimations];
#endif
	
	isLoading = FALSE;
}



- (void) finishTaskNoTile
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	if (!isLoading)
		return;
		
#ifdef FADE_IN_TILE	
	double storedAlpha = [self alpha];
	[self setAlpha:0.0];
#endif	
	
	if (!noTileImage)
    {
        noTileImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"no_tile.png"]];
    }
	
	@synchronized(self)
	{
		[self setImage:noTileImage];		
	}
	
#ifdef FADE_IN_TILE	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:FADE_IN_TILE_DURATION];
	[UIView setAnimationDelay:0.05];
	[self setAlpha:storedAlpha];
	[UIView commitAnimations];
#endif
		
	isLoading = FALSE;
    
    [pool drain];
}



//NSURLCONNECTION DELEGATE
/////////////////







//if removing tile from view, stop previous connections for loading image
//good for reusing
- (void) stopLoading
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadTileOffline) object:nil];
	isLoading = FALSE;

	
	if (dataConnection != nil)
	{
		[dataConnection cancel];
		[dataConnection release];
		dataConnection = nil;
		
		//[self decreaseConnectionNumber];
	}
    
    [data release];
    data = nil;
    
    [self setImage:nil];
}

- (void) cleanTile
{
	[self stopLoading];

	[self setImage:nil];
    isLoading = FALSE;
    numberOfTries = 0;
	tileDirectory = nil;
	path = nil;
	
	if (data) 
	{
		[data release];
		data = nil;		
	}
}

//set initial image - if reloading it is shown 
//it must remove old image too - otherwise there is a mess and it shows old images
- (void) setLoadingTileImage
{	
	[self setImage:nil];
}


//reset connections 
+ (void) resetConnections
{
	
	//set number of connection to 0 - no connection loading data and stop network activity indicator
	numberOfConnections = 0;
	[Common stopNetworkActivityIndicator];
	 
}


- (NSString*) getDescription
{
	NSString *desc = [NSString stringWithFormat:@"%d-%d-%d", actualZoom, actualColumn, actualRow];
	return desc;
}
 


- (void) increaseConnectionNumber
{
    //NSLog(@"+");    
		numberOfConnections++;
		[Common startNetworkActivityIndicator];
}

- (void) decreaseConnectionNumber
{
    //NSLog(@"-");
		numberOfConnections--;
		if (numberOfConnections == 0)
		{
			[Common stopNetworkActivityIndicator];
		}
        else if (numberOfConnections < 0)
        {
            numberOfConnections = 0;
            [Common stopNetworkActivityIndicator];
        }
}

- (void)dealloc 
{
	if (noTileImage)
	{
		[noTileImage release];
		noTileImage = nil;
	}
	
	if (data)
		[data release];

    [super dealloc];
}

@end
