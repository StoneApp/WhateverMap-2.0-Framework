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

#import "DetailTableViewController.h"
#import "DetailCustomCell.h"
#import "SourceNode.h"
#import "typeDefinitions.h"
#import "CustomUISlider.h"
#import "constants.h"
#import "ParserJSON.h"
#import "TiledScrollView.h"
#import "SourceData.h"
#import "MapSourceDefinition.h"
#import "Common.h"
#import "MapController.h"

@implementation DetailTableViewController

@synthesize sourceNode;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
}


//save changes of layers settings
- (void) saveChanges
{
	[[ParserJSON sharedInstance] saveRootNode:sourceNode];
}


- (void)turnOnEditing 
{
	[self.navigationItem.rightBarButtonItem release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(turnOffEditing)];
	[self.tableView setEditing:YES animated:YES];
}

- (void)turnOffEditing 
{
	[self.navigationItem.rightBarButtonItem release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(turnOnEditing)];
	[self.tableView setEditing:NO animated:YES];
	
	[self saveChanges];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[[self.navigationController toolbar] setItems:[self createToolBarItems] animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	[self saveChanges];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [sourceNode getNumberOfItems];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"DetailCustomCell";
    
    DetailCustomCell *cell = (DetailCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DetailCustomCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects)
		{
			if ([currentObject isKindOfClass:[DetailCustomCell class]]) 
			{
				cell = (DetailCustomCell*) currentObject;
				break;
			}
		}
    }
    
	
    // Configure the cell...
	MapSourceDefinition *mapSource = nil;
	mapSource = [sourceNode getMap:([sourceNode getNumberOfItems] - [indexPath row] - 1)];
	[cell.titleLabel setText:mapSource.title];
	[cell.alphaSlider setValue:mapSource.alpha];
	[cell.alphaSlider addTarget:self action:@selector(sliderUpdate:) forControlEvents:UIControlEventValueChanged];
	[(CustomUISlider*)cell.alphaSlider setRow:[indexPath row]];
	
#ifdef DISABLE_FIRST_LAYER_MANIPULATION	
	if (([sourceNode getNumberOfItems] - [indexPath row] - 1) == 0)
		[cell.alphaSlider setEnabled:NO];
#endif
	
	if (mapSource.visible)
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	else 
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	
	if (mapSource.alphaLock)
	{
		[cell.alphaSlider setEnabled:NO];
		[cell.alphaSlider setHidden:YES];
	}
	else
	{
		[cell.alphaSlider setEnabled:YES];
		[cell.alphaSlider setHidden:NO];
	}
	
    
    return cell;
}


- (void) sliderUpdate:(UISlider*)slider
{
	NSInteger row = [(CustomUISlider*)slider row];
	MapSourceDefinition *mapSource = nil;
	mapSource = [sourceNode getMap:row];
	mapSource.alpha = slider.value;
	[sourceNode replaceMap:mapSource atIndex:row];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
	//return NO;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	if ([fromIndexPath row] != [toIndexPath row])
	{
		MapSourceDefinition *fromMap = nil;
		fromMap = [sourceNode getMap:[fromIndexPath row]];
		MapSourceDefinition *toMap = nil;
		toMap = [sourceNode getMap:[toIndexPath row]];
					
		[sourceNode replaceMap:fromMap atIndex:[toIndexPath row]];
		
		[sourceNode replaceMap:toMap atIndex:[fromIndexPath row]];
		
		
		//rename cache directories
		NSString* toTileDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d/%d", 0, [toIndexPath row]]];
		NSString* fromTileDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d/%d", 0, [fromIndexPath row]]];
		NSString* tmpTileDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d/%d", 0, 9999999]];
		
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSError *error = nil;
		if ([fileMgr moveItemAtPath:toTileDirectory toPath:tmpTileDirectory error:&error] != YES)		
			NSLog(@"Unable to rename directory1: %@", [error localizedDescription]);
		if ([fileMgr moveItemAtPath:fromTileDirectory toPath:toTileDirectory error:&error] != YES)
			NSLog(@"Unable to rename directory2: %@", [error localizedDescription]);
		if ([fileMgr moveItemAtPath:tmpTileDirectory toPath:fromTileDirectory error:&error] != YES)
			NSLog(@"Unable to rename directory3: %@", [error localizedDescription]);
		
		
#ifdef DISABLE_FIRST_LAYER_MANIPULATION			
		//basemap must be visible - first map and alpha to 1
		if (([fromIndexPath row] == 0) || ([toIndexPath row] == 0))
		{
			MapSourceDefinition baseMap = [sourceNode getMap:0];
			if (!baseMap.visible)
			{
				baseMap.visible = true;
				[sourceNode replaceMap:baseMap atIndex:0];
			}
			if (baseMap.alpha < 1)
				baseMap.alpha = 1.0;
			

			[((DetailCustomCell*)[tableView cellForRowAtIndexPath:toIndexPath]).alphaSlider setEnabled:YES];
			[((DetailCustomCell*)[tableView cellForRowAtIndexPath:fromIndexPath]).alphaSlider setEnabled:YES];
			
			if ([fromIndexPath row] == 0)
			{
				NSIndexPath* baseIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
				[((DetailCustomCell*)[tableView cellForRowAtIndexPath:baseIndexPath]).alphaSlider setEnabled:NO];
				[((DetailCustomCell*)[tableView cellForRowAtIndexPath:baseIndexPath]).alphaSlider setValue:1];				
				[[tableView cellForRowAtIndexPath:baseIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
			}	
			
			if ([toIndexPath row] == 0) 
			{
				[((DetailCustomCell*)[tableView cellForRowAtIndexPath:fromIndexPath]).alphaSlider setEnabled:NO];
				[((DetailCustomCell*)[tableView cellForRowAtIndexPath:fromIndexPath]).alphaSlider setValue:1];
				[[tableView cellForRowAtIndexPath:fromIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

			}
		}
#endif	
	}
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Detemine if it's in editing mode
    //if (self.editing) {
    //    return UITableViewCellEditingStyleDelete;
    //}
	
    return UITableViewCellEditingStyleNone;
	
	//return UITableViewCellEditingStyleInsert;
	
	//Undocumenter feature - allow to move only - no delete action
	//return 4;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	actualIndexPath = indexPath;
	DetailCustomCell *cell = (DetailCustomCell*)[tableView cellForRowAtIndexPath:indexPath];
	
#ifdef DISABLE_FIRST_LAYER_MANIPULATION		
	if (([sourceNode getNumberOfItems] - [indexPath row] - 1) != 0)
#endif		
	{
		if ([cell accessoryType] == UITableViewCellAccessoryNone)
		{
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			MapSourceDefinition *mapSource = nil;
			mapSource = [sourceNode getMap:([sourceNode getNumberOfItems] - [indexPath row] - 1)];
			mapSource.visible = true;
			[sourceNode replaceMap:mapSource atIndex:([sourceNode getNumberOfItems] - [indexPath row] - 1)];
		}
		else
		{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
			MapSourceDefinition *mapSource = nil;
			mapSource = [sourceNode getMap:([sourceNode getNumberOfItems] - [indexPath row] - 1)];
			mapSource.visible = false;
			[sourceNode replaceMap:mapSource atIndex:([sourceNode getNumberOfItems] - [indexPath row] - 1)];
			
		}
	}
	
	
#ifdef EXCLUSIVE_LAYER_ONE_OR_TWO	
	//Exclusively choose first or second layer
	if (([indexPath row] == [sourceNode getNumberOfItems]-1) || ([indexPath row] == [sourceNode getNumberOfItems]-2))
	{
		NSInteger index, indexR;

		if ([indexPath row] == [sourceNode getNumberOfItems]-1)
			indexR = 1;
		else 
			indexR = 0;

		
		if ([indexPath row] == [sourceNode getNumberOfItems]-1)
			index = [sourceNode getNumberOfItems] - 2;
		else 
			index = [sourceNode getNumberOfItems] - 1;
		
		if ([cell accessoryType] == UITableViewCellAccessoryNone)
		{
			MapSourceDefinition mapSource = [sourceNode getMap:indexR];
			mapSource.visible = true;
			[sourceNode replaceMap:mapSource atIndex:indexR];

			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			[((DetailCustomCell*)[tableView cellForRowAtIndexPath:indexPath]) setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		else
		{
			MapSourceDefinition mapSource = [sourceNode getMap:indexR];
			mapSource.visible = false;
			[sourceNode replaceMap:mapSource atIndex:indexR];
			
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			[((DetailCustomCell*)[tableView cellForRowAtIndexPath:indexPath]) setAccessoryType:UITableViewCellAccessoryNone];

		}
	}
#endif //EXCLUSIVE_LAYER_ONE_OR_TWO
	
}


//create toolbar visible in a bottom of a display
- (NSArray*) createToolBarItems
{
	NSMutableArray* toolBarButtons = [[NSMutableArray alloc] init];

	//FLEXIBLE SPACE
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[toolBarButtons addObject:flexItem];
	
	//CLEAR TILE CACHE
	[toolBarButtons addObject:[self createClearCacheButton]];		
	
	[toolBarButtons addObject:flexItem];
	
	//RESET SETTINGS		
	[toolBarButtons addObject:[self createResetButton]];
	
	[toolBarButtons addObject:flexItem];
	[flexItem release];
	
	return [toolBarButtons autorelease];
}


#define BUTTON_WIDTH 120
#define BUTTON_STYLE UIBarButtonItemStyleBordered

//create reset button - reload default definition 
- (UIBarButtonItem*) createResetButton
{
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
	barButton.style = UIBarButtonItemStyleBordered;
	[barButton setTitle:@"Reset layer setting"];	
	[barButton setWidth:BUTTON_WIDTH];	
	[barButton setTarget:self];
	[barButton setAction:@selector(resetSettings)];
	
	return [barButton autorelease];	
}


//clear tile cache 
- (UIBarButtonItem*) createClearCacheButton
{
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
	barButton.style = UIBarButtonItemStyleBordered;
	[barButton setTitle:@"Clear tile cache"];	
	[barButton setWidth:BUTTON_WIDTH];	
	[barButton setTarget:self];
	[barButton setAction:@selector(clearCache)];
	
	return [barButton autorelease];
}



- (void) clearCache
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erase tile cache" message:@"Do you really want to erase your tile cache?"
												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alertView show];	
	[alertView release];
}


- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{
	//second button (YES) was pressed
	if(buttonIndex == 1)
	{
		//delete cache
		NSString* tileCompositionDirectory = [PATH_RESOURCE stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", 0]];		
		[[NSFileManager defaultManager] removeItemAtPath:tileCompositionDirectory error:nil];		
	}
}


- (void) resetSettings
{
	ParserJSON* parser = [[ParserJSON alloc] init];
	[parser loadAndSetRootNode:DEFAULT_UPDATE_DEFINITION_URL update:NO overWrite:YES];
	[parser release];

	[self setSourceNode:[[[SourceData sharedInstance] sourceNode] getChild:0]];
	
	[self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return [Common isiPadDevice];	
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

