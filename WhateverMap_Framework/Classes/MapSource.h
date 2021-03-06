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

#import <Foundation/Foundation.h>
#import "typeDefinitions.h"


@class WMDataSource;

@protocol MapSourceDelegate

@required

- (void) prepareRequestForLoading:(NSString*)textUrl;

@end


@interface MapSource : NSObject {
	NSString *resultOfQueryFactory;	
	id delegate;
    WMDataSource *wmDataSource;
}


@property (nonatomic, retain) WMDataSource *wmDataSource;
@property (retain) NSString *resultOfQueryFactory;
@property (retain) id delegate;



+ (MapSource *)sharedInstance;


//- (NSString*) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row;



//DELEGATE ALTERNATIVE
//- (void) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row forDelegate:(id)aDelegate;
- (void) getNewRequestAddressByZoom: (NSInteger)zoom Column:(NSInteger)column Row:(NSInteger)row Layer:(NSInteger)layer forDelegate:(id)aDelegate;


@end
