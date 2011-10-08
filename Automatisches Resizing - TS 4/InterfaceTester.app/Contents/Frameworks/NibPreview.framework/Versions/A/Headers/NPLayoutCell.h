/*!
 @header
 NPLayoutCell.h
 Created by max on 29.11.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayoutDefines.h>

@class NPLayoutTabStop, NPLayoutEquationVariable;

/*!
 @abstract Object representing a cell in a layout.
 */
@interface NPLayoutCell : NSObject <BLPropertyListSerialization>
{
	NSHashTable			*_constraints;
	NSUInteger			_fixedBorders;
	NSArray				*_objects;
	NSRect				_originalViewFrame;
	NPLayoutTabStop		*_tabStops[NPLayoutBorderCount];
	
	// Lazy deserialization
	NSArray				*_objectIDs;
	NSArray				*_tabStopNames;
}

/*!
 @abstract The tab stop determining the left border of the cell.
 */
@property(retain) NPLayoutTabStop *leftTabStop;

/*!
 @abstract The tab stop determining the right border of the cell.
 */
@property(retain) NPLayoutTabStop *rightTabStop;

/*!
 @abstract The tab stop determining the top border of the cell.
 */
@property(retain) NPLayoutTabStop *topTabStop;

/*!
 @abstract The tab stop determining the bottom border of the cell.
 */
@property(retain) NPLayoutTabStop *bottomTabStop;

/*!
 @abstract Returns the tab stop determining the border of the cell.
 */
- (NPLayoutTabStop *)tabStopForBorder:(NPLayoutBorder)border;

/*!
 @abstract Set the tab stop determining the given border of the cell.
 */
- (void)setTabStop:(NPLayoutTabStop *)tabStop forBorder:(NPLayoutBorder)border;

/*!
 @abstract Returns the border the tab stop is attached to.
 @discussion Returns -1 of no appropriate border is found.
 */
- (NPLayoutBorder)borderForTabStop:(NPLayoutTabStop *)tabStop;

/*!
 @abstract The original frame of the cell.
 @discussion Derived from the immutable property originalPosition of the border tab stops, and is thus read only.
 */
@property(readonly) NSRect originalFrame;

/*!
 @abstract The current frame of the cell.
 @discussion As this is soley derived from the border tab stops, this property cannot be changed.
 */
@property(readonly) NSRect currentFrame;

/*!
 @abstract The preview objects whose views are contained in the cell.
 @discussion Elements are of class NPObject. In most cases, there should be exactly one element here.
 */
@property(retain) NSArray *containedObjects;

/*!
 @abstract The views that the cell contains.
 @discussion Elements are of class NSView. This should typically be exactly one, exceptions may appear but should be avoided.
 */
@property(readonly) NSArray *containedViews;

/*!
 @abstract Reads the frames of contained views.
 @discussion This method must be called after the cell has been completely set up. The (internal) gathered information is required to resize the views accordingly when the cell's current frame has changed. Applying the changed to the views can be done using -updateViewFrames.
 */
- (void)readViewFrames;

/*!
 @abstract Changes the frames of the contained views according to the current frame of the cell.
 @discussion This requires the view frames having been read before using -readViewFrames at the proper point in time. If not, the method will throw an exception.
 */
- (void)updateViewFrames;

/*!
 @abstract The minimum width of the cell.
 @discussion This is mostly constrained by the contained view. Returning 0 means the cell has no minimum width.
 */
@property(readonly) CGFloat minimumWidth;

/*!
 @abstract The maximum width of the cell.
 @discussion This is mostly constrained by the contained view. Returning 0 means the cell has no maximum width.
 */
@property(readonly) CGFloat maximumWidth;

/*!
 @abstract The minimum height of the cell.
 @discussion This is mostly constrained by the contained view. Returning 0 means the cell has no minimum height.
 */
@property(readonly) CGFloat minimumHeight;

/*!
 @abstract The maximum height of the cell.
 @discussion This is mostly constrained by the contained view. Returning 0 means the cell has no maximum height.
 */
@property(readonly) CGFloat maximumHeight;


/*!
 @abstract Equations formalizing the resizing behavior for a cell.
 @discussion In addition, as the first argument a set penalty variables is returned. These variables should be added to the target function with a huge positive factor. It can be used as a hint at which cell might be violating it's constraints. This argument must be non-NULL!
 */
- (NSSet *)getEquations:(NSSet **)penaltyVariables;

/*!
 @abstract The borders of fixed size.
 @discussion A bit mask of NPLayoutBorderMask flags combined by a bitwise or ("|").
 */
@property(assign) NSUInteger fixedBorders;

/*!
 @abstract The constraints using the cell.
 @discussion Elements are of class NPLayoutSizeConstraint, this property is determined by the cells property of the constraints and as such is read-only.
 */
- (NSSet *)constraintsForDirection:(NPLayoutDirection)direction;

/*!
 @abstract The name of the cell.
 @discussion Depends on the contained objects, and basically is just a concatenation of the objects' nib object ids. The name is unique, as a object can be contained in only one cell and has a unique id.
 */
@property(readonly) NSString *name;

@end

