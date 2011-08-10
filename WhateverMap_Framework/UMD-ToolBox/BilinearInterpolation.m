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


//for construction is used article in this URL:
//http://stackoverflow.com/questions/808441/inverse-bilinear-interpolation

#import "BilinearInterpolation.h"

#include <math.h>

@implementation BilinearInterpolation


/*
- (void) test
{
	int num_failed = fuzzTestInvBilerp( 100000000 );
	NSLog(@"%d", num_failed);
}
*/

+ (CGPoint)BilinearInterpolationOfPoints:(CGPoint[100])points WithParameter:(CGPoint)parameters
{
	//parameters.x and y is s and t
	double x, y;
	bilerp(points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y, points[3].x, points[3].y, parameters.x, parameters.y, &x, &y);
	
	return CGPointMake(x, y);
}


+ (CGPoint)InverseBilinearInterpolationOfPoints:(CGPoint[100])points WithPoint:(CGPoint)point
{
	double s, t, s2, t2;
	NSInteger num_st = inverseBilerp(points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y, points[3].x, points[3].y, point.x, point.y, &s, &t, &s2, &t2);
	
	if (num_st > 0)
		return CGPointMake(s, t);
	else
		return CGPointZero;
}



int equals( double a, double b, double tolerance )
{
    return ( a == b ) ||
	( ( a <= ( b + tolerance ) ) &&
	 ( a >= ( b - tolerance ) ) );
}

double cross2( double x0, double y0, double x1, double y1 )
{
    return x0*y1 - y0*x1;
}

int in_range( double val, double range_min, double range_max, double tol )
{
    //return ((val+tol) >= range_min) && ((val-tol) <= range_max);
	return TRUE;
}

/* Returns number of solutions found.  If there is one valid solution, it will be put in s and t */
int inverseBilerp( double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, double x, double y, double* sout, double* tout, double* s2out, double* t2out )
{
    NSInteger t_valid, t2_valid;
	
    double a  = cross2( x0-x, y0-y, x0-x2, y0-y2 );
    double b1 = cross2( x0-x, y0-y, x1-x3, y1-y3 );
    double b2 = cross2( x1-x, y1-y, x0-x2, y0-y2 );
    double c  = cross2( x1-x, y1-y, x1-x3, y1-y3 );
    double b  = 0.5 * (b1 + b2);
	
    double s, s2, t, t2;
	
    double am2bpc = a-2*b+c;
    /* this is how many valid s values we have */
    int num_valid_s = 0;
	
    if ( equals( am2bpc, 0, 1e-10 ) )
    {
        if ( equals( a-c, 0, 1e-10 ) )
        {
			/* Looks like the input is a line */
			/* You could set s=0.5 and solve for t if you wanted to */
			return 0;
        }
        s = a / (a-c);
        if ( in_range( s, 0, 1, 1e-10 ) )
			num_valid_s = 1;
    }
    else
    {
        double sqrtbsqmac = sqrt( b*b - a*c );
        s  = ((a-b) - sqrtbsqmac) / am2bpc;
        s2 = ((a-b) + sqrtbsqmac) / am2bpc;
        num_valid_s = 0;
        if ( in_range( s, 0, 1, 1e-10 ) )
        {
			num_valid_s++;
			if ( in_range( s2, 0, 1, 1e-10 ) )
				num_valid_s++;
        }
        else
        {
			if ( in_range( s2, 0, 1, 1e-10 ) )
			{
				num_valid_s++;
				s = s2;
			}
        }
    }
	
    if ( num_valid_s == 0 )
        return 0;
	
    t_valid = 0;
    if ( num_valid_s >= 1 )
    {
        double tdenom_x = (1-s)*(x0-x2) + s*(x1-x3);
        double tdenom_y = (1-s)*(y0-y2) + s*(y1-y3);
        t_valid = 1;
        if ( equals( tdenom_x, 0, 1e-10 ) && equals( tdenom_y, 0, 1e-10 ) )
        {
			t_valid = 0;
        }
        else
        {
			/* Choose the more robust denominator */
			if ( fabs( tdenom_x ) > fabs( tdenom_y ) )
			{
				t = ( (1-s)*(x0-x) + s*(x1-x) ) / ( tdenom_x );
			}
			else
			{
				t = ( (1-s)*(y0-y) + s*(y1-y) ) / ( tdenom_y );
			}
			if ( !in_range( t, 0, 1, 1e-10 ) )
				t_valid = 0;
        }
    }
	
    /* Same thing for s2 and t2 */
    t2_valid = 0;
    if ( num_valid_s == 2 )
    {
        double tdenom_x = (1-s2)*(x0-x2) + s2*(x1-x3);
        double tdenom_y = (1-s2)*(y0-y2) + s2*(y1-y3);
        t2_valid = 1;
        if ( equals( tdenom_x, 0, 1e-10 ) && equals( tdenom_y, 0, 1e-10 ) )
        {
			t2_valid = 0;
        }
        else
        {
			/* Choose the more robust denominator */
			if ( fabs( tdenom_x ) > fabs( tdenom_y ) )
			{
				t2 = ( (1-s2)*(x0-x) + s2*(x1-x) ) / ( tdenom_x );
			}
			else
			{
				t2 = ( (1-s2)*(y0-y) + s2*(y1-y) ) / ( tdenom_y );
			}
			if ( !in_range( t2, 0, 1, 1e-10 ) )
				t2_valid = 0;
        }
    }
	
    /* Final cleanup */
    if ( t2_valid && !t_valid )
    {
        s = s2;
        t = t2;
        t_valid = t2_valid;
        t2_valid = 0;
    }
	
    /* Output */
    if ( t_valid )
    {
        *sout = s;
        *tout = t;
    }
	
    if ( t2_valid )
    {
        *s2out = s2;
        *t2out = t2;
    }
	
    return t_valid + t2_valid;
}


int bilerp( double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, double s, double t, double* x, double* y )
{
    *x = t*(s*x3+(1-s)*x2) + (1-t)*(s*x1+(1-s)*x0);
    *y = t*(s*y3+(1-s)*y2) + (1-t)*(s*y1+(1-s)*y0);
	
	return 0;
}

double randrange( double range_min, double range_max )
{
    double range_width = range_max - range_min;
    double rand01 = (rand() / (double)RAND_MAX);
    return (rand01 * range_width) + range_min;
}


/* Returns number of failed trials */
int fuzzTestInvBilerp( int num_trials )
{
    int num_failed = 0;
	
    double x0, y0, x1, y1, x2, y2, x3, y3, x, y, s, t, s2, t2, orig_s, orig_t;
    int num_st;
    int itrial;
    for ( itrial = 0; itrial < num_trials; itrial++ )
    {
        int failed = 0;
        /* Get random positions for the corners of the quad */
        x0 = randrange( -10, 10 );
        y0 = randrange( -10, 10 );
        x1 = randrange( -10, 10 );
        y1 = randrange( -10, 10 );
        x2 = randrange( -10, 10 );
        y2 = randrange( -10, 10 );
        x3 = randrange( -10, 10 );
        y3 = randrange( -10, 10 );
        /*x0 = 0, y0 = 0, x1 = 1, y1 = 0, x2 = 0, y2 = 1, x3 = 1, y3 = 1;*/
        /* Get random s and t */
        s = randrange( 0, 1 );
        t = randrange( 0, 1 );
        orig_s = s;
        orig_t = t;
        /* bilerp to get x and y */
        bilerp( x0, y0, x1, y1, x2, y2, x3, y3, s, t, &x, &y );
        /* invert */
        num_st = inverseBilerp( x0, y0, x1, y1, x2, y2, x3, y3, x, y, &s, &t, &s2, &t2 );
		//num_st -  is number of result there is possibility of 2 results - both of them are right (swappes 2 points - image of butterfly)
        if ( num_st == 0 )
        {
			failed = 1;
        }
        else if ( num_st == 1 )
        {
			if ( !(equals( orig_s, s, 1e-5 ) && equals( orig_t, t, 1e-5 )) )
				failed = 1;
        }
        else if ( num_st == 2 ) 
        {			
			if ( !((equals( orig_s, s , 1e-5 ) && equals( orig_t, t , 1e-5 )) ||
				   (equals( orig_s, s2, 1e-5 ) && equals( orig_t, t2, 1e-5 )) ) )
				failed = 1;						
        }
		
        if ( failed )
        {
			num_failed++;
			printf("Failed trial %d\n", itrial);
        }
		
		
    }
	
    return num_failed;
}

@end
