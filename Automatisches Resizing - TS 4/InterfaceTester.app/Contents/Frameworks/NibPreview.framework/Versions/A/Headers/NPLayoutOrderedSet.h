/*!
 @header
 NPLayoutOrderedSet.h
 Created by max on 10.03.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */

@class NPLayoutEquationVariable;

/*!
 @abstract A special ordered set used in the application of an layout.
 */
@interface NPLayoutOrderedSet : NSObject
{
	NSString		*_name;
	NSUInteger		_type;
	NSMutableArray	*_variables;
	NSMutableArray	*_weights;
}

+ (id)orderedSet;

/*!
 @abstract The name of the special ordered set.
 */
@property(retain) NSString *name;

/*!
 @abstract The maximum number of consecutive non-zero variables in the set.
 */
@property(assign) NSUInteger type;

/*!
 @abstract The ordered variables of the set.
 @discussion Elements are of class NPLayoutEquationVariable.
 */
@property(retain) NSArray *variables;

/*!
 @abstract The weights assigned to the variables.
 @discussion An array of NSNumbers with flot values. May be empty or contain less elements than the variables. The default value, 1.0, is taken then.
 */
@property(retain) NSArray *weights;

/*!
 @abstract Convenience for adding a variable with a given weight.
 */
- (void)addVariable:(NPLayoutEquationVariable *)var withWeight:(CGFloat)weight;

@end
