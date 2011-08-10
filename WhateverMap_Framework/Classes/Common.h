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


#if !defined(VLEN)
	#define VLEN(A)	(sqrt(A.x*A.x + A.y*A.y))
#endif


@interface Common : NSObject {

}

+ (BOOL) showConnectionIsNotAvailable;
+ (BOOL) showConnectionDidFail;
+ (void) setShowConnectionIsNotAvailable:(BOOL)newValue;
+ (void) setShowConnectionDidFail:(BOOL)newValue;


+ (int) getVersionMainNumber;
+ (void) showConnectionIsNotAvailableMessage;
+ (void) showConnectionDidFailMessage;
+ (void) showMessage:(NSString*)message withTitle:(NSString*)title;

+ (BOOL) isiPadDevice;
+ (BOOL) isiPhoneDevice;
+ (BOOL) isHeadingAvailable;
+ (void) startNetworkActivityIndicator;
+ (void) stopNetworkActivityIndicator;



@end
