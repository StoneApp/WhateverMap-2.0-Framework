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

#import "ExpressionWrapper.h"

#import "GCMathParser.h"


@implementation ExpressionWrapper




//Evaluate equation in string and return number in double format
+ (double)evaluateEquation:(NSString*)equation
{
	GCMathParser* _parser = [GCMathParser sharedInstance];				
	double value = -1;
	
	@try 
	{
		
		///////////////////////////////////////		
		if([equation length] > 0 )
		{
			if ( _parser == nil )
				value = [equation evaluateMath];
			else
				value = [_parser evaluate:equation];
		}
		///////////////////////////////////////		
	}
	@catch (NSException * e) {
		NSLog(@"Error while parser evaluating");
		value = -1; //Error
	}
	@finally {
		//OK
	}
	
	return value;
}



//Evaluate equation in string and return number in double format
- (double)evaluateEquation:(NSString*)equation
{
	[self performSelectorOnMainThread:@selector(evaluate:) withObject:equation waitUntilDone:YES];	
	return value;
}


- (void) evaluate:(NSString*)equation
{
	GCMathParser* _parser = [GCMathParser sharedInstance];				
	value = -1;
	
	@try 
	{
		
		///////////////////////////////////////		
		if([equation length] > 0 )
		{
			if ( _parser == nil )
				value = [equation evaluateMath];
			else
				value = [_parser evaluate:equation];
		}
		///////////////////////////////////////	
	}
	@catch (NSException * e) {
		NSLog(@"Error while parser evaluating");
		value = -1; //Error
	}
	@finally {
		//OK
	}	
}



@end
