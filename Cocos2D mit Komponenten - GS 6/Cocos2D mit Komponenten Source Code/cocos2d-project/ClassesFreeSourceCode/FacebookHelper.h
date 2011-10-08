//
//  FacebookHelper.h
//
//  Created by Steffen Itterheim on 20.03.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"
/*
#import "FBConnect/FBConnect.h"
#import "FacebookHelperDelegateProtocol.h"

typedef enum
{
	MAX_Permissions = 1,
}EPermissions;

typedef enum
{
	LoginDialogTag = 1,
	PermissionDialogTag,
} EDialogTags;

// Note: i define the API key in a seperate header file to always keep the API key seperate from the code i upload and share.
// It would be terrible if i were to share my key with the world, so this code does not run out of the box, but all you need to do is
// to remove the import "FacebookAPIKey.h" line, then uncomment the lines below it, then replace the string contents with your API key
// and your Application secret respectively:

// remove this line and uncomment the next two:
#import "FacebookAPIKey.h"
//static NSString* const FacebookAPIKey = @"replace the contents of this string with your API key";
//static NSString* const FacebookApplicationSecret = @"replace the contents of this string with your Application secret";


@interface FacebookHelper : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
	id<FacebookHelperDelegate> delegate;
	FBSession* session;
	FBUID userID;
	NSString* userIDString;
	
	NSMutableDictionary* permissions;
	
	NSData* photo;
	bool isWaitingForLoginToPublishPhoto;
	bool isWaitingForPermissionToPublishPhoto;
}

@property (readonly) FBSession* session;

+(FacebookHelper*) singleton;
+(id) alloc;

// avoids common error made when adding media dictionary
+(void) addMediaDictionary:(NSDictionary*)media toAttachmentDictionary:(NSMutableDictionary*)dict;

-(void) showLoginDialog;
-(void) logout;
-(void) showExtendedPermissionDialog:(NSString*)permission;
-(void) publishStory:(NSString*)prompt attachmentDictionary:(NSDictionary*)dict;
-(void) publishPhoto:(NSData*)image;
-(void) publishScreenshotAsPhoto;

@end
*/