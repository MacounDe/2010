/*!
 @header
 BLXcodeImporter.h
 Created by max on 01.07.09.
 
 @copyright 2004-2009 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLDatabaseDocument.h>

/*!
 @abstract An interface to reading and importing file-paths from Xcode projects.
 */
@interface BLXcodeImporter : NSObject
{
	IBOutlet NSView		*optionsView;
	
	BLDatabaseDocument	*_document;
}

/*!
 @abstract Imports an user-selected Xcode project to a database document.
 @discussion This method will first open a sheet to allow th user to select a project and choose some options, and will then call importXcodeProjectAtPath:toDatabaseDocument:withOptions:.
 */
+ (void)importXcodeProjectToDatabaseDocument:(BLDatabaseDocument *)document;


/*!
 @enum BLXcodeImporterSettings
 @abstract The options that can be given to a Xcode importer.
 
 @const BLXcodeImporterRescanExistingFiles	Files that are already contained in an database will be rescanned.
 */
typedef enum {
	BLXcodeImporterRescanExistingFiles	= 1<<0
} BLXcodeImporterSettings;

/*!
 @abstract Imports all localizable files in the Xcode project to the database document.
 @discussion This will open and parse the passes Xcode project using BLXcodeProjectParser, from the result extract all localizable files and then add them to the database document. See BLXcodeImporterSettings for possible values for options.
 */
+ (void)importXcodeProjectAtPath:(NSString *)path toDatabaseDocument:(BLDatabaseDocument *)document withOptions:(NSUInteger)options;

@end


