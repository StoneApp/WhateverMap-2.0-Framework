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

#import "MapUI.h"
#import "Locator.h"
#import "MapController.h"
#import "Common.h"

@implementation MapUI

@synthesize toolBar_gpsButton, toolBar_compassButton, toolBar_shareButton, toolBar_informationButton, toolBar_prevHistoryButton, toolBar_nextHistoryButton;
@synthesize toolBarButtons;



+ (MapUI *)sharedInstance
{
	static MapUI *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[MapUI alloc] init];	
		}
	}
	
	return instance;
}




- (NSArray*) createToolBarButtonsForTarget:(id)target
{	
	if (!toolBarButtons)
	{
		toolBarButtons = [[NSMutableArray alloc] initWithCapacity:6];
		NSInteger widthOfButtons = 36;
		//UIBarButtonItemStyle styleOfButtons1 = UIBarButtonItemStyleBordered;
		UIBarButtonItemStyle styleOfButtons1 = UIBarButtonItemStylePlain;
		UIBarButtonItemStyle styleOfButtons2 = UIBarButtonItemStylePlain;
		
		
		//flexible space
		UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		//GPS BUTTON
		toolBar_gpsButton = [[UIBarButtonItem alloc] init];
		toolBar_gpsButton.style = styleOfButtons1;
        UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_gps_off.png"]];
		[toolBar_gpsButton setImage:selectedImage];
        [selectedImage release];
		[toolBar_gpsButton setWidth:widthOfButtons];	
		[toolBar_gpsButton setTarget:target];
		[toolBar_gpsButton setAction:@selector(eventGPS:)];
		[toolBarButtons addObject:toolBar_gpsButton];

		//SPACE
		[toolBarButtons addObject:flexItem];	

		
		//COMPASS BUTTON
		if ([Common isHeadingAvailable])
		{
			toolBar_compassButton = [[UIBarButtonItem alloc] init];
			toolBar_compassButton.style = styleOfButtons1;
            UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_compass_off.png"]];
			[toolBar_compassButton setImage:selectedImage];
            [selectedImage release];
			[toolBar_compassButton setWidth:widthOfButtons];
			[toolBar_compassButton setTarget:target];
			[toolBar_compassButton setAction:@selector(eventCompass:)];
			[toolBarButtons addObject:toolBar_compassButton];
			
			//SPACE
			[toolBarButtons addObject:flexItem];	
		}
		

		
		//SHARE BUTTON
		toolBar_shareButton = [[UIBarButtonItem alloc] init];
		toolBar_shareButton.style = styleOfButtons1;
        UIImage *selectedImage2 = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_mail.png"]];
		[toolBar_shareButton setImage:selectedImage2];
        [selectedImage2 release];
		[toolBar_shareButton setWidth:widthOfButtons];	
		[toolBar_shareButton setTarget:target];
		[toolBar_shareButton setAction:@selector(composeMail)];
		[toolBarButtons addObject:toolBar_shareButton];
		
//		//SPACE
		[toolBarButtons addObject:flexItem];	
	
		
		//HIDE BUTTON
		toolBar_informationButton = [[UIBarButtonItem alloc] init];
		toolBar_informationButton.style = styleOfButtons1;
        UIImage *selectedImage3 = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_show_hide.png"]];
		[toolBar_informationButton setImage:selectedImage3];
        [selectedImage3 release];
		[toolBar_informationButton setWidth:widthOfButtons];	
		[toolBar_informationButton setTarget:target];
		[toolBar_informationButton setAction:@selector(eventInformation:)];
		[toolBarButtons addObject:toolBar_informationButton];
		
		//SPACE
		[toolBarButtons addObject:flexItem];	
		
		
		//HISTORY BUTTONS
		toolBar_prevHistoryButton = [[UIBarButtonItem alloc] init];
		toolBar_prevHistoryButton.style = styleOfButtons2;
        UIImage *selectedImage4 = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_left_arrow.png"]];
		[toolBar_prevHistoryButton setImage:selectedImage4];
        [selectedImage4 release];
		[toolBar_prevHistoryButton setWidth:widthOfButtons];
		[toolBar_prevHistoryButton setTarget:target];
		[toolBar_prevHistoryButton setAction:@selector(prevHistoryMovement)];
		if (![target isPrevHistoryMovement])
			[toolBar_prevHistoryButton setEnabled:NO];
		[toolBarButtons addObject:toolBar_prevHistoryButton];

		//SPACE
		[toolBarButtons addObject:flexItem];	
		
		
		toolBar_nextHistoryButton = [[UIBarButtonItem alloc] init];
		toolBar_nextHistoryButton.style = styleOfButtons2;
        UIImage *selectedImage5 = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_right_arrow.png"]];
		[toolBar_nextHistoryButton setImage:selectedImage5];
        [selectedImage5 release];
		[toolBar_nextHistoryButton setWidth:widthOfButtons];
		[toolBar_nextHistoryButton setTarget:target];
		[toolBar_nextHistoryButton setAction:@selector(nextHistoryMovement)];
		if (![target isNextHistoryMovement])		
			[toolBar_nextHistoryButton setEnabled:NO];
		[toolBarButtons addObject:toolBar_nextHistoryButton];

		
		[flexItem release];		        
	}
	
	return toolBarButtons;
}



- (void)dealloc 
{
	if (toolBar_gpsButton)
		[toolBar_gpsButton release];
	if (toolBar_compassButton)
		[toolBar_compassButton release];
	if (toolBar_prevHistoryButton)
		[toolBar_compassButton release];
	if (toolBar_nextHistoryButton)
		[toolBar_compassButton release];
	
	if (toolBarButtons)
		[toolBarButtons release];
	
	[super dealloc];
}

@end
