/*!
 @header
 NPLayoutApplication.h
 Created by max on 12.01.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayout.h>
#import <NibPreview/NPLayoutDefines.h>


@class NPLayoutEquation, NPLayoutCell, NPLayoutTabStop, NPObject;

/*!
 @abstract The name of the notification posted whenever the layout has applied.
 @discussion The user info dictionary will contain a NSNumber for the key NPLayoutApplyResultUserInfoKey.
 */
extern NSString *NPLayoutDidApplyNotificationName;

/*!
 @abstract Whether the application was successfull or not - NSNumber of BOOL.
 */
extern NSString *NPLayoutApplicationResultUserInfoKey;


/*!
 @abstract Methods used when data in a layout changes and need to be applied again.
 */
@interface NPLayout (NPLayoutApplication)

/*!
 @abstract Calculates the layout.
 @discussion If an optimal solution is found, YES is returned and the current positions of all tab stops are changed. However, it does not resize the views accordingly. When no optimal solution was found, NO is returned and no changes are applied.
 */
- (BOOL)calculateLayout;

/*!
 @abstract Resets all tab stops to their original positions.
 @discussion Note that the frames of the views in the cells are also reset, as well as the outermost container view. You'll barely need invoke this directly.
 */
- (void)resetLayout;

/*!
 @abstract Reflects changed tab stop positions by resizing views accordingly.
 @discussion This is mostly just a convenience interface to NPLayoutCell's -updateViewFrames, but also sets the outermost view's frame accordingly, if needed.
 */
- (void)applyCurrentTabStopPositions;

/*!
 @abstract Generates the equations for the borders of the layout.
 @discussion Depending on the sizability of the layout this fixes the min and the max border to the original position. 
 */
- (NSSet *)borderEquationsForDirection:(NPLayoutDirection)direction;

/*!
 @abstract Generates a set of equations representing the order in the tab stop graph.
 @discussion Encodes each edge in the graph as an equation. For an edge from t1 to t2, an equation equal to the equation t1 <= t2 will be created.
 */
+ (NSSet *)orderEquationsForTabStopGraph:(NPLayoutTabStop *)tabStop;

/*!
 @abstract Generates a set of equations representing the optimality of positions in the tab stop graph.
 @discussion For each tab stop, creates a variable calculating the deviation from it's original position. The returned target function is acutally an equation, but the type and the constant part must be ignored however. The target function ensures the final layout is as close to the original as possible.
 */
+ (NSSet *)optimalityEquationsForTabStopGraph:(NPLayoutTabStop *)tabStop targetFunction:(NPLayoutEquation **)targetFunction;

/*!
 @abstract Generates a set of equations representing the optimality of positions for the given cells.
 @discussion For each cell and direction, creates a variable calculating the deviation from it's original position. The returned target function is acutally an equation, but the type and the constant part must be ignored however. The target function ensures the final layout is as close to the original as possible.
 */
+ (NSSet *)optimalityEquationsForCells:(NSSet *)theCells targetFunction:(NPLayoutEquation **)targetFunction;

@end
