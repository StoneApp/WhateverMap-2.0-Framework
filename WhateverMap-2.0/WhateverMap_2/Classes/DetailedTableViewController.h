//
//  DatailTableViewController.h
//  Tiling
//
//  Created by Jirka on 25.9.10.
//  Copyright 2010 Mendel University in Brno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SourceNode;

@interface DetailTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
	SourceNode *sourceNode;
	NSIndexPath *actualIndexPath;
}

@property (nonatomic, retain) SourceNode *sourceNode;

@end
