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

#import "QueryFactory.h"
#import "ExpressionWrapper.h"
#import "MapSourceDefinition.h"
#import "typeDefinitions.h"
#import "CoordConverter.h"
#import "Projection.h"  

#define PRECISION 0.0000001

@interface QueryFactory(Private)

- (BOOL) findKeyWordAndReplace:(NSString**) expression WithZoom:(NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row  inCoordinateSystem:(NSString*) coordSystem;
- (NSString*) TileXYToQuadKeyforTileX:(NSInteger) tileX tileY:(NSInteger) tileY level:(NSInteger) levelOfDetail;
- (NSString*) convertDec2Hex: (NSInteger)decNumber;
- (NSString *)convertDec2Bin:(NSInteger)input;

@end



@implementation QueryFactory

@synthesize selectedPixel, offset, zoomScale, frame, bounds, contentInset, contentOffset, maxCol, maxRow;
@synthesize mapSource;



- (id) initWithDefinition:(MapSourceDefinition*)definition
{
    if ((self = [super init]))
    {
		[self setMapSource:definition];
    }
    return self;
}

- (id) initWithDefinition:(MapSourceDefinition*)definition selectedPixel:(CGPoint)selectedPoint
{
    if ((self = [super init]))
    {
		[self setMapSource:definition];
		[self setSelectedPixel:selectedPoint];
		selectedPointIsPixel = YES;
    }
    return self;	
}

- (id) initWithDefinition:(MapSourceDefinition*)definition selectedLonLat:(CGPoint)selectedPoint
{
    if ((self = [super init]))
    {
		
		[self setMapSource:definition];
		[self setSelectedPixel:selectedPoint];
		selectedPointIsPixel = NO;
    }
    return self;	
}

- (id) initWithDefinition:(MapSourceDefinition*)definition selectedPixel:(CGPoint)selectedPoint offset:(CGPoint)offsetPoint inset:(UIEdgeInsets)contentInsetValue contentOffset:(CGPoint)contentOffsetvalue zoomScale:(double)zoom maxColumn:(NSInteger)maxColValue maxRow:(NSInteger)maxRowValue;
{
    if ((self = [super init]))
    {
		[self setMapSource:definition];
		[self setSelectedPixel:selectedPoint];
		[self setOffset:offsetPoint];
		[self setZoomScale:zoom];
		selectedPointIsPixel = YES;
    }
    return self;	
}

- (id) initWithDefinition:(MapSourceDefinition*)definition selectedLonLat:(CGPoint)selectedPoint offset:(CGPoint)offsetPoint inset:(UIEdgeInsets)contentInsetValue contentOffset:(CGPoint)contentOffsetvalue zoomScale:(double)zoom maxColumn:(NSInteger)maxColValue maxRow:(NSInteger)maxRowValue;
{
     if ((self = [super init]))
    {
		[self setMapSource:definition];
		[self setSelectedPixel:selectedPoint];
		[self setOffset:offsetPoint];
		[self setZoomScale:zoom];
		selectedPointIsPixel = NO;
    }
    return self;	
}

 
//convert result of expression to decadic, hexadecimal or binary
#define HEX @"hex:"
#define BIN @"bin:"
#define DEC @"dec:" 
//other in DEC

//help - cannot evaluate quadkey: 000 -> 0
#define QUAD @"quad:" 


//keyword === hex: dec: bin:
- (NSString*) buildQueryFromArray:(NSArray*)mapSourceAddressArray WithZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row inCoordinateSystem:(NSString*) coordSystem
{
	if (!mapSourceAddressArray || mapSourceAddressArray == nil || [mapSourceAddressArray count] == 0)
	{
		NSLog(@"Error: mapSourceAddressArray is nil or empty");
		return nil;
	}
	
	NSString *textAddress = nil;
	
	NSMutableArray *addressStringParameters = [[NSMutableArray alloc] init];
	
	
	
	//process address parameter, if there are keyWords as hex, dec output od quadkey, zoom, column, row
	NSInteger pos = 1;//first is address template for filling from 1 are parameters
	NSString *keyWord; 
	while (pos < [mapSourceAddressArray count]) 
	{		
		
		
		keyWord = [mapSourceAddressArray objectAtIndex:pos];
		
		{
			//replace keywords in expression
			NSString *expression = [keyWord lowercaseString];
			
			BOOL replaced = [self findKeyWordAndReplace:&expression WithZoom:zoom Column:column Row:row inCoordinateSystem:coordSystem];
			
			while (replaced) {
				
				if ([expression rangeOfString:@"{"].location != NSNotFound) //if there is not {} there is no sense to replace keyword which is supposed to be in {} like {zoom}
					replaced = [self findKeyWordAndReplace:&expression WithZoom:zoom Column:column Row:row inCoordinateSystem:coordSystem];
				else
					replaced = false;
			}
			
			
			//evaluate 	expression and keep in dec or convert to hex
			//HEX
			if ([expression rangeOfString:HEX].location != NSNotFound)
			{
				//remove "hex:"
				expression = [expression stringByReplacingOccurrencesOfString:HEX withString:@""];
				
//				NSInteger value = [ExpressionWrapper evaluateEquation:expression];
				ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
				NSInteger value = [expressionWrapper evaluateEquation:expression];
				[expressionWrapper release];
				
				
				if (fabs( value - roundf(value) ) < PRECISION)
					[addressStringParameters addObject:[NSString stringWithFormat:@"%@", [self convertDec2Hex:(NSInteger)value]]];					
				else
					[addressStringParameters addObject:[NSString stringWithFormat:@"%@", [self convertDec2Hex:value]]];					
				
			}
			//DEC
			else if ([expression rangeOfString:DEC].location != NSNotFound) 
			{				
				//remove "dec:"
				expression = [expression stringByReplacingOccurrencesOfString:DEC withString:@""];
				
				//double value = [ExpressionWrapper evaluateEquation:expression];				
				ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
				double value = [expressionWrapper evaluateEquation:expression];
				[expressionWrapper release];
				
				if (fabs( value - roundf(value) ) < PRECISION)
					[addressStringParameters addObject:[NSString stringWithFormat:@"%d", (NSInteger)value]];					
				else
					[addressStringParameters addObject:[NSString stringWithFormat:@"%f", value]];					
				
			}
			//BIN
			else if ([expression rangeOfString:BIN].location != NSNotFound) 
			{
				//remove "bin:"
				expression = [expression stringByReplacingOccurrencesOfString:BIN withString:@""];
				
//				NSInteger value = [ExpressionWrapper evaluateEquation:expression];
				ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
				NSInteger value = [expressionWrapper evaluateEquation:expression];
				[expressionWrapper release];
				
				
				if (fabs( value - roundf(value) ) < PRECISION)
					[addressStringParameters addObject:[NSString stringWithFormat:@"%@", [self convertDec2Bin:(NSInteger)value]]];					
				else
					[addressStringParameters addObject:[NSString stringWithFormat:@"%@", [self convertDec2Bin:value]]];					
				
			}
			//QUAD
			else if ([expression rangeOfString:QUAD].location != NSNotFound) 
			{				
				//remove "quad:"
				NSString *value = [expression stringByReplacingOccurrencesOfString:QUAD withString:@""];
								
				[addressStringParameters addObject:[NSString stringWithFormat:@"%@", value]];					
				
			}			
			//DEC
			else
			{				
				//double value = [ExpressionWrapper evaluateEquation:expression];
				ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
				double value = [expressionWrapper evaluateEquation:expression];
				[expressionWrapper release];

				
				if (fabs( value - roundf(value) ) < PRECISION)
					[addressStringParameters addObject:[NSString stringWithFormat:@"%d", (NSInteger)value]];					
				else
					[addressStringParameters addObject:[NSString stringWithFormat:@"%f", value]];					
			}
			
		}
		
		pos++;
	}
	
	
	
	
	
	// copy the object pointers from NSArray to C array
	id args[ [addressStringParameters count] ];
	NSUInteger index = 0;
	for ( id item in addressStringParameters ) 
	{
		args[ index++ ] = item;
	}
	
	//build string as URL address
	NSString * myString = [[NSString alloc] initWithFormat:[mapSourceAddressArray objectAtIndex:0] arguments:(va_list)&args[0]];
	
	textAddress = [NSString stringWithFormat:@"%@", myString];
	
	[addressStringParameters release];
	[myString release];
	
	
	
#ifdef LOG_TEXT 	
	NSLog(@"QueryFactory.m:  - address:%@", textAddress);
#endif
	
	return textAddress;
}




//key words definition:

//tile
#define ZOOM @"{zoom}"
#define COLUMN @"{column}"
#define ROW @"{row}"

//.x .y identificator - due to optimalization
#define X_PROPERTY_GROUP_IDENTIFIER @".x}"
#define Y_PROPERTY_GROUP_IDENTIFIER @".y}"



//tile group - coordinates in corners of tiles  - due to optimalization
#define TILE_GROUP_IDENTIFIER @"{tile"

#define TILE_LEFT_UPPER_X @"{tilelu.x}"
#define TILE_RIGHT_BOTTOM_X @"{tilerb.x}"
#define TILE_LEFT_BOTTOM_X @"{tilelb.x}"
#define TILE_RIGHT_UPPER_X @"{tileru.x}"
#define TILE_LEFT_UPPER_Y @"{tilelu.y}"
#define TILE_RIGHT_BOTTOM_Y @"{tilerb.y}"
#define TILE_LEFT_BOTTOM_Y @"{tilelb.y}"
#define TILE_RIGHT_UPPER_Y @"{tileru.y}"
#define TILE_RESOLUTION_X @"{tileresolution.x}"
#define TILE_RESOLUTION_Y @"{tileresolution.y}"
 


//window group - due to optimalization
#define WINDOW_GROUP_IDENTIFIER @"{window"

#define WINDOW_LEFT_UPPER_X @"{windowlu.x}"
#define WINDOW_RIGHT_UPPER_X @"{windowru.x}"
#define WINDOW_LEFT_BOTTOM_X @"{windowlb.x}"
#define WINDOW_RIGHT_BOTTOM_X @"{windowrb.x}"
#define WINDOW_LEFT_UPPER_Y @"{windowlu.y}"
#define WINDOW_RIGHT_UPPER_Y @"{windowru.y}"
#define WINDOW_LEFT_BOTTOM_Y @"{windowlb.y}"
#define WINDOW_RIGHT_BOTTOM_Y @"{windowrb.y}"
#define WINDOW_RESOLUTION_X @"{windowresolution.x}"
#define WINDOW_RESOLUTION_Y @"{windowresolution.y}"


#define QUADKEY @"{quadkey}"
#define TMS_COLUMN @"{tmscolumn}"
#define TMS_ROW  @"{tmsrow}"
#define ZOOMIFY_INDEX @"{zoomifyindex}"


#define SELECTED_GROUP_IDENTIFIER @"{selected"

#define SELECTED_PIXEL_X @"{selectedpixel.x}"
#define SELECTED_PIXEL_IN_SCREEN_X @"{selectedpixelinscreen.x}"
#define SELECTED_COORDINATION_X @"{selectedcoord.x}"
#define SELECTED_PIXEL_Y @"{selectedpixel.y}"
#define SELECTED_PIXEL_IN_SCREEN_Y @"{selectedpixelinscreen.y}"
#define SELECTED_COORDINATION_Y @"{selectedcoord.y}"

//for sign % use %% in string
#define PERCENT_SIGN @"%%"







-(BOOL) findKeyWordAndReplace:(NSString**) expression WithZoom:(NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row  inCoordinateSystem:(NSString*) coordSystem
{
	//expression is in lowercase
	
	//QUADKEY 
	//quadkey should not be evaluated because of 00 = 0 ...
	
	//init
	CoordConverter *coordConverter = [[CoordConverter alloc] initWithDefinition:mapSource];
	
    BOOL success = false;
    
	if ([(*expression) rangeOfString:ZOOM].location != NSNotFound)
	{
		*expression = [(*expression) stringByReplacingOccurrencesOfString:ZOOM withString:[NSString stringWithFormat:@"%d", zoom]];
		success = true;
	}	
	else if ([(*expression) rangeOfString:COLUMN].location != NSNotFound)
	{
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:COLUMN withString:[NSString stringWithFormat:@"%d", column]];
		success = true;
	}	
	else if ([(*expression) rangeOfString:ROW].location != NSNotFound)
	{
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:ROW withString:[NSString stringWithFormat:@"%d", row]];
		success = true;
	}	
	else if ([(*expression) rangeOfString:X_PROPERTY_GROUP_IDENTIFIER].location != NSNotFound)	
	{
		//TILE CORNERS GROUP///////////////////
		if ([(*expression) rangeOfString:TILE_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:TILE_LEFT_UPPER_X].location != NSNotFound)	
			{
				
				CGPoint pixel = CGPointMake((column) * mapSource.tileResolution.width, (row) * mapSource.tileResolution.height);				
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];				
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_LEFT_UPPER_X withString:[NSString stringWithFormat:@"%f", coord.x]];								

				success = true;
			}		
			else if ([(*expression) rangeOfString:TILE_RIGHT_BOTTOM_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column+1) * mapSource.tileResolution.width, (row+1) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];				
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RIGHT_BOTTOM_X withString:[NSString stringWithFormat:@"%f", coord.x]];

				success = true;
			}	
			else if ([(*expression) rangeOfString:TILE_LEFT_BOTTOM_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column) * mapSource.tileResolution.width, (row+1) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_LEFT_BOTTOM_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				
				success = true;
			}		
			else if ([(*expression) rangeOfString:TILE_RIGHT_UPPER_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column+1) * mapSource.tileResolution.width, (row) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RIGHT_UPPER_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				
				success = true;
			}	
			else if ([(*expression) rangeOfString:TILE_RESOLUTION_X].location != NSNotFound)	
			{
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RESOLUTION_X withString:[NSString stringWithFormat:@"%d", mapSource.tileResolution.width]];
				success = true;
			}	
		}
		
		
		//WINDOW CORNERS/////////////////////
		else if ([(*expression) rangeOfString:WINDOW_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:WINDOW_LEFT_UPPER_X].location != NSNotFound)	
			{
				CGPoint pixel = offset;
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_LEFT_UPPER_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_RIGHT_UPPER_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x + frame.size.width * zoomScale, offset.y);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RIGHT_UPPER_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_LEFT_BOTTOM_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x, offset.y + frame.size.height * zoomScale);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_LEFT_BOTTOM_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_RIGHT_BOTTOM_X].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x + frame.size.width / zoomScale, offset.y + frame.size.height / zoomScale);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RIGHT_BOTTOM_X withString:[NSString stringWithFormat:@"%f", coord.x]];
				success = true;
			}
			else if  ([(*expression) rangeOfString:WINDOW_RESOLUTION_X].location != NSNotFound)	
			{
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RESOLUTION_X withString:[NSString stringWithFormat:@"%f", bounds.size.width  ]];				
				success = true;
			}
			
		}

		//SELECTED pixel or coordinate
 		else if ([(*expression) rangeOfString:SELECTED_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:SELECTED_PIXEL_X].location != NSNotFound)	
			{
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_PIXEL_X withString:[NSString stringWithFormat:@"%f", round(selectedPixel.x)]];				
				success = true;
			}
			if ([(*expression) rangeOfString:SELECTED_PIXEL_IN_SCREEN_X].location != NSNotFound)	
			{
				double left = contentInset.left;
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_PIXEL_IN_SCREEN_X withString:[NSString stringWithFormat:@"%f", round(selectedPixel.x - contentOffset.x / zoomScale - left)]];
				success = true;
			}			
			else if ([(*expression) rangeOfString:SELECTED_COORDINATION_X].location != NSNotFound)	
			{
				CGPoint coord = CGPointZero;
						
				if (selectedPointIsPixel)
					coord = [coordConverter convertPixelToCoord:selectedPixel zoom:zoom toFormat:coordSystem];
				else 
				{
					int ret = [[Projection sharedInstance] convertLatLon:LatLonMake(selectedPixel.x, selectedPixel.y) toPoint:&coord inFormat:coordSystem];	
					if (ret != 0)			
						coord = CGPointZero;
				}
					
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_COORDINATION_X withString:[NSString stringWithFormat:@"%f", coord.x]];				
				success = true;
			}
		}
	}		
	else if ([(*expression) rangeOfString:Y_PROPERTY_GROUP_IDENTIFIER].location != NSNotFound)	
	{
		//TILE CORNERS GROUP///////////////////
		if ([(*expression) rangeOfString:TILE_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:TILE_LEFT_UPPER_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column) * mapSource.tileResolution.width, (row) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_LEFT_UPPER_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}				
			else if ([(*expression) rangeOfString:TILE_RIGHT_BOTTOM_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column+1) * mapSource.tileResolution.width, (row+1) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RIGHT_BOTTOM_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}		
			else if ([(*expression) rangeOfString:TILE_LEFT_BOTTOM_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column) * mapSource.tileResolution.width, (row+1) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_LEFT_BOTTOM_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}				
			else if ([(*expression) rangeOfString:TILE_RIGHT_UPPER_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake((column+1) * mapSource.tileResolution.width, (row) * mapSource.tileResolution.height);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RIGHT_UPPER_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}		
			else if ([(*expression) rangeOfString:TILE_RESOLUTION_Y].location != NSNotFound)	
			{
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TILE_RESOLUTION_Y withString:[NSString stringWithFormat:@"%d", mapSource.tileResolution.height]];
				success = true;
			}	
		}
		
		
		//WINDOW CORNERS/////////////////////
		else if ([(*expression) rangeOfString:WINDOW_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:WINDOW_LEFT_UPPER_Y].location != NSNotFound)	
			{
				CGPoint pixel = offset;
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_LEFT_UPPER_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_RIGHT_UPPER_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x + frame.size.width * zoomScale, offset.y);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RIGHT_UPPER_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_LEFT_BOTTOM_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x, offset.y + frame.size.height * zoomScale);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_LEFT_BOTTOM_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}
			else if ([(*expression) rangeOfString:WINDOW_RIGHT_BOTTOM_Y].location != NSNotFound)	
			{
				CGPoint pixel = CGPointMake(offset.x + frame.size.width * zoomScale, offset.y - frame.size.height * zoomScale);
				pixel = CGPointMake(pixel.x / zoomScale, pixel.y / zoomScale);
				CGPoint coord = [coordConverter convertPixelToCoord:pixel zoom:zoom toFormat:coordSystem];
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RIGHT_BOTTOM_Y withString:[NSString stringWithFormat:@"%f", coord.y]];
				success = true;
			}			
			else if ([(*expression) rangeOfString:WINDOW_RESOLUTION_Y].location != NSNotFound)	
			{
					(*expression) = [(*expression) stringByReplacingOccurrencesOfString:WINDOW_RESOLUTION_Y withString:[NSString stringWithFormat:@"%f", bounds.size.height ]];				
				success = true;
			}
		}
		
		//SELECTED pixel or coordinate
		else if ([(*expression) rangeOfString:SELECTED_GROUP_IDENTIFIER].location != NSNotFound)
		{
			if ([(*expression) rangeOfString:SELECTED_PIXEL_Y].location != NSNotFound)	
			{
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_PIXEL_Y withString:[NSString stringWithFormat:@"%f", round(selectedPixel.y)]];				
				success = true;
			}
			if ([(*expression) rangeOfString:SELECTED_PIXEL_IN_SCREEN_Y].location != NSNotFound)	
			{
				double top = contentInset.top;
				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_PIXEL_IN_SCREEN_Y withString:[NSString stringWithFormat:@"%f", round(selectedPixel.y - contentOffset.y / zoomScale - top)]];
				success = true;
			}			
			else if ([(*expression) rangeOfString:SELECTED_COORDINATION_Y].location != NSNotFound)	
			{
				CGPoint coord = CGPointZero;
				
				if (selectedPointIsPixel)
					coord = [coordConverter convertPixelToCoord:selectedPixel zoom:zoom toFormat:coordSystem];
				else 
				{
					int ret = [[Projection sharedInstance] convertLatLon:LatLonMake(selectedPixel.x, selectedPixel.y) toPoint:&coord inFormat:coordSystem];	
					if (ret != 0)			
						coord = CGPointZero;
				}

				(*expression) = [(*expression) stringByReplacingOccurrencesOfString:SELECTED_COORDINATION_Y withString:[NSString stringWithFormat:@"%f", coord.y]];				
				success = true;
			}
		}
		
		
	}
	else if ([(*expression) rangeOfString:QUADKEY].location != NSNotFound)
	{
		NSString *quadeyStr = [self TileXYToQuadKeyforTileX:column tileY:row level:zoom];
		
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:QUADKEY withString:[NSString stringWithFormat:@"%@%@", QUAD, quadeyStr]];
		success = true;
	}				
	else if ([(*expression) rangeOfString:TMS_COLUMN].location != NSNotFound)
	{
		double deltaBBox = mapSource.boundingBox.maxX - mapSource.boundingBox.minX;
		double relativeOrigin = (mapSource.origin.x - mapSource.boundingBox.minX) / deltaBBox;		
		NSInteger originColumn = maxCol * relativeOrigin;
		NSInteger TMScolumn = column - originColumn;
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TMS_COLUMN withString:[NSString stringWithFormat:@"%d", TMScolumn]];
		success = true;
	}	
	else if ([(*expression) rangeOfString:TMS_ROW].location != NSNotFound)
	{
		double deltaBBox = mapSource.boundingBox.maxY - mapSource.boundingBox.minY;
		double relativeOrigin = (mapSource.origin.y - mapSource.boundingBox.minY) / deltaBBox;
		NSInteger originRow = maxRow * relativeOrigin;
		NSInteger TMSrow = -(row - originRow); //TMS specification is in different order of axe
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:TMS_ROW withString:[NSString stringWithFormat:@"%d", TMSrow]];
		success = true;
	}	
	else if ([(*expression) rangeOfString:ZOOMIFY_INDEX].location != NSNotFound)
	{
		NSInteger tileCountUpToTier = 0;
		NSInteger z = 0;
		while (z < zoom) 
		{			
			double wf = mapSource.mapResolution.width / (pow(2,mapSource.maxLevel - z) * mapSource.tileResolution.width); 
			double hf = mapSource.mapResolution.height / (pow(2,mapSource.maxLevel - z) * mapSource.tileResolution.height); 
			NSInteger w = ceilf(wf);
			NSInteger h = ceilf(hf);
			
			tileCountUpToTier += w * h;
						
			z++;
 		}
		
		
		NSInteger actualWidthInTiles = floorf(mapSource.mapResolution.width / (pow(2,mapSource.maxLevel - zoom) * mapSource.tileResolution.width)) +1;
		NSInteger actualLevel = (column+1) + (row) * actualWidthInTiles;
		
		NSInteger tileIndex = tileCountUpToTier + actualLevel;
		
		
#ifdef LOG_TEXT		
		NSLog(@"tileIndex: %d", tileIndex);
#endif
		
		
		NSInteger tileGroupIndex = (tileIndex -1)/256;
		
		(*expression) = [(*expression) stringByReplacingOccurrencesOfString:ZOOMIFY_INDEX withString:[NSString stringWithFormat:@"%d", tileGroupIndex]];
		
		success = true;        
	}
	
    [coordConverter release];
	coordConverter = nil;
	
	return success;
}


-(NSString*) TileXYToQuadKeyforTileX:(NSInteger) tileX tileY:(NSInteger) tileY level:(NSInteger) levelOfDetail
{
	NSMutableString *quadKey;
	quadKey = [NSMutableString stringWithCapacity:levelOfDetail];
	
	for (NSInteger i = levelOfDetail; i > 0; i--)
	{
		char digit = '0';
		int mask = 1 << (i - 1);
		if ((tileX & mask) != 0)
		{
			digit++;
		}
		if ((tileY & mask) != 0)
		{
			digit++;
			digit++;
		}
		[quadKey appendString:[NSString stringWithFormat:@"%c",digit]];
	}
	return quadKey;
}






-(NSString*) convertDec2Hex: (NSInteger)decNumber 
{
	NSInteger decimal = decNumber;
	NSString* hD=@"0123456789abcdef";
	NSInteger startPos = decimal&15;
	NSString* hex = [hD substringWithRange:NSMakeRange(startPos, 1)];
	
	while (decimal > 15)
	{
		decimal>>=4;
		startPos = decimal&15;
		hex = [NSString stringWithFormat:@"%@%@", [hD substringWithRange:NSMakeRange(startPos, 1)], hex];
	}
	
	while ([hex length] <4)
	{
		hex = [NSString stringWithFormat:@"%@%@", hex, @"0"];
	}
	
	return hex;
}


-(NSString *)convertDec2Bin:(NSInteger)input
{
	if (input == 1 || input == 0)
		return [NSString stringWithFormat:@"%d", input];
	
	return [NSString stringWithFormat:@"%@%d", [self convertDec2Bin:input / 2], input % 2];
}


- (void)dealloc 
{
    if (mapSource)
		[mapSource release];
	
    [super dealloc];
}

@end
