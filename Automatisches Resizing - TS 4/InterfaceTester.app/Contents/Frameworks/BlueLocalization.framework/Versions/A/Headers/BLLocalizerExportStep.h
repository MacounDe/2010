/*!
 @header
 BLLocalizerExportStep.h
 Created by Max on 08.05.09.
 
 @copyright 2004-2009 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLProcessStep.h>

/*!
 @enum BLLocalizerExportStep options
 
 @const BLLocalizerExportStepSeparateFilesOption	If set, each non-reference language will be exported togehter with the reference to a separate file.
 @const BLLocalizerExportStepIncludePreviewOption	Set this option to include a interface preview.
 @const BLLocalizerExportStepEmbedDictionaryOption	Includes a dictionary from the currently loaded dictionaries. IF the final executable is also linked with the LocTools Framework, the dictionary will be tailored to include matching (>=50%) strings only. 
 @const BLLocalizerExportStepCompressFilesOption	If set, the resulting files will be compressed using tar and gz.
 @const BLLocalizerExportStepKeepUncompressedOption	If set and BLLocalizerExportStepCompressFilesOption is active, uncompressed files won't be deleted afterwards.
 @const BLLocalizerExportStepOpenInLocalizerOption	If set the resulting file will be opened in localizer afterwards. However, this enforces BLLocalizerExportStepKeepUncompressedOption.
 @const BLLocalizerExportStepOpenFolderOption		Opens the targeted folder after writing out all files.
 */
enum {
	BLLocalizerExportStepSeparateFilesOption	= 1<<0,
	BLLocalizerExportStepIncludePreviewOption	= 1<<1,
	BLLocalizerExportStepEmbedDictionaryOption	= 1<<6,
	
	BLLocalizerExportStepCompressFilesOption	= 1<<2,
	BLLocalizerExportStepKeepUncompressedOption	= 1<<3,
	BLLocalizerExportStepOpenInLocalizerOption	= (1<<4) | BLLocalizerExportStepKeepUncompressedOption,
	BLLocalizerExportStepOpenFolderOption		= 1<<5
};

/*!
 @abstract A step that exports Localizer files from a set of objects.
 */
@interface BLLocalizerExportStep : BLProcessStep
{
	NSString	*_basePath;
	NSArray		*_languages;
	NSArray		*_objects;
	NSUInteger	_options;
	NSString	*_status;
}

/*!
 @abstract Creates a step group for exporting objects to Localizer files.
 @discussion The options are BLLocalizerExportStep options, combined by logical or (|). 
 */
+ (NSArray *)stepGroupForExportingLocalizerFilesToPath:(NSString *)basePath fromObjects:(NSArray *)objects forLanguages:(NSArray *)languages withOptions:(NSUInteger)options;

/*!
 @abstract Generates the name of a Localizer file for a given language in a given document.
 */
+ (NSString *)nameForLocalizerFileOfLanguage:(NSString *)language inDocument:(NSDocument <BLDocumentProtocol> *)document;

@end