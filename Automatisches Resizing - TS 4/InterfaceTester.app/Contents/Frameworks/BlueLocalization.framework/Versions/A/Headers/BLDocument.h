/*!
 @header
 BLDocument.h
 Created by Max Seelemann on 07.05.10.
 
 @copyright 2010 the Localization Suite Foundation. All rights reserved.
 */

#import <BlueLocalization/BLDocumentProtocol.h>

/*!
 @abstract Abstract base class for all concrete document classes in BlueLocalization framework.
 @discussion Features a abstract dummy implementation of BLDocumentProtocol and customizes the way the documents are written to disk.
 */
@interface BLDocument : NSDocument <BLDocumentProtocol>
{
}

@end
