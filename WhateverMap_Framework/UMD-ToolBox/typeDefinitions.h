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


struct BBox {
	double minX;
	double minY;
	double maxX;
	double maxY;
};
typedef struct BBox BBox;

static __inline__ BBox
BBoxMake(double minX, double minY, double maxX, double maxY)
{
	BBox p; 
	p.minX = minX; 
	p.maxX = maxX; 
	p.minY = minY; 
	p.maxY = maxY; 
	return p;
}


struct LatLon {
	double lon;
	double lat;
};
typedef struct LatLon LatLon;


static __inline__ LatLon
LatLonMake(double lat, double lon)
{
	LatLon p; p.lat = lat; p.lon = lon; return p;
}


typedef struct{
	NSInteger zoom, x, y;
} Tile;

@interface TileObject : NSObject
{
	NSInteger zoom;
	NSInteger column;
	NSInteger row;
	NSInteger positionIndex;
}

@property (assign) NSInteger zoom;
@property (assign) NSInteger column;
@property (assign) NSInteger row;
@property (assign) NSInteger positionIndex;

@end






    