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


#import "MapSourceDefinition.h"


@implementation MapSourceDefinition

@synthesize title, typeOfService, address, addressSRS, projectionKey, boundingBox, mapResolution, tileResolution, minLevel, maxLevel, deltaLevel, projectionSystem, layers, georeferencingType, coordToPixelX, coordToPixelY, pixelToCoordX, pixelToCoordY;
@synthesize numberOfPoints, visibleFromLevel, visibleToLevel, visible, alpha, alphaLock, origin, levels;
@synthesize infoSRS, infoType, infoAddress;
@synthesize pixelPoints, coordinatePoints;
@synthesize levelsResolution;


-(id)init
{
    if ((self = [super init]))
    {
		title = nil;
		typeOfService = nil;
		address = nil;
		addressSRS = nil;
		
		projectionKey = nil;
		boundingBox = BBoxMake(0, 0, 0, 0);
		mapResolution = CGSizeZero;
		tileResolution = CGSizeZero;
		
		minLevel = 0;
		maxLevel = 0;
		deltaLevel = 1;
		
		//WMS SERVICE
		projectionSystem = nil;
		layers = nil;
		
		georeferencingType = 0;
		
		coordToPixelX = nil;
		coordToPixelY = nil;
		pixelToCoordX = nil;
		pixelToCoordY = nil;
		
		pixelPoints = nil;
		coordinatePoints = nil;
		
		numberOfPoints = 0;
		
		visibleFromLevel = -1;
		visibleToLevel = 99999;
		visible = true;
		

		
		//TMS
		origin = CGPointZero;
		levels = nil;
		
		//info
		infoAddress = nil;
		infoSRS = nil;
		infoType = nil;
		
		levelsResolution = nil;
		
		alpha = 1.0;
		alphaLock = NO;
    }
    return self;
}

-(void) deriveGeoreferenceFromBBOX
{
    if (self.georeferencingType == 2)
	{
		//construct coordinates from bounding box		
		[self setGeoreferencingType:1];
		[self setNumberOfPoints:4];
		
		NSMutableArray *tmpPixelArray = [[NSMutableArray alloc] init];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.mapResolution.width, 0)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.mapResolution.height)]];
		[tmpPixelArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.mapResolution.width, self.mapResolution.height)]];
		[self setPixelPoints:tmpPixelArray];
		[tmpPixelArray release];
		
		NSMutableArray *tmpCoordArray = [[NSMutableArray alloc] init];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.boundingBox.minX, self.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.boundingBox.maxX, self.boundingBox.maxY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.boundingBox.minX, self.boundingBox.minY)]];
		[tmpCoordArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.boundingBox.maxX, self.boundingBox.minY)]];
		[self setCoordinatePoints:tmpCoordArray];
		[tmpCoordArray release];		
	}
}

- (void)dealloc
{
    [super dealloc];
}


@end
