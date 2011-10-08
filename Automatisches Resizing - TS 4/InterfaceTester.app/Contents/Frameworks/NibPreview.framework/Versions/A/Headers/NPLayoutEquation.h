/*!
 @header
 NPLayoutEquation.h
 Created by max on 12.01.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */

@class NPLayoutEquationVariable;

/*!
 @abstract Possible relation types for a NPLayoutEquation.
 
 @const NPLayoutEquationSmallerOrEqual	The equation is of the form X <= const.
 @const NPLayoutEquationEqual			The equation is of the form X = const.
 @const NPLayoutEquationGreaterOrEqual	The equation is of the form X >= const.
 */
typedef enum {
	NPLayoutEquationSmallerOrEqual,
	NPLayoutEquationEqual,
	NPLayoutEquationGreaterOrEqual
} NPLayoutEquationType;

/*!
 @abstract An equation (or inequation) used in the formal application of a layout.
 @discussion The equations represented here are only linear equalities or inequalities. The position of each of the affected tab stops is treated as a variable, whereas each of these variables is associated with a constant factor. The sum of all tab stop positions times their factor is then put into relation to the constant part using the equation type. Here is what this looks like:
 
 f1*T1 + f2*T2 + ... + fn*Tn <= const
 
 Helper variables may be added by setting more factors than tab stops. 
 
 f1*T1 + f2*T2 + ... + fn*Tn + f(n+1)X1 + ... + fmXk <= const
 
 The f's stand for the factors, the T's stand for the tab stop positions and the X's stand for the helper variables. The smaller or equal sign (<=) might be replaced by a equal (=) or greater equal (>=) sign, according to the equation's type. See NPLayoutEquationType for details. The right part of the equation is the constant part property. 
 */
@interface NPLayoutEquation : NSObject
{
	CGFloat					_constPart;
	NSMutableArray			*_factors;
	NSMutableArray			*_helpers;
	NSMutableArray			*_tabStops;
	NPLayoutEquationType	_type;
}

/*!
 @abstract Convenience allocator.
 */
+ (id)equation;

/*!
 @abstract The ordered tab stops that are part of the equation.
 @discussion Elements are of class NPLayoutTabStop.
 */
@property(retain) NSArray *tabStops;

/*!
 @abstract The ordered (helper) variables that are part of the equation.
 @discussion Elements are of class NPLayoutEquationVariable.
 */
@property(retain) NSArray *variables;

/*!
 @abstract The ordered factors for the tab stops.
 @discussion Must be at least the same count as the tab stops. Elements are of class NSNumber, holding a float value. If the number of factors is greater than the number of tab stops, the bound variables are anonymous 
 */
@property(retain) NSArray *factors;

/*!
 @abstract Convenience for adding a tab stop with a given factor.
 */
- (void)addTabStop:(NPLayoutTabStop *)tabStop withFactor:(CGFloat)factor;

/*!
 @abstract Convenience for adding a helper variable with a given factor.
 */
- (void)addVariable:(NPLayoutEquationVariable *)var withFactor:(CGFloat)factor;

/*!
 @abstract Convenience for merging two equations into one.
 @discussion Merges the tab stops and variables only. The type and constant part remain unaffected.
 */
- (void)addEquation:(NPLayoutEquation *)equation;

/*!
 @abstract The type of the equation.
 */
@property(assign) NPLayoutEquationType type;

/*!
 @abstract The constant part.
 */
@property(assign) CGFloat constantPart;

@end


/*!
 @abstract A (helper) variable in a (set of) equations.
 */
@interface NPLayoutEquationVariable : NSObject
{
}

/*!
 @abstract Creates a new variable object.
 */
+ (id)variable;

@end

