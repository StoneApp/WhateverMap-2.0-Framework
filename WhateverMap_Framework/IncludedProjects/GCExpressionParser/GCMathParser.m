/*
 http://www.apptree.net/parser.htm
Supported functions and operators

* Basic operators: +, -, * (multiply) and / (divide)
* Mod operator: %
* Exponentiation operator: ^
* Negation: unary -
* Assignment: =
* Log functions: log(), log2(), ln(), exp()
* Transcendental functions: sin(), cos(), tan(), asin(), acos(), atan(), sinh(), cosh(), tanh(), asinh(), acosh(), atanh()
* Square root function: sqrt()
* Rounding functions: ceil(), floor(), round(), trunc(), rint(), near()
* Angular conversion functions: dtor(), rtod()
* Absolute value function: abs()
* Constants: pi
*/
//
//  GCMathParser.m
//
//  Created by graham on 28/08/2007.
//

#import "GCMathParser.h"


@implementation GCMathParser

static struct init s_MathFunctions[]=
{
     "sin", 	sin,
     "cos", 	cos,
     "tan", 	tan,
     "log", 	log10,
     "log2",	log2,
     "ln",		log,
     "exp", 	exp,
     "abs",		fabs,
     "sqrt", 	sqrt,
     "asin", 	asin,
     "acos", 	acos,
     "atan", 	atan,
     "sinh", 	sinh,
     "cosh", 	cosh,
     "tanh", 	tanh,
     "asinh",	asinh,
     "acosh",	acosh,
     "atanh",	atanh,
     "ceil",	ceil,
     "floor",	floor,
     "round", 	round,
     "trunc", 	trunc,
     "rint", 	rint,
     "near",	nearbyint,
     "dtor",	degtorad,
     "rtod",	radtodeg,
     0, 		0
};



+ (GCMathParser *)sharedInstance
{
	static GCMathParser *instance;
	@synchronized(self)
	{
		if(!instance)
		{
			instance = [[GCMathParser alloc] init];
		}
	}
	
	return instance;
}



+ (double)			evaluate:(NSString*) expression
{
	return [[self parser] evaluate:expression];
}


+ (GCMathParser*)	parser
{
	return [[[GCMathParser alloc] init] autorelease];
}


- (id)				init
{
	if ((self = [super init]) != nil )
	{
		int 	i;
		symbol 	*ptr;
		
		_st = NULL;
		_expr = NULL;
		
		// install mathematical functions in symbol table
	  
		for ( i = 0; s_MathFunctions[i].fname != 0; i++ )
		{
			ptr = [self initSymbol:s_MathFunctions[i].fname ofType:FUNCTION];			
			ptr->value.func = s_MathFunctions[i].fnct;
		}
		
		// also include a named constant for pi
		
		[self setSymbolValue:M_PI forKey:@"pi"];		
		//[self setSymbolValue:3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679 forKey:@"pi"];
	}
	
	return self;
}


- (void)			dealloc
{
	// free symbol table
	
	symbol	*ns, *s;
	
	s = _st;
	
	while( s )
	{
		ns = s->next;
		free( s->name );
		free( s );
		s = ns;
	}
	
	[_expr release];
	[super dealloc];
}


- (double)			evaluate:(NSString*) expression
{
	[expression retain];
	[_expr release];
	_expr = expression;
	_result = 0.0;
	
	yyparse( self );

	// return the result...

	return _result;
}


- (NSString*)		expression
{
	return _expr;
}


- (const char*)		expressionCString
{
	//return [[self expression] cString]; //deprecated
	return [[self expression] UTF8String];
}


- (void)			setSymbolValue:(double) value forKey:(NSString*) key
{
	symbol* p;
	
	p = [self getSymbol:key];
	
	if ( p == NULL )
		//p = [self initSymbol:[key cString] ofType:VAR]; //deprecated
		p = [self initSymbol:[key UTF8String] ofType:VAR];

	if ( p )
		p->value.var = value;
}


- (double)			symbolValueForKey:(NSString*) key
{
	symbol*		s = [self getSymbol:key];
	
	if ( s )
		return s->value.var;
	else
		return 0.0;
}


// private methods called internally:

- (symbol*)			getSymbol:(NSString*) key
{
	//return [self getSymbolForCString:[key cString]]; //deprecated
	return [self getSymbolForCString:[key UTF8String]]; 
}


- (symbol*)			getSymbolForCString:(const char*) name
{
	symbol *ptr;
  	
  	for ( ptr = _st; ptr != NULL; ptr = ptr->next )
  	{
    	if ( strcmp( ptr->name, name ) == 0 )
      		return ptr;
    }
  	
	return NULL;
}


- (symbol*)			initSymbol:(const char*) name ofType:(int) type
{
	symbol*	ptr = (symbol*) malloc ( sizeof( symbol ));
  	
  	ptr->name = (char*) malloc( strlen( name ) + 1 );
  	strcpy( ptr->name, name );
  	ptr->type = type;
  	ptr->value.var = 0; // preset value to 0 even if type is a function
  	
  	ptr->next = _st;
  	_st = ptr;
 	
 	return ptr;
}


- (void)			setResult:(double) result
{
	_result = result;
}



@end


#pragma mark -

@implementation NSString (ExpressionParser)

- (double)			evaluateMath
{
	return [GCMathParser evaluate:self];
}


@end
