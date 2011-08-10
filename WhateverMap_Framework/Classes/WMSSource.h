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
#import <Foundation/Foundation.h> //NSURLConnecrion
#import "typeDefinitions.h"
 
@interface WMSSource : NSObject {
	NSString *WMSAddress;
	NSString *WMSLayer;

	CGSize resolution;
	BBox boundingBox;
	CGPoint delta;
	CGPoint maxDelta;
	
	CGPoint centerPoint;
	CGPoint GPSPoint;
	
	NSString *SRS;
	NSString *transparent;
	NSString *format;
	NSString *service;
	NSString *version;
	NSString *request;
	NSString *styles;
	NSString *exceptions;	
	
	BBox maxBoundingBox;
	CGPoint boundingBoxCenter;
	
	NSMutableData *data;
}

@property(nonatomic, retain) NSString *WMSAddress;
@property(nonatomic, retain) NSString *WMSLayer;

@property(assign) CGSize resolution;

@property(assign) BBox boundingBox;

@property(nonatomic, retain) NSString *SRS;
@property(nonatomic, retain) NSString *transparent;
@property(nonatomic, retain) NSString *format;
@property(nonatomic, retain) NSString *service;
@property(nonatomic, retain) NSString *version;
@property(nonatomic, retain) NSString *request;
@property(nonatomic, retain) NSString *styles;
@property(nonatomic, retain) NSString *exceptions;

@property(assign) BBox maxBoundingBox;




- (id) initWithWMSAddress: (NSString*)address Layer:(NSString*)layer;
- (void) setDefaultParameters;
- (NSString*) getRequest;

@end
