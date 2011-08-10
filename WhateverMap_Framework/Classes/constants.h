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



//SETTINGS

#define SILENT_MODE //if defined no warnig on connection is appeared
#define SETTINGS_STATISCTICS_ENABLED @"statistics_enabled_preference"
#define UPDATE_DEFINITION_ENABLED @"update_enabled_preference"
#define SETTINGS_VALUE_STATISCTICS_ENABLED [[NSUserDefaults standardUserDefaults] boolForKey:SETTINGS_STATISCTICS_ENABLED]
#define UPDATE_VALUE_DEFINITION_ENABLED [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_DEFINITION_ENABLED]

#define DEFAULT_UPDATE_DEFINITION_URL @"http://www.ikatastr.cz/def/iKatastr-v1.js"



#define IPAD //define for iPad device not for iPhone device

#ifdef IPAD //iPad
	#define FURRY_ID @"YOUR_FURRY_ID_1"
	#define HOME_AREA_ZOOM 7.6 //iPad
	#define OPTIMALIZED_TILE_LOADING //with multithreading loading of tiles it has no big sense
#else //iPhone
	#define FURRY_ID @"YOUR_FURRY_ID_2"
	#define HOME_AREA_ZOOM 6.5 //iPhone
#endif

#define POSITION_VIEW
#define COMPASS_TURN_ON_WITH_GPS		
#define HIDE_SCROLLERS //hide scrollers on bottom and right
//#define NO_SINGLE_SOURCE_FAVOURITE_LIST	 //if there is single map composition do not show favourite list - just show map or detailedView

//#define DISABLE_FIRST_LAYER_MANIPULATION
//#define EXCLUSIVE_LAYER_ONE_OR_TWO
//#define TURN_OFF_FUNCTION_ON_LEAVE_MAP	


//HOME AREA
#define HOME_AREA_LATLON LatLonMake(50, 15.4)

//zoom step for double(tripple) double click
#define ZOOM_STEP 5.0 

///*****************************************
//keeping old tiles in image (with different zoom)
#define KEEP_OLD_LEVELS 
#define MAX_ZOOM_DIFFERENCE 6.0


///*****************************************
//store loaded tiles from the Internet
#define STORE_TILES


///*****************************************
//resolve a bug - if two operation of zooming are simultanously running view in map is lost unexpectly
#define GEST_DELAY 0.0 //0.5 - seems OK //0.9 definetely safe //fix the problem in navigation on map - more operation with zooming in one time   //dirty zoom => maybe now it is not needed


//make possible differentiate single, double or tripple tap
#define STANDARD_DELAY 0.35
#define SINGLE_TAP_DELAY 2*STANDARD_DELAY
#define DOUBLE_TAP_DELAY STANDARD_DELAY
#define TRIPPLE_TAP_DELAY STANDARD_DELAY
#define TWO_FINGERS_SINGLE_TAP_DELAY STANDARD_DELAY

///*****************************************
//optimalize loading if defined
//#define OPTIMALIZED_TILE_LOADING //with multithreading loading of tiles it has no big sense


///*****************************************
//fade in loaded tiles
#define FADE_IN_TILE	
#define	FADE_IN_TILE_DURATION 0.5 //0.2 //0.5


///*****************************************
//ditectory for tiles
#define PATH_DOCUMENT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_RESOURCE_DIRECTORY [[NSBundle mainBundle] resourcePath]
#define PATH_OPENLAYERS_DIRECTORY [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"OpenLayers"] 
#define PATH_OPENLAYERS_SCRIPT_PATH [PATH_OPENLAYERS_DIRECTORY stringByAppendingPathComponent:@"OpenLayers.js"]
#define PATH_SETTING_FILE [PATH_DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"Settings.set"] 


#if TARGET_IPHONE_SIMULATOR
	#define PATH_RESOURCE PATH_RESOURCE_DIRECTORY
#else
	#define PATH_RESOURCE PATH_DOCUMENT_DIRECTORY
#endif	


///*****************************************
//Colors for map background
//#define MAP_BACKGROUND_COLOR [UIColor whiteColor]
#define MAP_BACKGROUND_COLOR [UIColor lightGrayColor]
//#define MAP_BACKGROUND_COLOR [UIColor darkGrayColor]
//#define MAP_BACKGROUND_COLOR [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]
//#define MAP_BACKGROUND_COLOR [UIColor colorWithRed:0.85 green:0.88 blue:0.85 alpha:1]
//#define MAP_BACKGROUND_COLOR [UIColor colorWithRed:1-168/256 green:1-177/256 blue:1-184/256 alpha:1]
//#define MAP_BACKGROUND_COLOR [UIColor redColor]



///*****************************************
//anotate tiles - show grid and number of tile
//	#define ANNOTATE_TILES




///*****************************************
//Default is 1,1 or it can be used 2 and 1 levele is not used jus 1 - 3 - 5 ... 
//when load next level for zoom-in
#define LEVEL_LOWER_DIFFERENCE 1
//when load next level for zoom-out
//#define LEVEL_UPPER 1
#define LEVEL_UPPER_DIFFERENCE 1

#define LEVEL_MIN_ZOOM_SCALE 1
#define LEVEL_MAX_ZOOM_SCALE 2

//#define LEVEL_RESOLUTION 1  //for retina 
//#define LEVEL_RESOLUTION 2  //for normal display
#define LEVEL_RESOLUTION 1.5  //for normal display

#define MAX_LEVEL_DELTA 40


///*****************************************
//MAX and MIN scale for UIScrollView

//good for single tile - but if we want to zoom smoothly cross the all level it is better to set extreme level and set reliable values to the first or last level
//this make possible to zoom smooth cross all levels
#define MIN_SCALE_FOR_LEVEL 0.0000000001
#define MAX_SCALE_FOR_LEVEL 1000000000.0  //2ˆ18 = 262,144      2ˆ26 = 67 108 864  rounded to 1 000 000 000

//this set reliable values to the first and last level - it does not make sense to zoom las level 100x - but it is possible to set
#define MIN_SCALE_FOR_FIRST_LEVEL 0.6
#define MAX_SCALE_FOR_LAST_LEVEL 0.98



///*****************************************
//if inset is setted - it is possible to scroll map outside of navigation or tool bar  - inset has attributes //upper, left, bottom, right									 
#define INSET_EDGE UIEdgeInsetsMake(78, 0, 44, 0) //44-navbar+34-searchbar



///*****************************************
//e.g. when to round number to integer in evaluation 
#define PRECISION 0.0000000001
#define TILE_PRECISION 0.000001



///*****************************************
//definition of some location on the world

//TOKIO - PARK -   35.683753,139.753851
//http://maps.google.com/?ie=UTF8&ll=35.683753,139.753851&spn=0.001667,0.004128&z=19
#define TOKIO LatLonMake(35.683753,139.753851) //TOKIO

//PRAHA - KARLUV MOST -   50.086203, 14.41349
//http://maps.google.com/?ie=UTF8&ll=50.086203,14.413497&spn=0.001317,0.004128&z=19
#define PRAGUE LatLonMake(50.086203, 14.41349) //PRAHA

//RIO GRANDE -ARGENTINA   -53.773395,-67.7033
//http://maps.google.com/?ie=UTF8&ll=-53.773395,-67.703387&spn=0.001213,0.004128&z=19
#define RIO_GRANDE LatLonMake(-53.773395,-67.7033) //RIO GRANDE

//CORNER   90, -180
#define CORNER LatLonMake(90,-180) //CORNER/


///*****************************************
//BASE PROJECTION FOR INTETRNAL GPS CONVERT
#define BASE_PROJECTION @"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
#define LATLON_CONVERT_RAD_BTW_DEG


