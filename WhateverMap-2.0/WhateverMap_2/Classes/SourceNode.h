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

#import <Foundation/Foundation.h>


@class MapSourceDefinition;

@interface SourceNode : NSObject {

	NSString *title;
	NSMutableArray *childrenNodes;
	NSMutableArray *maps;
	NSString *code; //code for temporary folder for storing tiles
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSMutableArray *maps;


-(BOOL) isMap;
-(NSInteger) getNumberOfItems;
-(MapSourceDefinition*) getMap: (NSInteger) position;
-(SourceNode*) getChild: (NSInteger) position;
-(void) addNode:(SourceNode*)node;
-(void) addMap:(MapSourceDefinition*)map;
-(void) replaceMap:(MapSourceDefinition*)map atIndex:(NSInteger)index;

@end
