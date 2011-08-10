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
#import "SearchBarDelegate.h"
#import "JSON.h"
#import "MapController.h"
#import "Common.h"
#import "TiledScrollView.h"

#import "GeoNames.h"

@implementation SearchBarDelegate

@synthesize mapDelegate;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
#ifdef DEBUG
	NSLog(@"Searching for: %@", searchBar.text);
#endif

	[searchBar resignFirstResponder]; //hide keyboard
	[searchBar setShowsCancelButton:NO animated:YES]; //hide Cancel Button
	


	[NSThread detachNewThreadSelector:@selector(searchForText:) toTarget:self withObject:searchBar];
    
    [mapDelegate makeShakeViewFirstResponder];
}


- (void) searchForText:(UISearchBar *)searchBar
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	

	GeoNames *geonamesResolver = [[GeoNames alloc] init];
	BOOL result = [geonamesResolver getLocation:&latlon ForGeoname:searchBar.text];
	
	//if the location is succesfully requested, show it
	if (result)
	{
		[self performSelectorOnMainThread:@selector(processResult) withObject:nil waitUntilDone:NO];
	}
	else 
	{
		[Common showMessage:@"No results" withTitle:@"Alert!"];
		NSLog(@"No results for geonames search found!");
	}
	
	[geonamesResolver release];
	
	[pool drain];
}

- (void) processResult
{
	//always zoom to level where cadastral map is visible
	//[mapDelegate zoomToLevel:16.8 animated:YES];
	//[mapDelegate goToLonLat:latlon animated:YES];
    [mapDelegate goToLanLot:latlon atZoom:16.8];
    NSLog(@"add this gps store history");
	[mapDelegate storeActualHistoryMovement];
	[mapDelegate turnGPSButtonOff];			
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar 
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder]; //hide keyboard
	[searchBar setShowsCancelButton:NO animated:YES]; //hide Cancel Button	
	[mapDelegate makeShakeViewFirstResponder];	
}


@end
