//
//  sample4ViewController.m
//  sample4
//
//  Created by Jirka on 24.7.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "sample4ViewController.h"
#import "WMDataSource.h"
#import <QuartzCore/CoreAnimation.h>

@implementation sample4ViewController

- (void)dealloc
{
    [map release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView 
{
    [super loadView];

    BOOL perspective = YES;
    perspective = NO;

    CGRect mapFrame = [self.view frame];
    mapFrame.origin = CGPointZero;
    if (perspective)
    {
        mapFrame.origin = CGPointMake(-mapFrame.size.width/2, 0);
        mapFrame.size=CGSizeMake(mapFrame.size.width*2, mapFrame.size.height);
    }
    map = [[WMMapView alloc] initWithFrame:mapFrame];
    [map setMapDelegate:self];
    
    WMDataSource *dataSource = [[WMDataSource alloc] initWithDefaultDefinition];
    [map setWmDataSource:dataSource];
    [dataSource release];
    
    [self.view addSubview:map];   

    if (perspective)
    {
        CALayer *layer = map.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        layer.transform = rotationAndPerspectiveTransform;
    }
} 

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
