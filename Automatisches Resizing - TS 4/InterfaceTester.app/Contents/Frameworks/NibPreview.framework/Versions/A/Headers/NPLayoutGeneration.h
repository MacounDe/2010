/*!
 @header
 NPLayoutGeneration.h
 Created by max on 02.12.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayout.h>
#import <NibPreview/NPLayoutTabStop.h>
#import <NibPreview/NPLayoutDefines.h>

@class NPLayoutCell, NPObject;

/*!
 @abstract Methods used when a layout is to be generated from scratch.
 */
@interface NPLayout (NPLayoutGeneration)

/*!
 @abstract Generates the layout from the current root object. 
 @discussion Returns YES upon success, otherwise NO.
 */
- (BOOL)generateLayout;

/*!
 @abstract Primitive cell generation method.
 @discussion First groups the given objects horizontally and vertically. Then using the according tab stops it creates cells for each control. If more than one control is supposed to be in one cell, the method is called recursively.
 Returns the generated cells as well as the minimum and maximum tab stop for the horizontal and vertical orientation each.
 */
+ (void)generateLayoutCells:(NSArray **)outCells horizontalTabStops:(NSArray **)outHStops verticalTabStops:(NSArray **)outVStops fromObjects:(NSArray *)objects inBounds:(NSRect)bounds;

/*!
 @abstract Create groups of objects based on the original's coordinates.
 @discussion Takes an NSArray of NPObjects, examining each original's layout frame and grouping them horizontally, if horizontal is set, or vertically otherwise. Elements not completly lying within the bounds are ignored. Returns the number of elements in the outGroups NSRectArray. The returned rects are the bounding boxes for each group and ordered by increasing coorinates.
 You are responsible for manually releasing the returned array using free()!
 */
+ (NSUInteger)groupObjects:(NSArray *)objects inBounds:(NSRect)bounds direction:(NPLayoutDirection)direction groups:(NSRectArray *)outGroups;

/*!
 @abstract Creates tab stops for a set of groups.
 @discussion The passed groups should be sorted by coorinates. Setting horizontal to YES generates horizontal tab stops determined by the y-coordinates of the passed rectangles. Othwerwise vertical tab stops determined by the x-coordinates are generated. Count is the number of rects in groups.
 Returns an NSArray of NPLayoutTabStops.
 */
+ (NSArray *)tabStopsForGroups:(NSRectArray)groups count:(NSUInteger)count direction:(NPLayoutDirection)direction;

/*!
 @abstract Removes duplicate tab stops from the graph started by the passed tab stop.
 @discussion This is done by traversing the tab stop graph and merging all adjacent tab stops with the same original position into one. The attached cells will be updated accordingly. Raises an NSInternalInconsitencyException if the graph is not sound as to the definition in the class description.
 Returns the minimal tab stop reduced tab stop graph.
 */
+ (NPLayoutTabStop *)removeDuplicateTabStopsFromGraph:(NPLayoutTabStop *)tabStop;

/*!
 @abstract Generates cell constraints for a set of cells.
 @discussion First looks for similar cells using similarCellsForCell:fromSet: and second, creates a cell constraint for each matching group. Returns a set of NPLayoutSizeConstraint objects.
 */
+ (NSSet *)generateCellConstraintsForCells:(NSSet *)theCells direction:(NPLayoutDirection)direction;

/*!
 @abstract Finds similar cells for a cell among a set of cells.
 @discussion Similar cells must have a single contained view of the same class (like button, etc) and have the same width or height. (Currently only the same width is implemented and supported.)
 Returns nil if no similar cells were found, a set containing the cell as well as the similar cells.
 */
+ (NSSet *)similarCellsForCell:(NPLayoutCell *)cell fromSet:(NSSet *)allCells;

/*!
 @abstract Generates tab stop constraints for a tab stop graph.
 @discussion Iterates through the graph and for every adjacent pair of tab stops that have no cell between them, cells attched and have a distinct range of distance, a tab stop constraint is created. Precisely, these rules are applied:
 - Exactly one cell at each stop
	if cells similar and distance < 30 -> fixed size
	otherwise -> see next
 - Other number of cells
	if distance <= 10 -> fixed size
	if distance <= 20 -> min size
	otherwise -> min size = 10
 */
+ (NSSet *)generateDistanceConstraintsForGraph:(NPLayoutTabStop *)tabStop;

/*!
 @abstract Generates tab stop constraints for a set of cells.
 @discussion Iterates through the cells and for every adjacent pair of tab stops where one's cell's views are descendants of the other's cell's view generates a distance constraint. The minimum size is the distance between them, but at most 5. The maximum is unbounded.
 */
+ (NSSet *)generateNestingConstraintsForCells:(NSSet *)theCells direction:(NPLayoutDirection)direction;

/*!
 @abstract Special constraints required for tab views.
 @discussion Reduces the tab stop graph to have only one stop for the bounds of the nested views and returns a fixed-distance constraint for the distance between the outer and inner tab stop.
 */
+ (NSSet *)generateConstraintsForTabViewsInCells:(NSSet *)theCells direction:(NPLayoutDirection)direction;

@end


/*!
 @abstract Methods extending NPLayoutTabStop used by the layout generation.
 */
@interface NPLayoutTabStop (NPLayoutGeneration)

/*!
 @abstract Merges the tab stop into the given tab stop.
 @discussion The called tab stop will be *empty* afterwards. All smaller tab stops are redirected to the larger tab stop, all larger tab stops and cells will be moved to the other tab stop.
 */
- (void)mergeIntoTabStop:(NPLayoutTabStop *)merge;

@end



