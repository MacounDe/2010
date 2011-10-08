/*!
 @header
 BLFileObject.h
 Created by Max on 27.10.04.
 
 @copyright 2004-2009 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLObject.h>

@class BLBundleObject, BLKeyObject;

/*!
 @abstract The attached objects key where backups of files are stored.
 @discussion See attachedObjectForKey:version: for details.
 */
extern NSString *BLBackupAttachmentKey;

/*!
 @abstract Represents a file in a localization context.
 @discussion Some behaviours depend on the type of the file, especially the extension. This class represents a class cluster. If you want to subclass it, call +registerClass:forPathExtension: registerung your class to be recognized in the process of creating objects.
 */
@interface BLFileObject : BLObject
{
	NSMutableDictionary	*_attachments;
    BLBundleObject		*_bundleObject;
    NSString			*_customType;
    NSString			*_hashValue;
    NSMutableArray		*_objects;
    NSMutableArray		*_oldObjects;
    NSString			*_path;
	NSMutableDictionary	*_snapshots;
	NSMutableDictionary	*_versions;
}

/*!
 @abstract Creates an file object suited for the given file type at path.
 @discussion The actual returned object will be a subclass of BLFileObject, as this class is a class cluster.
 */
+ (id)fileObjectWithPath:(NSString *)path;

/*!
 @abstract Creates an file object suited for the given file type.
 @discussion The actual returned object will be a subclass of BLFileObject, as this class is a class cluster.
 */
+ (id)fileObjectWithPathExtension:(NSString *)extension;

/*!
 @abstract Initializes a new file object using the given path.
 @discussion The file object's path is the relative portion of the given path. This method also creates a new bundle object with the bundle path portion of the given path. The file object is added to the bundle. Please note that this may result in duplicate bundles that must be resolved afterwards!
 However, if the path cannot be split into the two portions, the result is a file object with no bundle and it's path set to the given one.
 */
- (id)initWithPath:(NSString *)path;

/*!
 @abstract Initializes a new blank file of the given type.
 @discussion In contrast to initWithPath: this does neither set a path nor create a bundle object.
 */
- (id)initWithPathExtension:(NSString *)extension;



/*!
 @abstract Returns the subclass of BLKeyObject to be used when creating keys.
 */
+ (Class)classOfStoredKeys;

/*!
 @abstract Returns an array with all path extensions registered by subclasses. Other extensions will not be accepted.
 */
+ (NSArray *)availablePathExtensions;

/*!
 @abstract Retuns the concrete implementation subclass for the given extension.
 @discussion You should not use this method to instantiate such classes directly, use fileObjectWithPathExtension: instead!
 */
+ (Class)classForPathExtension:(NSString *)ext;

/*!
 @abstract Registers a subclass to a file extension.
 @discussion Subclasses should call this one in their +load method, as there are few other possibilites to register a class before it is to be used. Throws, if the class is not a subclass or if the extension has already been registered to any class.
 */
+ (void)registerClass:(Class)fileClass forPathExtension:(NSString *)extension;



/*!
 @abstract The bundle containing the file object.
 */
@property(retain) BLBundleObject *bundleObject;

/*!
 @abstract If the file is to be handled differently, this is the path extension.
 @discussion Bein either nil or a path extension, the custom file type overrides the path extension of the file's path. As such, e.g. a file interpreter or a file creator will trat this file object as if it was of a different type.
 */
@property(retain) NSString *customFileType;

/*!
 @abstract The md5 hash value used to notice when the contents of the source file changed.
 */
@property(retain) NSString *hashValue;

/*!
 @abstract The path of the file inside a language project folder.
 */
@property(retain) NSString *path;

/*!
 @abstract A user-presentable string hosting information about the format of the file.
 */
@property(readonly) NSString *fileFormatInfo;



/*!
 @abstract The key objects belonging to the file object.
 */
@property(retain) NSArray *objects;

/*!
 @abstract Key objects that used to belong to the file object, but no longer make up it's content.
 @discussion These objects are kept to not loose their localized values. They may be (and acutally are) used to pretranslate newly imported strings.
 */
@property(retain) NSArray *oldObjects;

/*!
 @abstract Adds a key object to the set of objects.
 @discussion Just a convenience method, should be prefered over directly action on the objects array.
 */
- (void)addObject:(BLKeyObject *)object;

/*!
 @abstract Removes a key object from the set of objects, adding it to the set of old objects.
 @discussion Just a convenience method, should be prefered over directly action on the objects array.
 */
- (void)removeObject:(BLKeyObject *)object;

/*!
 @abstract Returns the key object for a given key, creating it if needed.
 @discussion This is just a convenience call for objectForKey:createIfNeeded: with create set to YES.
 */
- (id)objectForKey:(NSString *)key;

/*!
 @abstract Returns the key object for a given key, creating it if wished.
 @discussion If create is YES and no key object with the given key can be found, a new one of the file's class of stored keys is being created and immediatelly added to the file's key objects.
 */
- (id)objectForKey:(NSString *)key createIfNeeded:(BOOL)create;

/*!
 @abstract Removes all objects that match the passed keys from set of objects.
 @discussion Removed objects will be placed in the old objects array. Returns the number of affected objects.
 */
- (NSUInteger)removeObjectsWithKeyInArray:(NSArray *)limitedKeys;

/*!
 @abstract Removes all objects that do NOT match the passed keys from set of objects.
 @discussion Removed objects will be placed in the old objects array. Returns the number of affected objects.
 */
- (NSUInteger)removeObjectsWithKeyNotInArray:(NSArray *)limitedKeys;


/*!
 @abstract Will create a snapshot of the file for a given language.
 @discussion All key objects will be snapshot as well.
 */
- (void)snapshotLanguage:(NSString *)language;

/*!
 @abstract Returns the key objects that were in the snapshot for the language.
 @discussion If no snapshot was created, the file's objects are returned. The snapshot key values must however be accessed by the key's snapshot feature.
 */
- (NSArray *)snapshotForLanguage:(NSString *)language;


/*!
 @abstract A version number for a given language.
 @discussion Version numbers allow versioned access to the attached objects. If no version has been set previously, the highest version available will be returned. Thus, passing nil as language will always return the largest version number.
 */
- (NSUInteger)versionForLanguage:(NSString *)language;

/*!
 @abstract Sets a version number for a given language.
 @discussion See -versionForLanguage: for details. Setting zero resets the version of the language.
 */
- (void)setVersion:(NSUInteger)version forLanguage:(NSString *)language;

/*!
 @abstract Increases the version of the given language to be the maximum.
 @discussion This method will change the version of the given language to be at least 1 larger than the version of every other language. All attached objects for the version of the language will also be referencd from the new version, nothing is copied. However, this bump is performed only if the language does not yet fulfill the criteria. This method returns YES, if the version any change was done, and NO otherwise.
 */
- (BOOL)offsetVersionForLanguageIfNeeded:(NSString *)language;


/*!
 @abstract Convenience accessor to the newest version of the attached object.
 @discussion Forwards to -attachedObjectForKey:version: with the newest version available amongst all langugages.
 */
- (id)attachedObjectForKey:(NSString *)key;

/*!
 @abstract An attached object for a key and a version number.
 @discussion This mechanism allows the versioned storage of attached objects. Only objects whose version number exists in the array of version for languages will be persisted. The whole system basically is a versioned storage for realated objects that need not to be known but are important for some functions. Versions are introduced to cope with different versions of persisted files per language.
 */
- (id)attachedObjectForKey:(NSString *)key version:(NSUInteger)version;

/*!
 @abstract Stores an attached object for a given key and version number.
 @discussion See -attachedObjectForKey:version: for details.
 */
- (void)setAttachedObject:(id)object forKey:(NSString *)key version:(NSUInteger)version;

@end


