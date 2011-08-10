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

#import "UIKit/UIKit.h"
#import "TileDispatcher.h"

@implementation TileDispatcher

#pragma mark -
#pragma mark Singleton

static TileDispatcher *sharedInstance = nil;  

+ (TileDispatcher *)sharedInstance {             
    @synchronized(self) {                            
        if (!sharedInstance) {             
            /* Note that 'self' may not be the same as TileDispatcher */                               
            /* first assignment done in allocWithZone but we must reassign in case init fails */      
            sharedInstance = [[TileDispatcher alloc] init];                                               
            NSAssert((sharedInstance != nil), @"didn't catch singleton allocation");       
        }                                              
    }                                                
    return sharedInstance;                     
}                           





- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        if(![[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."])
        {
            tileDownloadingQeue = [[NSOperationQueue alloc] init]; 
            [tileDownloadingQeue setName:@"com.stoneapp.tiledownload"];
            [tileDownloadingQeue setMaxConcurrentOperationCount:1];
            
            tileDrawingQeue = [[NSOperationQueue alloc] init]; 
            [tileDrawingQeue setName:@"com.stoneapp.tiledraw"];
            [tileDrawingQeue setMaxConcurrentOperationCount:1];
        }
    }
    
    return self;
}


- (void) addOperationBlockToDownloadingQueue:(void (^)(void))block
{
    
    if (tileDownloadingQeue) 
    {
        if(![[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."])             
            [tileDownloadingQeue addOperationWithBlock:block];        
        else
            block();
    }
    else
        block();
}

- (void) addOperationBlockToDrawingQueue:(void (^)(void))block
{
    
    if (tileDrawingQeue) 
    {
        if(![[[UIDevice currentDevice] systemVersion] hasPrefix:@"3."])             
            [tileDrawingQeue addOperationWithBlock:block]; 
        else
            block();
    }
    else
        block();
}

- (void) addOperationBlockOnMainThread:(void (^)(void))block
{
        [[NSOperationQueue mainQueue] addOperationBlockOnMainThread:block];
}


- (void) pauseTasks
{
    [tileDownloadingQeue setSuspended:YES];
    [tileDrawingQeue setSuspended:YES];
}


- (void) unpauseTasks
{
    [tileDownloadingQeue setSuspended:NO];
    [tileDrawingQeue setSuspended:NO];
}


- (void) cancelAllTasks
{
    [tileDownloadingQeue cancelAllOperations];
    [tileDrawingQeue cancelAllOperations];
    
#ifdef LOG_TEXT    
    NSLog(@"cancel all tasks");
#endif    
}


- (void)dealloc
{
    [tileDownloadingQeue release];
    tileDownloadingQeue = nil;
    
    [tileDrawingQeue release];
    tileDrawingQeue = nil;    
    
    [super dealloc];
}

@end
