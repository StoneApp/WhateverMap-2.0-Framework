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


@interface MapUI : NSObject {

	//ToolBar buttons
	UIBarButtonItem *toolBar_gpsButton;
	UIBarButtonItem *toolBar_compassButton;
	UIBarButtonItem *toolBar_shareButton;
	UIBarButtonItem *toolBar_informationButton;
	UIBarButtonItem *toolBar_prevHistoryButton;
	UIBarButtonItem *toolBar_nextHistoryButton;
	
	NSMutableArray* toolBarButtons;
	
}

@property (nonatomic, retain) UIBarButtonItem *toolBar_gpsButton;
@property (nonatomic, retain) UIBarButtonItem *toolBar_compassButton;
@property (nonatomic, retain) UIBarButtonItem *toolBar_shareButton;
@property (nonatomic, retain) UIBarButtonItem *toolBar_informationButton;
@property (nonatomic, retain) UIBarButtonItem *toolBar_prevHistoryButton;
@property (nonatomic, retain) UIBarButtonItem *toolBar_nextHistoryButton;

@property (nonatomic, retain) NSArray* toolBarButtons;



+ (MapUI *)sharedInstance;


- (NSArray*) createToolBarButtonsForTarget:(id)target;



@end
