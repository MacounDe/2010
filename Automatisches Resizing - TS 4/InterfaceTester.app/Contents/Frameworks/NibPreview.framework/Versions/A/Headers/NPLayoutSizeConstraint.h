/*!
 @header
 NPLayoutSizeConstraint.h
 Created by max on 30.12.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayoutConstraint.h>
#import <NibPreview/NPLayoutDefines.h>

/*!
 @abstract Represents the size-equivalence of multiple cells.
 @discussion Currently, only width-equivalence is recognized by the generation algorithm.
 */
@interface NPLayoutSizeConstraint : NPLayoutConstraint <BLPropertyListSerialization>
{
	NSSet				*_cells;
	NPLayoutDirection	_direction;
	
	// Lazy deserialization
	NSArray				*_cellNames;
}

/*!
 @abstract Creates a new, autoreleased constraint for a set of cells.
 */
+ (id)constraintWithCells:(NSSet *)cells andDirection:(NPLayoutDirection)direction;

/*!
 @abstract The cells having the smae size.
 @discussion Elements are NPLayoutCell objects.
 */
@property(retain) NSSet *cells;

/*!
 @abstract Defines which direction/dimension of the cells is constrained.
 */
@property(assign) NPLayoutDirection direction;

@end
