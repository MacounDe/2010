/*!
 @header
 NPLayoutConstraint.h
 Created by max on 30.12.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

/*!
 @abstract Object representing a constraint in a layout.
 */
@interface NPLayoutConstraint : NSObject
{
}

/*!
 @abstract Returns whether the constraint is violated.
 @discussion Typically, violated constraints are followed by a application cycle, trying to create a non-violated state. 
 */
@property(readonly, getter=isViolated) BOOL violated;

/*!
 @abstract Creates a set of equations formally representing the constraint.
 @discussion Elements should be of class NPLayoutEquation or NPLayoutOrderedSet.
 */
@property(readonly) NSSet *equations;

@end
