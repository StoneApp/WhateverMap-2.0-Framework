//
//  sample4ViewController.h
//  sample4
//
//  Created by Jirka on 24.7.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMapView.h"

@class WMMapView;

@interface sample4ViewController : UIViewController <WMMapViewDelegate> {

    WMMapView *map;
}

@end
