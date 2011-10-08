/*!
 @header
 NPPreviewOwner.h
 Created by max on 07.06.08.
 
 @copyright 2008-2009 Localization Suite. All rights reserved.
 */

@class NPDescriptionLoader, NPObject, NPPreviewBuilder;

/*!
 @abstract The owner of a nib preview.
 @discussion NPDescriptionLoader and NPPreviewBuilder are used as utilities to actually create the preview, which is then held by this owner.
 @see NPDescriptionLoader NPDescriptionLoader
 @see NPPreviewBuilder NPPreviewBuilder
 */
@interface NPPreviewOwner : NSObject
{
	NPPreviewBuilder	*_builder;
	BLFileObject		*_fileObject;
	NSString			*_language;
	NPDescriptionLoader	*_loader;
	NSString			*_path;
}

/*!
 @abstract Default init method. Creates a preview with the file at the given path.
 */
- (id)initWithNibAtPath:(NSString *)aPath;

/*!
 @abstract Loads the nib file from disk and actually instantiates the preview.
 @discussion If called another time, the previous preview will be removed, and replaced by the new one.
 */
- (void)loadNib;

/*!
 @abstract All root objects contained in the nib file.
 @discussion Instances are of the class NPObject.
 @see NPObject NPObject
 */
@property(readonly) NSArray *rootObjects;

/*!
 @abstract Returns a preview object for a interface element with a given id.
 @see NPObject NPObject
 */
- (NPObject *)objectForNibObjectID:(NSString *)objectID;

/*!
 @abstract The file object associated with the preview.
 @discussion Changing this property will recursively associate contained key objects with NPObjects.
 */
@property(retain) BLFileObject *associatedFileObject;

/*!
 @abstract The language the preview is to be displayed in.
 @discussion Setting a language will load the localization of the associatedFileObject into the preview object tree.
 Defaults to nil.
 */
@property(retain) NSString *displayLanguage;

@end

