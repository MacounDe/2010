/*!
 @header
 NPViewLayoutExtensions.h
 Created by max on 29.11.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

/*!
 @abstract Extension to NSView for getting layout information about an object.
 */
@interface NSView (NPViewLayoutExtensions)

/*!
 @abstract Converts a rect in superview's coordinates to a layout rect in superviews coordinates.
 @discussion Basically this just applies the insets defined by the view.
 */
- (NSRect)convertRectToLayoutRect:(NSRect)rect;

/*!
 @abstract Converts a rect in superview's coordinates from a layout rect in superviews coordinates.
 @discussion Basically this just applies the insets defined by the view.
 */
- (NSRect)convertRectFromLayoutRect:(NSRect)rect;

/*!
 @abstract The frame of an object usable for layout.
 @discussion The frame is converted from/to the view's frame using the layout insets defined above.
 */
@property(assign) NSRect layoutFrame;

/*!
 @abstract Returns whether the view has a changeable width. Static property.
 */
- (BOOL)isWidthSizable;

/*!
 @abstract Returns whether the view has a changeable height. Static property.
 */
- (BOOL)isHeightSizable;

/*!
 @abstract Returns whether the view has any kind of content that can be used to determine the correct size. Static property.
 */
- (BOOL)hasSizeableContent;

/*!
 @abstract The static minimum width of the view.
 @discussion If possible, getMinimumSizes: should be choosen over this property, since it being static. Please be aware that this size is given in layout coordinates, not view coordinates!
 */
- (CGFloat)minimumWidth;

/*!
 @abstract The static minimum height of the view.
 @discussion If possible, getMinimumSizes: should be choosen over this property, since it being static. Please be aware that this size is given in layout coordinates, not view coordinates!
 */
- (CGFloat)minimumHeight;

/*!
 @abstract The set of minimum sizes for the control.
 @discussion The minimum sizes is a set of sizes that may restrict the minimum size of a view. The set supports queries in two directions: the minimum height for a given width and vice versa. To look up a minimum height, search the set of sizes for two adjacent sizes that are at least as wide as the given one. Then interpolate their heights and take that value.
 The caller is responsible for freeing the returned array. Please be aware that the sizes are given in layout coordinates, not view coordinates!
 */
- (NSSizeArray)getMinimumSizes:(NSUInteger *)count;

/*!
 @abstract Returns whether the view is similar to another view.
 @discussion The default is just a check whether the view's class matches, but subclasses migth perfrom additional checks.
 */
- (BOOL)isSimilarToView:(NSView *)other;

@end
