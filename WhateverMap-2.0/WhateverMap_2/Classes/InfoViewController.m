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

#import "InfoViewController.h"
#import "MapController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapController.h"
#import "constants.h"
#import "Common.h"
 
@implementation InfoViewController



- (void)viewWillAppear:(BOOL)animated
{
}


- (void)viewDidAppear:(BOOL)animated
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(hideInfo:)]; 
	[self.navigationItem setLeftBarButtonItem:backButton];
	[backButton release];
}


//show info view
- (void) hideInfo:(id)sender
{	
	//add animation of flip window
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:.03];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.view window] cache:YES];
	
	
	if ([Common isiPadDevice])	
		[self.navigationController popViewControllerAnimated:NO];	
	else
		[self.view removeFromSuperview];
	

	[UIView commitAnimations];
}


- (IBAction) sendMail:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:xkaminek@mendelu.cz"]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return [Common isiPadDevice];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

	
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}



@end
