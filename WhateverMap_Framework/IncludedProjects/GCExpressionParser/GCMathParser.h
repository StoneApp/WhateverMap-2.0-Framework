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
//  GCMathParser.h
//  GCDrawKit
//
//  Created by graham on 28/08/2007.
//  Copyright 2007 Apptree.net. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "ZExpParser.h"



@interface GCMathParser : NSObject
{
	symbol*			_st;			// symbol table; singly linked list
	NSString*		_expr;			// retained expression
	double			_result;		// the result of the evaluation
}

+ (GCMathParser *)sharedInstance;

+ (double)			evaluate:(NSString*) expression;
+ (GCMathParser*)	parser;

- (double)			evaluate:(NSString*) expression;
- (NSString*)		expression;
- (const char*)		expressionCString;

- (void)			setSymbolValue:(double) value forKey:(NSString*) key;
- (double)			symbolValueForKey:(NSString*) key;

// private methods called internally:

- (symbol*)			getSymbol:(NSString*) key;
- (symbol*)			getSymbolForCString:(const char*) name;
- (symbol*)			initSymbol:(const char*) name ofType:(int) type;
- (void)			setResult:(double) result;


@end

// to simplify this even further for casual use (i.e. when you don't need variables), you can
// make use of this category on NSString:


@interface NSString (ExpressionParser)

- (double)			evaluateMath;

@end
