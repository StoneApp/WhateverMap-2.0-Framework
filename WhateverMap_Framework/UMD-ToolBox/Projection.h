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
#import "proj_api.h"
#import "typeDefinitions.h"

@interface Projection : NSObject {
	projPJ pj_latlong;
	projPJ pj_out;
	NSString *str_out;
	projPJ pj_in;
	NSString *str_in;
	projPJ pj_lat_out;
	NSString *str_lat_out;
	projPJ pj_lat_in;
	NSString *str_lat_in;
}

+ (Projection *)sharedInstance;

- (NSInteger) convertLatLon:(LatLon)latLon toPoint:(CGPoint*)point inFormat:(NSString*)format;
- (NSInteger) convertPoint:(CGPoint)point inFormat:(NSString*)format toLatLon:(LatLon*)latLon;
- (NSInteger) convertPoint:(CGPoint)pointIn inFormat:(NSString*)formatIn toPoint:(CGPoint*)pointOut toFormat:(NSString*)formatOut;
@end
