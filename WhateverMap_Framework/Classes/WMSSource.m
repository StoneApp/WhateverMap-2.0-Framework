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

#import "WMSSource.h"

@implementation WMSSource

@synthesize WMSAddress, WMSLayer, resolution, boundingBox;
@synthesize SRS, transparent, format, service, version, request, styles, exceptions;
@synthesize maxBoundingBox;

- (id) init
{
	self = [super init];
	if (self != nil) 
	{		
		[self setDefaultParameters];
	}
	return self;
}


- (void) setDefaultParameters
{
	//DEFAULT PARAMETERS
	[self setSRS:@"EPSG:4326"]; //WGS-84  @"EPSG:102067"; //S-JTSK
	[self setTransparent:@"TRUE"];
	[self setFormat:@"image/png"];
	[self setService:@"WMS"];
	[self setVersion:@"1.1.1"];
	[self setRequest:@"GetMap"];
	[self setStyles:@""];
	[self setExceptions:@"application/vnd.ogc.se_inimage"];
	[self setResolution:CGSizeMake(256, 256)];
	
}


- (id) initWithWMSAddress: (NSString*)address Layer:(NSString*)layer
{
	self = [super init];
	if (self != nil) 
	{		
		[self setDefaultParameters];
		if (address)
			[self setWMSAddress:address];
		
		if (layer)
			[self setWMSLayer:layer];		
	}
	return self;
}


- (NSString*) getRequest
{
	NSMutableString *tmpRequest = [[NSMutableString alloc] initWithString:@""];
	
	//exception for Metacarta
	NSRange range = [self.WMSAddress rangeOfString:@"labs.metacarta.com/wms"];
	
	//TODO if Address is append Metacarta is it right? because nil will be bad too
	if (range.location != NSNotFound)
		[tmpRequest appendString:@"http://labs.metacarta.com/wms/vmap0?"];
	else
		[tmpRequest appendFormat:@"%@", self.WMSAddress];
	
	
	
	range = [self.WMSAddress rangeOfString:@"?"];
	if (range.location == NSNotFound)
		[tmpRequest appendString:@"?"];
	
	[tmpRequest appendFormat:@"&SERVICE=%@", service];
	[tmpRequest appendFormat:@"&VERSION=%@", version];
	[tmpRequest appendFormat:@"&REQUEST=%@", request];
	[tmpRequest appendFormat:@"&SRS=%@", SRS];
	[tmpRequest appendFormat:@"&LAYERS=%@", WMSLayer];		
	[tmpRequest appendFormat:@"&TRANSPARENT=%@", transparent];
	[tmpRequest appendFormat:@"&FORMAT=%@", format];
	[tmpRequest appendFormat:@"&STYLES=%@", styles];
	[tmpRequest appendFormat:@"&EXCEPTIONS=%@", exceptions];
	NSString *bbox = [NSString stringWithFormat:@"&BBOX=%f,%f,%f,%f", boundingBox.minX, boundingBox.minY, boundingBox.maxX, boundingBox.maxY];
	[tmpRequest appendFormat:@"%@", bbox];
	NSString *width = [NSString stringWithFormat:@"&WIDTH=%.0f", resolution.width];
	NSString *height = [NSString stringWithFormat:@"&HEIGHT=%.0f", resolution.height];
	[tmpRequest appendFormat:@"%@%@", width, height];

	
#ifdef LOG_TEXT 				
	NSLog(@"WMSSource.m: Request of image from WMS: %@", tmpRequest);
#endif
	
	return [tmpRequest autorelease];
}



- (void)dealloc {
	[super dealloc];
}


@end
