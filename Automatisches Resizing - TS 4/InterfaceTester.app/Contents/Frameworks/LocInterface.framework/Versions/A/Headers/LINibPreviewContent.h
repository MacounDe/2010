/*!
 @header
 LINibPreviewContent.h
 Created by max on 06.04.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

#import <LocInterface/LIPreviewContent.h>

@class LINibPreviewOverlayView;

/*!
 @abstract A content object for loading and storing nib previews.
 */
@interface LINibPreviewContent : LIPreviewContent
{
	IBOutlet NSView	*optionsView;
	
	NPObject				*_currentRoot;
	NSDictionary			*_layouts;
	LINibPreviewOverlayView	*_overlayView;
	NPPreview				*_preview;
}

/*!
 @abstract Whether or not layout can be edited.
 */
+ (BOOL)editingEnabled;

/*!
 @abstract Set whether layout can be edited.
 */
+ (void)setEditingEnabled:(BOOL)enabled;

/*!
 @abstract The layout that is attached to the file object, if any.
 */
@property(readonly) NPLayout *currentLayout;

@end
