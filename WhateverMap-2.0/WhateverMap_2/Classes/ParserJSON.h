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
@class SourceNode;

@interface ParserJSON : NSObject {


}

+ (ParserJSON *)sharedInstance;

- (void) loadAndSetRootNode:(NSString*)textURL update:(BOOL)updateBoolean overWrite:(BOOL)overWriteBoolean;
- (SourceNode*) loadRootNode:(NSURL*)url update:(BOOL)updateBoolean overWrite:(BOOL)overWriteBoolean;
- (BOOL) saveRootNode:(SourceNode*) node;

//LOAD
- (MapSourceDefinition*) parseString:(NSString*)string;
- (MapSourceDefinition*) createMapSourceDefinition:(NSDictionary*)obj;
- (SourceNode*) parseList:(NSString*)string;
- (BOOL) isMapComposition:(id)objectJSON;
- (SourceNode*) createMapNode:(NSDictionary*)objectJSON;
- (SourceNode*) createMapCompositionNode:(NSDictionary*)objectJSON;

//SAVE
- (id) createList:(SourceNode*)node;
- (id) createList:(SourceNode*)node;
- (NSDictionary*) createDictionaryFromMapNode:(SourceNode*)mapNode;
- (NSDictionary*) createDictionaryFromMapDefinition:(MapSourceDefinition*)map;

@end
