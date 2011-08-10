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

#import "SourceNode.h"
#import "MapSourceDefinition.h"


@implementation SourceNode

@synthesize title, code, maps;


-(id)init
{
    self = [super init];
    if (self)
    {
		childrenNodes = [[NSMutableArray alloc] init];
		maps = [[NSMutableArray alloc] init];
    }
    return self;
}


-(BOOL) isMap
{
	if (childrenNodes == nil || [childrenNodes count] <= 0)
		return true;
	else
		return false;
}



-(NSInteger) getNumberOfItems
{
	if ([self isMap])
		return [maps count];
	else
		return [childrenNodes count];
}


-(MapSourceDefinition*) getMap: (NSInteger) position
{
	MapSourceDefinition* mapSource = nil;
	
	if (position >= 0 && position < [maps count])
	{
		mapSource = [maps objectAtIndex:position];
	}

	return mapSource;
}


-(SourceNode*) getChild: (NSInteger) position
{
	if (position >= 0 && position < [self getNumberOfItems])
	{
		code = @"0";
		[[childrenNodes objectAtIndex:position] setCode:code];
		return [childrenNodes objectAtIndex:position];

	}
	else 
	{
		return nil;
	}

}


-(void) addNode:(SourceNode*)node
{

	[childrenNodes addObject:node];
}


-(void) addMap:(MapSourceDefinition*)map
{
	[maps addObject:map];
}


-(void) replaceMap:(MapSourceDefinition*)map atIndex:(NSInteger)index
{
	[maps replaceObjectAtIndex:index withObject:map];
}





@end
