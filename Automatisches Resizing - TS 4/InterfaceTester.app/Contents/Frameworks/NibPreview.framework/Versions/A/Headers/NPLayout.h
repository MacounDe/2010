/*!
 @header
 NPLayout.h
 Created by max on 29.11.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

@class NPLayoutTabStop, NPObject;

/*!
 @abstract An object representing the layout of a view hierarchy.
 @discussion TODO: We need a description here.
 */
@interface NPLayout : NSObject
{
	// Persistent attributes
	NSSet			*_cells;
	BOOL			_enabled;
	NSSet			*_horizontalConstraints;
	NPLayoutTabStop	*_horizontalTab;
	BOOL			_horizontallyResizable;
	NSSize			_maximumSize;
	NSSize			_originalSize;
	NSSet			*_verticalConstraints;
	NPLayoutTabStop	*_verticalTab;
	BOOL			_verticallyResizable;
	
	// Lazy deserialization
	NSString		*_rootObjectID;
	
	// Transient attributes
	BOOL			_asyncApplication;
	NSSet			*_brokenCells;
	NSLock			*_isCalculating;
	BOOL			_needsLayout;
	NPObject		*_rootObject;
}

/*!
 @abstract Whether the layout is enabled or not.
 @discussion Setting this property to NO will result in a bevavior as if no layout was used at all.
 */
@property(assign) BOOL layoutIsEnabled;

/*!
 @abstract The horizontal tab stop creating the horizontal tab stop graph used by the layout.
 @discussion The horizontal tab stops, positioned on the horizontal axis, define the left and right (vertical) edges of a cell in the layout.
 */
@property(retain) NPLayoutTabStop *horizontalTabStops;

/*!
 @abstract The vertical tab stop creating the vertical tab stop graph used by the layout.
 @discussion The vertical tab stops, positioned on the vertical axis, define the top and bottom (horizontal) edges of a cell in the layout.
 */
@property(retain) NPLayoutTabStop *verticalTabStops;

/*!
 @abstract Determines whether the layout can be resized in width or not.
 */
@property(assign,getter=isHorizontallyResizable) BOOL horizontallyResizable;

/*!
 @abstract Determines whether the layout can be resized in height or not.
 */
@property(assign,getter=isVerticallyResizable) BOOL verticallyResizable;

/*!
 @abstract Defines a maximum width for the containing view of the layout.
 @discussion Default value is 0, which means no maximum. Different from most other properties, this directly refers to the frame of the outer view. Please note that this property is only taken into account if the layout is horizontally resizable and it's value is at least as large as the original width.
 */
@property(assign) CGFloat maximumWidth;

/*!
 @abstract Defines a maximum height for the containing view of the layout.
 @discussion Default value is 0, which means no maximum. Different from most other properties, this directly refers to the frame of the outer view. Please note that this property is only taken into account if the layout is vertically resizable and it's value is at least as large as the original height.
 */
@property(assign) CGFloat maximumHeight;

/*!
 @abstract The cells composing the layout.
 @discussion Objects are of class NPLayoutCell.
 */
@property(retain) NSSet *cells;

/*!
 @abstract The horizontal constraints contained in the layout.
 @discussion Objects are of class NPLayoutConstraint and use horizontal tab stops only.
 */
@property(retain) NSSet *horizontalConstraints;

/*!
 @abstract The vertical constraints contained in the layout.
 @discussion Objects are of class NPLayoutConstraint and use vertical tab stops only.
 */
@property(retain) NSSet *verticalConstraints;

/*!
 @abstract The root preview object.
 */
@property(readonly) NPObject *rootObject;

@end

/*!
 @abstract Further methods of NPLayout.
 */
@interface NPLayout (NPLayoutExtended)

/*!
 @abstract Initializes a layout with a preview object tree.
 @discussion Will analyze the given object tree and attempt to create an layout from it.
 */
- (id)initWithRootObject:(NPObject *)object;

/*!
 @abstract For a de-serialized layout, re-connecti it with it's preview.
 @discussion This method works for de-serialized previews only and will work only once. The given preview is taken as if the layout had originally been generated from it.
 */
- (void)setUpWithPreview:(NPPreview *)preview;

/*!
 @abstract Disconnects the layout from the preview underneath.
 @discussion This is a good way to keep the layout but not having to keep the preview in memory all the time.
 */
- (void)disconnectFromPreview;

/*!
 @abstract If set, all changes to elements will trigger an automatic asynchronous background application.
 @discussion If disabled, the layout needs to be explicitly applied using -applyLayout.
 */
@property(assign) BOOL applyAutomatically;

/*!
 @abstract Makes the layout dirty and issues asynchronous re-layout as soon as the run loop is idle.
 */
- (void)setNeedsLayout:(BOOL)flag;

/*!
 @abstract Updates the layout using the constraints, adjusting it to fit all contents.
 @discussion Tries to first calculate the layout horizontally, then vertically and when no problems occur (i.e. an optimal solution is found) updates the frames of all views. In this cases the method returns YES. However, if for at least one direction, no solution was found, the layout is reset to the original position and the method returns NO. The latter case should be barely possible.
 A result of YES, however, does not imply that all contents of all cells did fit. A solution is only optimal if there are no broken cells, i.e., cell which do not fit their contents.
 */
- (BOOL)applyLayout;

/*!
 @abstract The cells whose contents could not be fit during the last application.
 @discussion See -applyLayout for details.
 */
@property(readonly) NSSet *brokenCells;


/*!
 @abstract Calculates the changes done in changed over original and merges them into the current one.
 @discussion Finds the differences between the given orginial and modified layout and tries to re-apply as many of them as possible.
 
 This assumes that the changed layout is a modified version of the original one and that the callee is a new version of the original. Generally this is a three-way-merge algorithm. The differences between the two given layouts are computed, and then re-applied to the receiver. However, not all changes may still be applicable and will thus be ignored.
 */
- (void)adoptChangesOfLayout:(NPLayout *)changed overOriginalLayout:(NPLayout *)original;

@end
