//
//  SourceNode.m
//  Tiling
//
//  Created by Jirka on 22.3.10.
//  Copyright 2010 Mendel University in Brno. All rights reserved.
//

#import "SourceNode.h"


@implementation SourceNode

@synthesize title, code, maps;


-(id)init
{
    if (self = [super init])
    {
		childrenNodes = [[NSMutableArray alloc] init];
		
		//empty node
		MapSourceDefinition map;
				
		//node with default values
		//MapSourceDefinition map = createEmptyMapSourceDefinition();
		
		maps = [[NSMutableArray alloc] init];
		[maps addObject:[[[NSValue alloc] initWithBytes:&map objCType:@encode( MapSourceDefinition )] autorelease]];
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


-(MapSourceDefinition) getMap: (NSInteger) position
{
	MapSourceDefinition mapSource;
	
	if (position >= 0 && position < [maps count])
	{
		NSValue *mapSourceObject = [maps objectAtIndex:position];
		
		
		if (strcmp([mapSourceObject objCType], @encode( MapSourceDefinition )) == 0)
			[mapSourceObject getValue:&mapSource];				
	}

	//if it is out of index, it return clear MapSource


	return mapSource;
}


-(SourceNode*) getChild: (NSInteger) position
{
	if (position >= 0 && position < [self getNumberOfItems])
	{
		//TODO tento nefunguje pada zatim tedy nil a pak se k tomu vratit
		//code = [[self code] stringByAppendingFormat:[NSString stringWithFormat:@"%d", position]];
		code=@"0";
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


-(void) addMap:(MapSourceDefinition)map
{
	[maps addObject:[[[NSValue alloc] initWithBytes:&map objCType:@encode( MapSourceDefinition )] autorelease]];
}



@end
