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

#import "ConnectionReachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"

@implementation ConnectionReachability

@synthesize statusString;
@synthesize isConnected;


+ (ConnectionReachability *)sharedInstance
{
	static ConnectionReachability *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[ConnectionReachability alloc] init];
		}
	}
	
	return instance;
}

//check connection property
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
			[self setIsConnected:FALSE];
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
			[self setIsConnected:TRUE];
			//isConnected = true;
            break;
        }
        case ReachableViaWiFi:
        {
			statusString= @"Reachable WiFi";
			[self setIsConnected:TRUE];
            break;
		}
		default:
		{
			[self setIsConnected:FALSE];
		}
    }
}


//start notifier and define method for update
- (void) startUpdate
{
	//CONNECTION
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability: internetReach];
}


@end
