/*!
 @header
 BLGenericProcessStep.h
 Created by Max on 09.05.09.
 
 @copyright 2004-2009 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLProcessStep.h>

/*!
 @abstract A very simple generic step performaing a NSInvocation on an object on main thread, blocking until it is done.
 @discussion This step just display a action "Processing" and no detail description. However, you have the ability to customize this display to your needs.
 */
@interface BLGenericProcessStep : BLProcessStep
{
	NSString		*_action;
	NSString		*_description;
	NSInvocation	*_invocation;
}

/*!
 @abstract Creates a new generic process step.
 */
+ (id)genericStepWithInvocation:(NSInvocation *)invocation;

/*!
 @abstract Set the displayed action.
 @discussion This method is thread-safe in regards to interface synchronization!
 */
- (void)setAction:(NSString *)action;

/*!
 @abstract Set the displayed description.
 @discussion This method is thread-safe in regards to interface synchronization!
 */
- (void)setDescription:(NSString *)description;

@end
