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

#import "FavouriteTableViewController.h"
#import "MapController.h"
#import "SourceData.h"
#import "ParserJSON.h"
#import "SourceNode.h"
#import "DetailTableViewController.h"
#import "constants.h"
#import "MapSourceDefinition.h"
#import "constants.h"

@implementation FavouriteTableViewController


@synthesize sourceNode;
@synthesize initiator;


- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	//self.title = @"WhateverMap 2.0";
	self.title = @"Maps";
}


- (id)init 
{
    self = [super init];
    if (self) 
	{
		initiator = 0;
		sourceNode = nil;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//count of rows
	return [sourceNode getNumberOfItems];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	if ([sourceNode isMap])
	{
		//layer
		MapSourceDefinition *mapSource = nil;
		mapSource = [sourceNode getMap:indexPath.row];
		NSString *text = mapSource.title;		
		[cell.textLabel setText:text];
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
		
		//set image
        UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_earth.png"]];
		[cell.imageView setImage:selectedImage];
        [selectedImage release];
	}
	else 
	{
		NSString *text = [[sourceNode getChild:indexPath.row] title];
		
		[cell.textLabel setText:text];
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
		
		//set image
		if ([[sourceNode getChild:indexPath.row] isMap])
		{
			//map composition
            UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_composition.png"]];
			[cell.imageView setImage:selectedImage];
            [selectedImage release];
		}
		else
		{
			//folder
            UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"icon_folder.png"]];
			[cell.imageView setImage:selectedImage];
            [selectedImage release];
			
		}
		
	}
	
#ifdef __IPHONE_3_0
	//evaluate node which items are displayed
	if ([sourceNode isMap]) 
	{
		//layer
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else
	{		
		if ([[sourceNode getChild:indexPath.row] isMap])
		{
			//map composition
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		else 
		{
			//folder
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
#endif
	
	
	
	
	//chcoose Image	on right side
	/*
	 if ([[sourceNode getChild:indexPath.row] isMap])
	 {
	 UIImage *selectedImage = [UIImage imageNamed:@"checked.png"];
	 [cell.imageView setImage:selectedImage];
	 }
	 else
	 {
	 UIImage *unselectedImage = [UIImage imageNamed:@"unchecked.png"];
	 [cell.imageView setImage:unselectedImage];
	 }
	 */
	
	/*
	 if ([[[self.layersTree children] objectAtIndex:indexPath.row] name] == nil)
	 {
	 UIImage *unselectable = [UIImage imageNamed:@"layers.png"];
	 [cell.imageView.imageView setImage:unselectable];
	 }
	 */
	
	
	return cell;
}




#ifndef __IPHONE_3_0
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	//evaluate node which items are displayed
	if ([sourceNode isMap]) 
	{
		//layer
		return UITableViewCellAccessoryNone;
	}
	else
	{		
		if ([[sourceNode getChild:indexPath.row] isMap])
		{
			//map composition
			return UITableViewCellAccessoryDetailDisclosureButton;
		}
		else 
		{
			//folder
			return UITableViewCellAccessoryDisclosureIndicator;
		}
	}
}
#endif



//if user choose row with map - this method will show the chosen map
- (void) performMap:(NSIndexPath *)indexPath 
{
	//remove tile because of conflict //TODO solve and save to different directories
	NSString* tileCompositionDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", 0]];		
	[[NSFileManager defaultManager] removeItemAtPath:tileCompositionDirectory error:nil];		

	
	//layer
    SourceData *sourceData = [[SourceData sharedInstance] retain];
	[sourceData clearMapSources];
	//[[SourceData sharedInstance] addMapSource:[sourceNode getMap:indexPath.row]];
	
	[sourceData setSourceNode:sourceNode];
	[sourceData setNodeIndex:indexPath.row];
    [sourceData release];
	
    //MapController *mapController = [[MapController sharedInstance] retain];
    MapController *mapController = [[MapController alloc] init];         
	[[self navigationController] pushViewController:mapController animated:YES];	
    [mapController release];
}


//if user choose row with folder - this method will show another table view and can choose another row
- (void) performNonMap:(NSIndexPath *)indexPath 
{
	if ([[sourceNode getChild:indexPath.row] isMap])
	{
		//map composition
		
		NSMutableArray *mapSources = [[sourceNode getChild:indexPath.row] maps];
        
        SourceData *sourceData = [[SourceData sharedInstance] retain];
		[sourceData setMapSources:mapSources];
		
		[sourceData setSourceNode:sourceNode];
		[sourceData setNodeIndex:indexPath.row];
        [sourceData release];
		
		//[[MapController sharedInstance] firstSetting];
		//[[MapController sharedInstance] showMap];
		//[[self navigationController] pushViewController:[MapController sharedInstance] animated:YES];
        MapController *mapController = [[MapController alloc] init];		
		//[[self navigationController] pushViewController:[MapController refreshSharedInstance] animated:YES];
        [[self navigationController] pushViewController:mapController animated:YES];
        [mapController release];
	}
	else 
	{
		//folder
		FavouriteTableViewController *newTable = [[FavouriteTableViewController alloc] init]; 
		[newTable setSourceNode:[sourceNode getChild:indexPath.row]];		
		[self.navigationController pushViewController:newTable animated:YES];			 			 
		[newTable release];
	}			
}


- (void) performSelection:(NSIndexPath *)indexPath 
{
	if ([sourceNode isMap]) 
	{
		[self performMap:indexPath];
	}
	else
	{
		[self performNonMap:indexPath];
	}	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[self performSelection:indexPath];
}




- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	DetailTableViewController *detailTable = [[DetailTableViewController alloc] init]; 
	[detailTable setSourceNode:[sourceNode getChild:indexPath.row]];

	[self.navigationController pushViewController:detailTable animated:YES];
	
	[detailTable release]; 
}



- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 0;
}




/*
 // Override if you support editing the list
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }	
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }	
 }
 */


/*
 //Override if you support conditional editing of the list
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override if you support rearranging the list
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
 {
 //sel..reorderList 
 id tmpObject = [sharedData.sources objectAtIndex:fromIndexPath.row];
 [sharedData.sources removeObjectAtIndex:fromIndexPath.row];
 [sharedData.sources insertObject:tmpObject atIndex:toIndexPath.row];
 
 }
 */


/*
 // Override if you support conditional rearranging of the list
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


//////////






- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewWillAppear:(BOOL)animated
{
	
	if (sourceNode == nil) 
	{			
		ParserJSON* parser = [[ParserJSON alloc] init];
		[parser loadAndSetRootNode:DEFAULT_UPDATE_DEFINITION_URL update:NO overWrite:NO];
		[parser release];

		[self setSourceNode:[[SourceData sharedInstance] sourceNode]];	
	}
	

	
}


- (void)viewDidAppear:(BOOL)animated
{
#ifdef NO_SINGLE_SOURCE_FAVOURITE_LIST	
	if ([sourceNode getNumberOfItems] == 1)
	{
		if (initiator == 0)
		{
			[self performSelection:[NSIndexPath indexPathForRow:0 inSection:0]];
			//[self select:<#(id)sender#>]
			//[self.navigationController pushViewController:[MapController sharedInstance] animated:YES];			 			 
			initiator = 1;
		}
		else	
			//if (initiator != 0)
		{
			DetailTableViewController *detailTable = [[DetailTableViewController alloc] init]; 
			[detailTable setSourceNode:[sourceNode getChild:0]];
			
			[self.navigationController pushViewController:detailTable animated:YES];
			
			[detailTable release]; 
			
			initiator = 0;
		}
	}
#endif	
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	[super dealloc];
}


@end

