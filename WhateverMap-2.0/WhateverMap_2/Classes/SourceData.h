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
#import "typeDefinitions.h"

@class MapSourceDefinition;
@class SourceNode;

@interface SourceData : NSObject {
	NSMutableArray *mapSources;
	NSInteger selectedMapSourceIndex;
	NSInteger nodeIndex;
	SourceNode *sourceNode;
}


@property (retain) NSMutableArray *mapSources;
@property (retain) SourceNode *sourceNode;
@property (assign) NSInteger nodeIndex;


+ (SourceData *)sharedInstance;

- (id)init;
- (void)addMapSource:(MapSourceDefinition*)mapSource;
- (void)clearMapSources;
- (void)removeMapSource:(NSInteger)mapSourceIndex;
- (void)moveMapSource:(NSInteger)indexOfSource To:(NSInteger)indexOfDestination;
- (MapSourceDefinition*)getMapSource:(NSInteger)mapSourceIndex;
- (MapSourceDefinition*)getSelectedMapSource;
- (void)dealloc;

- (void)selectMapSource:(NSInteger)index;
- (NSInteger)getSelectedMapSourceIndex;
- (void)nextMapSource;
- (void)previousMapSource;

- (void)setNodeWithIndex:(NSInteger)index;
- (void)previousNode;
- (void)nextNode;
- (NSInteger)getMapCount;

- (BOOL) isSingleMap;





@end
