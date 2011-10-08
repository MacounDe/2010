/*!
 @header
 BLDatabaseDocument.h
 Created by Max Seelemann on 28.04.09.
 
 @copyright 2004-2009 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLDocument.h>

@class BLPathCreator, BLProcessManager;

#define kCurrentDocumentVersion 3
extern NSString *DocumentVersionKeyName;

/*!
 @abstract BLDatabaseDocument preference key: NSNumber containing a BOOL.
 @discussion If YES, exporting Localizer files will create a separate file for each language, otherwise just a single file is created.
 */
extern NSString *BLDatabaseDocumentLocalizerFilesSaveToOneFileKey;

/*!
 @abstract BLDatabaseDocument preference key: NSNumber containing a BOOL.
 @discussion If YES, exported Localizer files will include a interface preview. This is done by copying all interface files into the package.
 */
extern NSString *BLDatabaseDocumentLocalizerFilesIncludePreviewKey;

/*!
 @abstract BLDatabaseDocument preference key: NSNumber containing a BOOL.
 @discussion If YES, exported Localizer files will include an embedded dictionary, created form the currently available keys in the BLDictionaryController, that .
 */
extern NSString *BLDatabaseDocumentLocalizerFilesEmbedDictionaryKey;

/*!
 @abstract BLDatabaseDocument preference key: NSString.
 @discussion A document-relative path to the folder where Localizer files should be exported.
 */
extern NSString *BLDatabaseDocumentLocalizerFilesPathKey;

/*!
 @abstract BLDatabaseDocument preference key: NSNumber containing a BLNamingStyle.
 @discussion The default naming style for newly created bundle objects in the document.
 */
extern NSString *BLDatabaseDocumentBundleNamingStyleKey;

/*!
 @abstract BLDatabaseDocument preference key: NSNumber containing a BLReferencingStyle.
 @discussion The default referencing style for newly created bundle objects in the document.
 */
extern NSString *BLDatabaseDocumentBundleReferencingStyleKey;

/*!
 @abstract BLDatabaseDocument preference key: NSString.
 @discussion The most recently used folder chosen by the user for opening or exporting files.
 */
extern NSString *BLDatabaseDocumentOpenFolderKey;


/*!
 @abstract A basic database storage document that does all the data handling but has no interface support whatsoever.
 @discussion To add user interaction or other custom functionality, override this class.
 */
@interface BLDatabaseDocument : BLDocument
{
    BLPathCreator       *_pathCreator;
	BLProcessManager	*_processManager;
	
    NSArray				*_bundles;
    NSArray				*_languages;
    NSMutableDictionary *_preferences;
    NSString            *_referenceLanguage;
}

/*!
 @abstract Returns the document's path creator.
 */
- (BLPathCreator *)pathCreator;

/*!
 @abstract Returns the document's process manager.
 */
- (BLProcessManager *)processManager;

/*!
 @abstract The bundle objects of the document.
 */
@property(retain) NSArray *bundles;

/*!
 @abstract Add the bundle to the document.
 @discussion The bundle will only be added if it is not currently present in the document.
 */
- (void)addBundle:(BLBundleObject *)bundle;

/*!
 @abstract Removes the given bundle from the document.
 */
- (void)removeBundle:(BLBundleObject *)bundle;

/*!
 @abstract The languages contained in the document.
 */
@property(retain) NSArray *languages;

/*!
 @abstract Add the given language.
 @discussion The given language will only be added if it is not currently present in the document. If language is the first to be added, it is automatically assigned to be the reference language.
 */
- (void)addLanguage:(NSString *)language;

/*!
 @abstract Removes the given language from the document.
 @discussion Please note that this method does not remove the strings for this language, this method removed just the notion that this language exists.
 */
- (void)removeLanguage:(NSString *)language;

/*!
 @abstract The reference language of the document.
 @discussion This language is used by mostly all functions, it is treaded special most of the times. Normally this should be the language that you do your development in. Changes will be transfered FROM this language to all others. So take care when changing it.
 If no reference language is set, this method returns the defualt reference language, namely @"en".
 When setting, only the language will be changed, no data is affected. However, there is a huge difference in changing the reference language. This method will also add the language to the languages array if it is not yet contained in the document.
 */
@property(retain) NSString *referenceLanguage;

/*!
 @abstract Settings of the user that affect the working of some methodes.
 */
@property(retain) NSMutableDictionary *preferences;

/*!
 @abstract The default settings when creating a new database.
 */
+ (NSDictionary *)defaultPreferences;

@end
