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

#import "Projection.h"

#define BASE_PROJECTION @"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

#define LATLON_CONVERT_RAD_BTW_DEG

@implementation Projection


+ (Projection *)sharedInstance
{
	static Projection *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[Projection alloc] init];
		}
	}
	
	return instance;
}



-(id)init
{
	self = [super init];
    if (self)
    {
		str_lat_in = nil;
		str_lat_out = nil;
		str_in = nil;
		str_out = nil;
	}
    return self;
}



	/*
	 int pj_transform( projPJ srcdefn, projPJ dstdefn, long point_count, int point_offset, double *x, double *y, double *z );
	 
	 srcdefn: source (input) coordinate system.
	 
	 dstdefn: destination (output) coordinate system.
	 
	 point_count: the number of points to be processed (the size of the x/y/z arrays).
	 
	 point_offset: the step size from value to value (measured in doubles) within the x/y/z arrays - normally 1 for a packed array. May be used to operate on xyz interleaved point arrays.
	 
	 x/y/z: The array of X, Y and Z coordinate values passed as input, and modified in place for output. The Z may optionally be NULL.
	 
	 return: The return is zero on success, or a PROJ.4 error code.
	 
	 The pj_transform() function transforms the passed in list of points from the source coordinate system to the destination coordinate system. Note that geographic locations need to be passed in radians, not decimal degrees, and will be returned similarly. The "z" array may be passed as NULL if Z values are not available.
	 
	 If there is an overall failure, an error code will be returned from the function. If individual points fail to transform - for instance due to being over the horizon - then those x/y/z values will be set to HUGE_VAL on return. Input values that are HUGE_VAL will not be transformed. 
	 */


- (NSInteger) convertLatLon:(LatLon)latLon toPoint:(CGPoint*)point inFormat:(NSString*)format 
{
	if (!format || [format isEqual:@""])
	{		
		return -1;
	}
	
	if ([format isEqualToString:BASE_PROJECTION])	
	{
		(*point).x = latLon.lon;
		(*point).y = latLon.lat;
		return 0;
	}
		 
	if (!pj_latlong)
	{
		if (!(pj_latlong = pj_init_plus([BASE_PROJECTION UTF8String])) )				
		{
			return 1;
		}
	}
	
	
	if (!pj_lat_out || ![format isEqualToString:str_lat_out])
	{
		if (str_lat_out)
			[str_lat_out release];
		str_lat_out = [format retain];
		
		if (pj_lat_out) 
		{
			pj_free(pj_lat_out);
			pj_lat_out = nil;
		}
		
		if (!(pj_lat_out = pj_init_plus([format UTF8String])) )
		{
			return 1;
		}
	}
	
	double x = latLon.lon;// * DEG_TO_RAD;
	double y = latLon.lat;// * DEG_TO_RAD;


#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[BASE_PROJECTION lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[BASE_PROJECTION lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)
			
	{
		x *= DEG_TO_RAD;
		y *= DEG_TO_RAD;
	}
#endif	
	

	//source, destination, point count, 
	NSInteger ret = pj_transform(pj_latlong, pj_lat_out, 1, 1, &x, &y, NULL );


#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[format lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[format lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)		
	{
		x *= RAD_TO_DEG;
		y *= RAD_TO_DEG;
	}
#endif	
	 

#ifdef LOG_TEXT	
	
	
#endif	
	if (ret != 0)
	{
		char* err = pj_strerrno(ret);
		NSLog(@"error proj.4: %@", [NSString stringWithCString:err encoding:NSUTF8StringEncoding]);
	}
	
	(*point).x = x;
	(*point).y = y;

	
	return ret;
}

//return 0 on success
- (NSInteger) convertPoint:(CGPoint)point inFormat:(NSString*)format toLatLon:(LatLon*)latLon
{
	if (!format || [format isEqual:@""])
	{		
		return -1;
	}
	
	if ([format isEqualToString:BASE_PROJECTION])	
	{
		(*latLon).lon = point.x;
		(*latLon).lat = point.y;
		return 0;
	}
	
	if (!pj_latlong)
	{
		if (!(pj_latlong = pj_init_plus([BASE_PROJECTION UTF8String])) )				
		{
			return 1;
		}
	}
	
	if (!pj_lat_in || ![format isEqualToString:str_lat_in])
	{
		if (str_lat_in)
			[str_lat_in release];
		str_lat_in = [format retain];
		
		if (pj_lat_in) 
		{
			pj_free(pj_lat_in);
			pj_lat_in = nil;
		}
		
		if (!(pj_lat_in = pj_init_plus([format UTF8String])) )
		{
			return 1;
		}
	}


	
	double x = point.x;
	double y = point.y;
	
	
#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[format lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[format lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)			
	{
		x *= DEG_TO_RAD;
		y *= DEG_TO_RAD;
	}
#endif	
		
	NSInteger ret = pj_transform(pj_lat_in, pj_latlong, 1, 1, &x, &y, NULL );
		
#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[BASE_PROJECTION lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[BASE_PROJECTION lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)
	{
		x *= RAD_TO_DEG;
		y *= RAD_TO_DEG;
	}
#endif
	
	
	(*latLon).lon = x;
	(*latLon).lat = y;
	
	return ret;
}



- (NSInteger) convertPoint:(CGPoint)pointIn inFormat:(NSString*)formatIn toPoint:(CGPoint*)pointOut toFormat:(NSString*)formatOut
{
	if (!formatIn || [formatIn isEqual:@""] || !formatOut || [formatOut isEqual:@""])
	{		
		return -1;
	}
		
	if ([formatIn isEqualToString:formatOut])	
	{
		(*pointOut).x = pointIn.x;
		(*pointOut).y = pointIn.y;
		return 0;
	}
		
	if (!pj_in || ![formatIn isEqualToString:str_in])
	{
		if (str_in)
			[str_in release];
		str_in = [formatIn retain];

		if (pj_in) 
		{
			pj_free(pj_in);
			pj_in = nil;
		}
		
		
		if (!(pj_in = pj_init_plus([formatIn UTF8String])) )
		{
			return 1;
		}
	}
	
	if (!pj_out || ![formatOut isEqualToString:str_out])
	{
		if (str_out)
			[str_out release];
		str_out = [formatOut retain];
		
		if (pj_out) 
		{
			pj_free(pj_out);
			pj_out = nil;
		}
		
		if (!(pj_out = pj_init_plus([formatOut UTF8String])) )
		{
			return 1;
		}
	}
	
	
	double x = pointIn.x;
	double y = pointIn.y;
	
#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[formatIn lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[formatIn lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)
	{
		x *= DEG_TO_RAD;
		y *= DEG_TO_RAD;
	}
#endif
	
	//source, destination, point count, 
	NSInteger ret = pj_transform(pj_in, pj_out, 1, 1, &x, &y, NULL );
	
	
#ifdef LATLON_CONVERT_RAD_BTW_DEG	
	if (
		[[formatOut lowercaseString] rangeOfString:@"latlong"].location != NSNotFound ||
		[[formatOut lowercaseString] rangeOfString:@"longlat"].location != NSNotFound 
		)
	{
		x *= RAD_TO_DEG;
		y *= RAD_TO_DEG;
	}
#endif
	 
	(*pointOut).x = x;
	(*pointOut).y = y;
	
	return ret;
}


- (void)dealloc 
{
	if (pj_latlong)
		pj_free(pj_latlong);

	if (pj_lat_out)
		pj_free(pj_lat_out);
	if (pj_lat_in)
		pj_free(pj_lat_in);
	
	if (pj_in)
		pj_free(pj_in);
	if (pj_out)
		pj_free(pj_out);
	
	if (str_in)
		[str_in release];
	if (str_out)
		[str_out release];
	if (str_lat_in)
		[str_lat_in release];
	if (str_lat_out)
		[str_lat_out release];

	
    [super dealloc];
}


@end
