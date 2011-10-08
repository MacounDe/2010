/*!
 @header
 LIContentController.h
 Created by max on 25.08.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

@class LIContentArrayController;

extern NSString *LIContentStatusColumnIdentifier;
extern NSString *LIContentActiveColumnIdentifier;
extern NSString *LIContentUpdatedColumnIdentifier;
extern NSString *LIContentFileColumnIdentifier;
extern NSString *LIContentKeyColumnIdentifier;
extern NSString *LIContentLeftColumnIdentifier;
extern NSString *LIContentRightColumnIdentifier;
extern NSString *LIContentCommentColumnIdentifier;
extern NSString *LIContentMediaColumnIdentifier;

/*!
 @abstract Controller object holding a view for displaying an array of key objects.
 @discussion The view being provided is a scroll view containing a table view. Users may set the hostView outlet to a instance of a content controller in interface builder. This results in the controller automatically placing it's view to fill the host.
 */
@interface LIContentController : NSObject <QLPreviewPanelDataSource>
{
	IBOutlet LIContentArrayController	*arrayController;
	IBOutlet NSView						*hostView;
	IBOutlet NSScrollView				*scrollView;
	IBOutlet NSTableView					*tableView;
	
	NSString	*_leftLanguage;
	NSArray		*_objects;
	NSString	*_previewPath;
	NSString	*_rightLanguage;
}

/*!
 @abstract Designated Initializer.
 */
- (id)init;

/*!
 @abstract The scroll view containing the content display.
 @discussion You might adjust this view to your needs, like changing control sizes and changing the frame.
 */
- (NSScrollView *)view;

/*!
 @abstract The table view displaying the content.
 */
- (NSTableView *)contentView;

/*!
 @abstract The objects whose keys are being displayed.
 @discussion Need not be key objects only, might be any mixture of BLObjects.
 */
@property(retain) NSArray *objects;

/*!
 @abstract The key objects actually being displayed.
 */
@property(readonly) NSArray *keyObjects;

/*!
 @abstract For performance considerations, bound the number of visible objects to a reasonable amount.
 @discussion Setting 0 means no limit.
 */
@property(assign) NSUInteger maximumVisibleObjects;

/*!
 @abstract The currently visible objects.
 @discussion This is affected by searches, filterPredicates, languages etc.
 */
@property(readonly) NSArray *visibleObjects;

/*!
 @abstract The object currently selected in the table.
 @discussion This property is observable and also bindable.
 */
@property(retain) BLKeyObject *selectedObject;

/*!
 @abstract The (identifier of the) language to be shown in the left content column.
 */
@property(retain) NSString *leftLanguage;

/*!
 @abstract Whether the left language column in user-editable.
 */
@property(assign) BOOL leftLanguageEditable;

/*!
 @abstract The (identifier of the) language to be shown in the right content column.
 */
@property(retain) NSString *rightLanguage;

/*!
 @abstract Whether the right language column in user-editable.
 */
@property(assign) BOOL rightLanguageEditable;

/*!
 @abstract Whether the user can edit the attached media of keys.
 */
@property(assign) BOOL attachedMediaEditable;

/*!
 @abstract Allows to show or hide several columns.
 */
@property(assign) NSArray *visibleColumnIdentifiers;

/*!
 @abstract Sets the hidden property of the passed table column.
 */
- (void)setColumnWithIdentifier:(NSString *)identifier isVisible:(BOOL)visible;

/*!
 @abstract Permanently and irreversibly removes a table column.
 */
- (void)removeColumnWithIdentifier:(NSString *)identifier;

/*!
 @abstract A string the key objects should be filter for.
 @discussion Matches will be highlighted in the interface. Set to nil or @"" if no search should be performed.
 */
@property(retain) NSString *search;

/*!
 @abstract A predicate that can be set to filter the keys.
 @discussion This works in conjunction with the search string that may also be set.
 */
@property(retain) NSPredicate *filterPredicate;

/*!
 @abstract Changed the selected object to the "next" object as currently visible.
 */
- (IBAction)selectNext:(id)sender;

/*!
 @abstract Changed the selected object to the "next" object as currently visible.
 */
- (IBAction)selectPrevious:(id)sender;

@end

