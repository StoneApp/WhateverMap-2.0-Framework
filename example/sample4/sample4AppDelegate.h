//
//  sample4AppDelegate.h
//  sample4
//
//  Created by Jirka on 24.7.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class sample4ViewController;

@interface sample4AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet sample4ViewController *viewController;

@end
