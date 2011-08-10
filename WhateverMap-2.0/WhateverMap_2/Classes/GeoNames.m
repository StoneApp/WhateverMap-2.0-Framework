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

#import "GeoNames.h"
#import "typeDefinitions.h"
#import "JSON.h"

@implementation GeoNames


//generate URL for a query
//URL example
//http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=true_or_false
- (NSString*) getResultForText: (NSString*) textWithGeonames;
{	
	NSString *textURL = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",[self urlEncodeString:textWithGeonames UsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:textURL];
	
	textResult = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
	return textResult;
}


//get LatLon from JSON returned by generated URL address
- (BOOL) getLocation:(LatLon*)latLon ForGeoname: (NSString*) textWithGeonames
{
	NSString* result = [self getResultForText:textWithGeonames];
	id objectJSON = [result JSONValue];
	
	if ([objectJSON isKindOfClass:[NSDictionary class]])
	{
		NSString* status = [objectJSON valueForKey:@"status"];
		
		if ([status rangeOfString:@"OK"].location != NSNotFound)
		{
			id results = [objectJSON valueForKey:@"results"];
			id geometry = [results valueForKey:@"geometry"];
			id location = [geometry valueForKey:@"location"];
			
			id lon = [location valueForKey:@"lng"];
			id lat = [location valueForKey:@"lat"];
			
			if (lon && lat)
			{
				(*latLon).lon = [[lon objectAtIndex:0] doubleValue];
				(*latLon).lat = [[lat objectAtIndex:0] doubleValue];
				return true;
			}			
		}		
	}
	
	return false;
}
 

//inspired at http://madebymany.co.uk/url-encoding-an-nsstring-on-ios-004453
- (NSString*) urlEncodeString: (NSString *)text UsingEncoding:(NSStringEncoding)encoding 
{
	
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																(CFStringRef)text,
																NULL,
																(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																CFStringConvertNSStringEncodingToEncoding(encoding)) autorelease];
}

@end
