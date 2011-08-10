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
#import <Foundation/Foundation.h>


@interface BilinearInterpolation : NSObject {

}

//- (void) test;
+ (CGPoint)BilinearInterpolationOfPoints:(CGPoint[100])points WithParameter:(CGPoint)parameters;
+ (CGPoint)InverseBilinearInterpolationOfPoints:(CGPoint[100])points WithPoint:(CGPoint)point;

int fuzzTestInvBilerp( int num_trials );
int inverseBilerp( double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, double x, double y, double* sout, double* tout, double* s2out, double* t2out );
int bilerp( double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, double s, double t, double* x, double* y );


@end
