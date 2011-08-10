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

#import "CoordConverter.h"
#import "MapSourceDefinition.h"
#import "ExpressionWrapper.h"
#import "Projection.h"
#import "AffineTransformation.h"
#import "BilinearInterpolation.h"

#if !defined(VLEN)
#define VLEN(A)	(sqrt(A.x*A.x + A.y*A.y))
#endif

@implementation CoordConverter

@synthesize mapSource;




- (id) initWithDefinition:(MapSourceDefinition*)definition
{
    if ((self = [super init]))
    {
		[self setMapSource:definition];
    }
    return self;
}






//////////////////////////
//LONLAT -> COORD -> PIXEL

- (CGPoint) convertLatLonToPixel:(LatLon)latLon zoom:(double)zoomLevel
{
	CGPoint coord = [self convertLatLonToCoord:latLon];
	CGPoint pixel = [self convertCoordToPixel:coord zoom:zoomLevel];
	return pixel;
}


- (CGPoint) convertCoordToPixel:(CGPoint)coord zoom:(double)zoomLevel inFormat:(NSString*)format
{
	CGPoint newCoord = [self convertCoord:coord inFormat:format];
	CGPoint pixel = [self convertCoordToPixel:newCoord zoom:zoomLevel];
	return pixel;	
}


//convert coordination of map to lon/lat
- (CGPoint) convertLatLonToCoord:(LatLon)latLon
{
	//cut values by boundingBox   //TODO cut boundingbox is in different units maybe? output is alwayes in degrees but BBox is not   //TODO dodelat zatim reze podle BBox v degree neni universalni
	double x = [self clipNumber:latLon.lon MinValue:-180 MaxValue:180]; 
	double y = [self clipNumber:latLon.lat MinValue:-90 MaxValue:90];	
	LatLon newLatLon = LatLonMake(y, x);
	
	//translate lonLat coordinates to specified projection
	CGPoint coordTranslated;	
	
	int ret = [[Projection sharedInstance] convertLatLon:newLatLon toPoint:&coordTranslated inFormat:mapSource.projectionKey];	
	if (ret != 0)			
		coordTranslated = CGPointZero;
	
	return coordTranslated;
}


- (CGPoint) convertCoordToPixel:(CGPoint)coord zoom:(double)zoomLevel
{
	CGPoint relativePixel = [self convertCoordToPixelRelative:CGPointMake(coord.x, coord.y)];
	
	double mapSizeX = mapSource.mapResolution.width / pow(2, (mapSource.maxLevel - zoomLevel)); 
	double mapSizeY = mapSource.mapResolution.height / pow(2, (mapSource.maxLevel - zoomLevel));
	
	//compute relative pixel coordination - do not depend on zoom level
	double absoluteX = (relativePixel.x * mapSizeX);
	double absoluteY = (relativePixel.y * mapSizeY);
	
	return CGPointMake(absoluteX, absoluteY);
}


- (CGPoint) convertCoord:(CGPoint)coord inFormat:(NSString*)format
{
	NSInteger ret = [[Projection sharedInstance] convertPoint:coord inFormat:format toPoint:&coord toFormat:mapSource.projectionKey];				
	if (ret != 0)			
		coord = CGPointZero;
	
	return coord;	
}


- (CGPoint) convertLatLonToPixelRelative:(LatLon)latLon;
{
	CGPoint coord = [self convertLatLonToCoord:latLon];
	CGPoint pixelRelative = [self convertCoordToPixelRelative:coord];
	return pixelRelative;
}




//convert relative position of pixel to coordination
//RETURN RELATIVE POSITION:  100 (pixels) * 0.5 (relative value) = 50 (pixels)
//do not depend on zoom level
- (CGPoint) convertCoordToPixelRelative:(CGPoint)coord
{
	double pixelX, pixelY;
	if (mapSource.georeferencingType == 1) //PLANE LINEARNI KONFORM TRANSFORMATION (rovinna linearni konformni transformace)
	{		
		if(mapSource.numberOfPoints == 2)
		{
			CGPoint X = CGPointMake(coord.x, coord.y);
			CGPoint P = [[[mapSource coordinatePoints] objectAtIndex:0] CGPointValue];//first point 
			CGPoint Q = [[[mapSource coordinatePoints] objectAtIndex:1] CGPointValue];//second point
						
			//WE NEED TO KNOW ABOUT AXES WHICH DIRECTION IS + AND WHICH -
			BOOL plusX = true;
			BOOL plusY = false;
			if (!plusX)			
			{
				X.x = -X.x;
				P.x = -P.x;
				Q.x = -Q.x;
			}
			if (!plusY)			
			{
				X.y = -X.y;
				P.y = -P.y;
				Q.y = -Q.y;
			}
			CGPoint P2 = [[[mapSource pixelPoints] objectAtIndex:0] CGPointValue];
			CGPoint Q2 = [[[mapSource pixelPoints] objectAtIndex:1] CGPointValue];
			
			//MODIFIED WARPING 				
			CGPoint XP = CGPointMake(X.x - P.x, X.y - P.y);
			CGPoint QP = CGPointMake(Q.x - P.x, Q.y - P.y);
			CGPoint QP2 = CGPointMake(Q2.x - P2.x, Q2.y - P2.y);
			
			double u = (XP.x * QP.x + XP.y * QP.y) / (VLEN(QP) * VLEN(QP));
			double v = (XP.x * (-QP.y) + XP.y * QP.x) / VLEN(QP);
			
			//oproti warpovani je nutne udelat prevod mezi delkami - v je vzdalenost od primky ta se lisi !!!!!
			double vRel = v/VLEN(QP); 
			v = vRel *VLEN(QP2);
			
			pixelX = P2.x + u*QP2.x + v*(-QP2.y)/VLEN(QP2);
			pixelY = P2.y + u*QP2.y + v*QP2.x/VLEN(QP2); 
			
			pixelX /= mapSource.mapResolution.width;
			pixelY /= mapSource.mapResolution.height;
		} 
		else if (mapSource.numberOfPoints == 3) //AFFINE TRANSFORMATION
		{
			CGPoint coordinates[3];
			for (int k = 0; k < 3; k++)
				coordinates[k] = [[mapSource.coordinatePoints objectAtIndex:k] CGPointValue];
			
			CGPoint points[3];
			for (int k = 0; k < 3; k++)
				points[k] = [[mapSource.pixelPoints objectAtIndex:k] CGPointValue];
				
			CGPoint pixel = [AffineTransformation AffineTransformationFrom:coordinates ToPoints:points OfPoint:coord];
			
			pixelX = pixel.x/mapSource.mapResolution.width;
			pixelY = pixel.y/mapSource.mapResolution.height;
		}
		else if (mapSource.numberOfPoints == 4) //LINEAR INTERPOLATION
		{
			CGPoint coordinates[4];
			for (int k = 0; k < 4; k++)
				coordinates[k] = [[mapSource.coordinatePoints objectAtIndex:k] CGPointValue];
			
			CGPoint points[4];
			for (int k = 0; k < 4; k++)
				points[k] = [[mapSource.pixelPoints objectAtIndex:k] CGPointValue];

			
			CGPoint X = CGPointMake(coord.x, coord.y);
			

			CGPoint parameters = [BilinearInterpolation InverseBilinearInterpolationOfPoints:coordinates WithPoint:X];
			CGPoint newX = [BilinearInterpolation BilinearInterpolationOfPoints:points WithParameter:parameters];
			
			pixelX = newX.x/mapSource.mapResolution.width;
			pixelY = newX.y/mapSource.mapResolution.height;
		}
		else 
		{
			return CGPointZero;
		}

		//else if (mapSource.numberOfPoints > 4) //POLYNOMIAL INTERPOLATION
		
		
	}
	else  //==0 //COMPUTE BY SPECIFIED EQUATIONS
	{
		//substitude X and Y by number with longitude and latitude and evaluate those strings
		NSString *equationX = [mapSource.coordToPixelX lowercaseString];
		if ([equationX rangeOfString:@"{x}"].location != NSNotFound)
			equationX = [equationX stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat:@"%f", coord.x]];
		if ([equationX rangeOfString:@"{y}"].location != NSNotFound)
			equationX = [equationX stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%f", coord.y]];

		//pixelX = [ExpressionWrapper evaluateEquation:equationX];
		ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
		pixelX = [expressionWrapper evaluateEquation:equationX];
		[expressionWrapper release];
		
		
		NSString *equationY = [mapSource.coordToPixelY lowercaseString];
		if ([equationY rangeOfString:@"{x}"].location != NSNotFound)
			equationY = [equationY stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat:@"%f", coord.x]];
		if ([equationY rangeOfString:@"{y}"].location != NSNotFound)
			equationY = [equationY stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%f", coord.y]];
		
		//pixelY = [ExpressionWrapper evaluateEquation:equationY];
		expressionWrapper =[[ExpressionWrapper alloc] init];
		pixelY = [expressionWrapper evaluateEquation:equationY];
		[expressionWrapper release];
		
	}	
	
	
	return CGPointMake(pixelX, pixelY);
}



//////////////////////////
//PIXEL -> COORD -> LONLAT

- (LatLon) convertPixelToLatLon:(CGPoint)pixel zoom:(double)zoomLevel
{	
	CGPoint coord = [self convertPixelToCoord:pixel zoom:zoomLevel];
	LatLon latLon = [self convertCoordToLatLon:coord];
	
	//test
	//CGPoint tmp =[self LatLonToPixelUniversal:latLon zoom:zoomLevel];
	
	return latLon;
}


- (CGPoint) convertPixelToCoord:(CGPoint)pixel zoom:(double)zoomLevel toFormat:(NSString*)format
{
	CGPoint coord = [self convertPixelToCoord:pixel zoom:zoomLevel];

#ifdef LOG_TEXT
	//NSLog(@"coord: %f, %f", coord.x, coord.y);
#endif	
	
	CGPoint newCoord = [self convertCoord:coord toFormat:format];

#ifdef LOG_TEXT
	//NSLog(@"transformed coord: %f, %f", newCoord.x, newCoord.y);
#endif	
	
	
	return newCoord;
}




- (CGPoint) convertPixelToCoord:(CGPoint)pixel zoom:(double)zoomLevel
{
	double mapSizeX = mapSource.mapResolution.width / pow(2, (mapSource.maxLevel - zoomLevel));
	double mapSizeY = mapSource.mapResolution.height / pow(2, (mapSource.maxLevel - zoomLevel));
	
	//compute relative pixel coordination - do not depend on zoom level
	double x = (pixel.x / mapSizeX);
	double y = (pixel.y / mapSizeY);
	
	CGPoint coord = [self convertPixelToCoordRelative:CGPointMake(x, y)];
	return coord;
}





//convert relative position of pixel to coordination
//TAKE RELATIVE POSITION:  100 (pixels) * 0.5 (relative value) = 50 (pixels)
//do not depend on zoom level
- (CGPoint) convertPixelToCoordRelative:(CGPoint) relativePixel
{
	double coordX = 0;
	double coordY = 0;
	if (mapSource.georeferencingType == 1) //PLANE LINEARNI KONFORM TRANSFORMATION (rovinna linearni konformni transformace)
	{		
		if(mapSource.numberOfPoints == 2)
		{
			CGPoint X = CGPointMake(relativePixel.x*mapSource.mapResolution.width, relativePixel.y*mapSource.mapResolution.height);//point in pixel coordinate of full resolution image
			
			CGPoint P = [[[mapSource pixelPoints] objectAtIndex:0] CGPointValue];
			CGPoint Q = [[[mapSource pixelPoints] objectAtIndex:1] CGPointValue];
			
			//WE NEED TO KNOW ABOUT AXES WHICH DIRECTION IS + AND WHICH -
			BOOL plusX = true;
			BOOL plusY = false;
			if (!plusX)			
			{
				X.x = -X.x;
				P.x = -P.x;
				Q.x = -Q.x;
			}
			if (!plusY)			
			{
				X.y = -X.y;
				P.y = -P.y;
				Q.y = -Q.y;
			}
			CGPoint P2 = [[[mapSource coordinatePoints] objectAtIndex:0] CGPointValue];
			CGPoint Q2 = [[[mapSource coordinatePoints] objectAtIndex:1] CGPointValue];			
			
			//MODIFIED WARPING 				
			CGPoint XP = CGPointMake(X.x - P.x, X.y - P.y);
			CGPoint QP = CGPointMake(Q.x - P.x, Q.y - P.y);
			CGPoint QP2 = CGPointMake(Q2.x - P2.x, Q2.y - P2.y);
			
			double u = (XP.x * QP.x + XP.y * QP.y) / (VLEN(QP) * VLEN(QP));
			double v = (XP.x * (-QP.y) + XP.y * QP.x) / VLEN(QP);
			
			//oproti warpovani je nutne udelat prevod mezi delkami - v je vzdalenost od primky ta se lisi !!!!!
			double vRel = v/VLEN(QP); 
			v = vRel *VLEN(QP2);
			
			coordX = P2.x + u*QP2.x + v*(-QP2.y)/VLEN(QP2);
			coordY = P2.y + u*QP2.y + v*QP2.x/VLEN(QP2);
		} 
		else if (mapSource.numberOfPoints == 3) //AFFINE TRANSFORMATION
		{
			CGPoint coordinates[3];
			for (int k = 0; k < 3; k++)
				coordinates[k] = [[mapSource.coordinatePoints objectAtIndex:k] CGPointValue];
			
			CGPoint points[3];
			for (int k = 0; k < 3; k++)
				points[k] = [[mapSource.pixelPoints objectAtIndex:k] CGPointValue];

			
			CGPoint pixel = CGPointMake(relativePixel.x*mapSource.mapResolution.width, relativePixel.y*mapSource.mapResolution.height);
			CGPoint coord = [AffineTransformation AffineTransformationFrom:points ToPoints:coordinates OfPoint:pixel];
			
			coordX = coord.x;
			coordY = coord.y;
		}
		else if (mapSource.numberOfPoints == 4) //LINEAR INTERPOLATION
		{
			CGPoint coordinates[4];
			for (int k = 0; k < 4; k++)
				coordinates[k] = [[[mapSource coordinatePoints] objectAtIndex:k] CGPointValue];
			
			CGPoint points[4];
			for (int k = 0; k < 4; k++)
				points[k] = [[[mapSource pixelPoints] objectAtIndex:k] CGPointValue];
			
			CGPoint X = CGPointMake(relativePixel.x*mapSource.mapResolution.width, relativePixel.y*mapSource.mapResolution.height);
			
			CGPoint parameters = [BilinearInterpolation InverseBilinearInterpolationOfPoints:points WithPoint:X];
			CGPoint newX = [BilinearInterpolation BilinearInterpolationOfPoints:coordinates WithParameter:parameters];
			
			coordX = newX.x;
			coordY = newX.y;
		}
		else 
		{
			return CGPointZero;
		}

		//else if (mapSource.numberOfPoints > 4) //POLYNOMIAL INTERPOLATION
	}
	else  //==0 //COMPUTE BY SPECIFIED EQUATIONS
	{
		//substitude X and Y by number with longitude and latitude and evaluate those strings
		NSString *equationX = [mapSource.pixelToCoordX lowercaseString];
		if ([equationX rangeOfString:@"{x}"].location != NSNotFound)
			equationX = [equationX stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat:@"%f", relativePixel.x]];
		if ([equationX rangeOfString:@"{y}"].location != NSNotFound)
			equationX = [equationX stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%f", relativePixel.y]];

		//coordX = [ExpressionWrapper evaluateEquation:equationX];
		ExpressionWrapper *expressionWrapper =[[ExpressionWrapper alloc] init];
		coordX = [expressionWrapper evaluateEquation:equationX];
		[expressionWrapper release];
		
		
		NSString *equationY = [mapSource.pixelToCoordY lowercaseString];
		if ([equationY rangeOfString:@"{x}"].location != NSNotFound)
			equationY = [equationY stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat:@"%f", relativePixel.x]];
		if ([equationY rangeOfString:@"{y}"].location != NSNotFound)
			equationY = [equationY stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat:@"%f", relativePixel.y]];
		
		//coordY = [ExpressionWrapper evaluateEquation:equationY];
		expressionWrapper =[[ExpressionWrapper alloc] init];
		coordY = [expressionWrapper evaluateEquation:equationY];
		[expressionWrapper release];
		
	}	
	
	return CGPointMake(coordX, coordY);
}



//convert coordination of map to lon/lat
- (LatLon) convertCoordToLatLon:(CGPoint)coord
{
	//translate lonLat coordinates to specified projection
	LatLon latLonTranslated;	
	
	int ret = [[Projection sharedInstance] convertPoint:coord inFormat:mapSource.projectionKey toLatLon:&latLonTranslated];	
	if (ret != 0)			
		latLonTranslated = LatLonMake(0, 0);
	
	//cut values by boundingBox   //TODO cut boundingbox is in different units maybe? output is alwayes in degrees but BBox is not   //TODO dodelat zatim reze podle BBox v degree neni universalni
	double lon = [self clipNumber:latLonTranslated.lon MinValue:-180 MaxValue:180]; 
	double lat = [self clipNumber:latLonTranslated.lat MinValue:-90 MaxValue:90];	
	
	return LatLonMake(lat, lon);	
}

//convert coordination of map to anorher coordination system
- (CGPoint) convertCoord:(CGPoint)coord toFormat:(NSString*)format
{
	NSInteger ret = [[Projection sharedInstance] convertPoint:coord inFormat:mapSource.projectionKey toPoint:&coord toFormat:format];				
	if (ret != 0)			
		coord = CGPointZero;

	return coord;
}


- (NSInteger) mapSize:(NSInteger)levelOfDetail
{
	//TODO TILE_SIZE
	return (NSInteger) 256 << levelOfDetail;
}


- (double) clipNumber:(double)number MinValue:(double)minValue MaxValue:(double)maxValue
{
	return MIN(MAX(number, minValue), maxValue);
}


@end
