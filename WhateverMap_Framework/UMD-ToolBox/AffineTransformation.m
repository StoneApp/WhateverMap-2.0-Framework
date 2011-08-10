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

#import "AffineTransformation.h"


@implementation AffineTransformation


//there are 3 point and it can not be identical or colinear - if it is then return CGZeroPoint
//we can compute 2 vectors and get s,t parameters of point for conversion
//then just use s,t parameters with other point and work is done
+ (CGPoint)AffineTransformationFrom:(CGPoint[100])fromPoints ToPoints:(CGPoint[100])toPoints OfPoint:(CGPoint)point
{
	
	CGPoint u1 = CGPointMake(fromPoints[1].x - fromPoints[0].x, fromPoints[1].y - fromPoints[0].y);
	CGPoint u2 = CGPointMake(fromPoints[2].x - fromPoints[0].x, fromPoints[2].y - fromPoints[0].y);
	
	CGPoint v1 = CGPointMake(toPoints[1].x - toPoints[0].x, toPoints[1].y - toPoints[0].y);
	CGPoint v2 = CGPointMake(toPoints[2].x - toPoints[0].x, toPoints[2].y - toPoints[0].y);
	
	
	double a[]={ u1.x, u1.y};
	double b[]={ u2.x, u2.y};
	double c[]={ point.x - fromPoints[0].x, point.y - fromPoints[0].y};
	
	
	if (!((b[0] == 0 && a[0] != 0) || (b[1] == 0 && a[1] != 0)))
	{					
		//zero division
		return CGPointZero;
	}
	double r1 = a[0]/b[0];
	double s1 = a[1]/b[1];
	
	
	//zajistit ze body nejsou kolinearni nebo identicke - tj vektory nesmi byt linearni kombinaci	
	if ( 
		(a[0] == 0 && b[0] ==0) || (a[1] == 0 && b[1] ==0) || //toto by uz melo byt v parametrech r a s by se rovnali 0 - neni 
		( r1 == s1 ) ||
		( ( r1 <= ( s1 + 0.00000001 ) ) &&
		 ( r1 >= ( s1 - 0.00000001 ) ) ) ) 
	{
		//zero division
		return CGPointZero;
	}	
	
	
	double D =a[0]*b[1]-a[1]*b[0];
	double D1=c[0]*b[1]-c[1]*b[0];
	double D2=a[0]*c[1]-a[1]*c[0];
	
	if (D == 0)
	{
		}

	double s=D1/D;
	double t=D2/D;
	
	return CGPointMake(toPoints[0].x + s*v1.x + t*v2.x, toPoints[0].y + s*v1.y + t*v2.y);
}

@end
