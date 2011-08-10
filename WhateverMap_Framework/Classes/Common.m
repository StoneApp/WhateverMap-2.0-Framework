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


#import "constants.h"
#import "Common.h"
#import "GCMathParser.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@implementation Common

//@synthesize showConnectionIsNotAvailable;
//@synthesize showConnectionDidFail;


static BOOL showConnectionIsNotAvailable = YES;
static BOOL showConnectionDidFail = YES;


//return version number - if 4.3.2 -> return 4
+ (int) getVersionMainNumber
{	
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	int verNum = [[currSysVer substringToIndex:1] intValue];
	return verNum;
}

+ (void) showConnectionIsNotAvailableMessage
{
#ifndef SILENT_MODE
	if(showConnectionIsNotAvailable)
	{
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Connection not available" message:@"Internet connection is not available at the moment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlertView setFrame:CGRectMake(0, 0, 90, 90)];
	
		[myAlertView show];
		[myAlertView release];
	}
	
    
	[Common setShowConnectionIsNotAvailable:FALSE];
	[Common setShowConnectionDidFail:FALSE];
#endif    
}


+ (void) showConnectionDidFailMessage
{
#ifndef SILENT_MODE    
	if(showConnectionDidFail)
	{
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Connection failed" message:@"Sorry, data connection failed while downloading." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlertView setFrame:CGRectMake(0, 0, 90, 90)];
		
		[myAlertView show];
		[myAlertView release];
	}
	
	[Common setShowConnectionIsNotAvailable:FALSE];
	[Common setShowConnectionDidFail:FALSE];
#endif    
}

+ (BOOL) showConnectionIsNotAvailable
{
    return showConnectionIsNotAvailable;
}

+ (BOOL) showConnectionDidFail
{
    return showConnectionDidFail;
}

+ (void) setShowConnectionIsNotAvailable:(BOOL)newValue
{
     showConnectionIsNotAvailable = newValue;
}

+ (void) setShowConnectionDidFail:(BOOL)newValue
{
    showConnectionDidFail = newValue;
}


+ (void) showMessage:(NSString*)message withTitle:(NSString*)title
{
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[myAlertView setFrame:CGRectMake(0, 0, 90, 90)];
	
	[myAlertView show];
	[myAlertView release];
}


+ (BOOL) isiPadDevice
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		// The device is an iPad running iOS 3.2 or later.
		return YES;
	}
	else {
		// The device is an iPhone or iPod touch.
		return NO;
	}
}

+ (BOOL) isiPhoneDevice
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		// The device is an iPad running iOS 3.2 or later.
		return NO;
	}
	else 
    {
		// The device is an iPhone or iPod touch.
		return YES;
	}
}


+ (BOOL) isHeadingAvailable
{
    BOOL isHeadingAvailable = NO;
    if ([Common getVersionMainNumber] <= 3)
    {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        isHeadingAvailable = locationManager.headingAvailable;
        [locationManager release];
    }
    else
    {
        isHeadingAvailable = [CLLocationManager headingAvailable];
    }
    
    return isHeadingAvailable;
}

+ (void) startNetworkActivityIndicator
{
	if ([UIApplication sharedApplication].networkActivityIndicatorVisible != YES)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}


+ (void) stopNetworkActivityIndicator
{
	if ([UIApplication sharedApplication].networkActivityIndicatorVisible != NO)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}


@end
