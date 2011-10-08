/*!
 @header
 NPLayoutVersioning.h
 Created by max on 24.03.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayout.h>
#import <NibPreview/NPLayoutDefines.h>

/*!
 @abstract Methods used to migrate changes in a layout to another version of the base.
 */
@interface NPLayout (NPLayoutVersioning)

/*!
 @abstract Calculates and returns the logical representation of the tab stop graph.
 
 */
- (void)getLogicalTabStops:(NSSet **)tabStops andEdges:(NSSet **)edges direction:(NPLayoutDirection)direction;

@end
