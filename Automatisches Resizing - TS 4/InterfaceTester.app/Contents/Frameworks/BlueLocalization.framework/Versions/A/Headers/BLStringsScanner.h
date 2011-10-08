/*!
 @header
 BLStringsScanner.h
 Created by Max Seelemann on 07.04.09.
 
 @copyright 2009 The Blue Technologies Group. All rights reserved.
 */

/*!
 @abstract A sophisticated strings scanner working on NSStrings.
 */
@interface BLStringsScanner : NSObject
{
}

/*!
 @abstract Scans strings and comments from an given string.
 @discussion No processing is done on the data, this has to be done separately. It is expected (and not checked) that all inputs are set correctly, especially that the mutability is given to all mutable arguments. The arguments strings, comments and keys may be nil though, if the output is not needed.
 @return YES on success, NO otherwise.
 */
+ (BOOL)scanString:(NSString *)string toDictionary:(NSMutableDictionary *)strings withComments:(NSMutableDictionary *)comments andKeyOrder:(NSMutableArray *)keys;

/*!
 @abstract Scans through the string and replaces all values with the ones in the dictionary.
 @discussion Uses the very same method for running though a string as the reading method scanString:toDictionary:withComments:andKeyOrder:. However, instead of scanning values, it replaces the value parts of all key-value pairs with the values from the dictionary. NO escaping is done whatsoever, this has to be done previously.
 */
+ (NSString *)scanAndUpdateString:(NSString *)string withReplacementDictionary:(NSDictionary *)strings;

/*!
 @abstract Post-processes previously scanned strings.
 @discussion This will apply the standard replacements and unicode replacements to both keys and values. It is expected (and not checked) that the mutability is given.
 */
+ (void)processStrings:(NSMutableDictionary *)strings;

/*!
 @abstract Post-processes previously scanned comments.
 @discussion This will apply the standard replacements and unicode replacements to both keys and values. In addition, the values will be trimmed and formatted as appropriate. It is expected (and not checked) that the mutability is given.
 */
+ (void)processComments:(NSMutableDictionary *)comments;

/*!
 @abstract Post-processes a previously scanned key order.
 @discussion This will apply the standard replacements and unicode replacements to all objects. It is expected (and not checked) that the mutability is given.
 */
+ (void)processKeyOrder:(NSMutableArray *)keys;

@end

/*!
 @abstract Extensions to NSScanner used by BLStringsScanner.
 */
@interface NSScanner (BLStringsScanner)

/*!
 @abstract Computes the scanner's position in terms of lines.
 */
- (NSUInteger)currentLine;

/*!
 @abstract Computes the scanner's offset from the beginning of the current line.
 */
- (NSUInteger)currentOffsetInLine;

@end

