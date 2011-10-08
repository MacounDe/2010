//
//  FacebookHelper.m
//
//  Created by Steffen Itterheim on 20.03.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "FacebookHelper.h"
/*
#import "BundleHelper.h"
#import "CJSONSerializer.h"
#import "FacebookHelperDelegateProtocol.h"
#import "Screenshot.h"


@interface FacebookHelper (Private)
-(void) loadPermissions;
-(void) savePermissions;
@end

@implementation FacebookHelper

static FacebookHelper *instanceOfFacebookHelper;
static NSString* const PermissionsSaveFile = @"";

@synthesize session;

		
-(FacebookHelper*) init
{
	if ((self = [super init]))
	{
		session = [[FBSession sessionForApplication:FacebookAPIKey secret:FacebookApplicationSecret delegate:self] retain];

		[self loadPermissions];
		
		isWaitingForLoginToPublishPhoto = NO;
	}
	
	return self;
}

-(void) dealloc
{
	[photo release];
	[permissions release];
	
	[session.delegates removeObject:self];
	[session release];
	session = nil;
	
	[instanceOfFacebookHelper release];
	instanceOfFacebookHelper = nil;
	
	[super dealloc];
}

-(void) loadPermissions
{
	permissions = [[NSMutableDictionary alloc] initWithContentsOfFile:[BundleHelper getDocumentsPathToFile:PermissionsSaveFile]];
	if (permissions == nil)
	{
		permissions = [[NSMutableDictionary alloc] initWithCapacity:MAX_Permissions];
		[permissions setValue:[NSNumber numberWithBool:NO] forKey:@"publish_stream"];
		[self savePermissions];
	}
}

-(void) savePermissions
{
	[permissions writeToFile:[BundleHelper getDocumentsPathToFile:PermissionsSaveFile] atomically:YES];
}

-(void) showLoginDialog
{
	FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:session] autorelease];
	dialog.tag = LoginDialogTag;
	dialog.delegate = self;
	[dialog show];
}

-(void) logout
{
	[session logout];
	[permissions setValue:[NSNumber numberWithBool:NO] forKey:@"publish_stream"];
	[self savePermissions];
}

-(void) showExtendedPermissionDialog:(NSString*)permission
{
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.tag = PermissionDialogTag;
	dialog.delegate = self;
	dialog.permission = permission;
	[dialog show];
}

// TODO:
// Another strategy for dealing with extended permissions is to have your application assume that the user has already granted the permission 
// that it needs when making API calls. If your application does not have the permission, catch the error, spawn the FBPermissionDialog, and then try again.



+(void) addMediaDictionary:(NSDictionary*)media toAttachmentDictionary:(NSMutableDictionary*)dict
{
	NSArray* mediaArray = [NSArray arrayWithObject:media];
	[dict setObject:mediaArray forKey:@"media"];
}

// see this link for a description of the keys and values of the dictionary
// http://wiki.developers.facebook.com/index.php/Attachment_(Streams)
// code sample:
// NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:2];
// [dict setObject:@"51 Jap. Characters" forKey:@"name"];
// [dict setObject:@"http://itunes.apple.com/de/app/51-japanese-characters/id348610113?mt=8" forKey:@"href"];
// [self publishStory:@"Publish this to Facebook?" attachmentDictionary:dict];


 test:
 NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
 [dict setObject:@"51 Japanese Characters App" forKey:@"name"];
 [dict setObject:@"http://itunes.apple.com/de/app/51-japanese-characters/id348610113?mt=8" forKey:@"href"];
 [dict setObject:@"caption, oh caption" forKey:@"caption"];
 [dict setObject:@"here comes a great character blablabla" forKey:@"description"];
 
 NSMutableDictionary* media = [NSMutableDictionary dictionaryWithCapacity:10];
 [media setObject:@"image" forKey:@"type"];
 [media setObject:@"http://www.steffenitterheim.de/wordpress/wp-content/uploads/2010/01/51characters_iTunes_screenshot05.png" forKey:@"src"];
 [media setObject:@"http://itunes.apple.com/de/app/51-japanese-characters/id348610113?mt=8" forKey:@"href"];
 
 [FacebookHelper addMediaDictionary:media toAttachmentDictionary:dict];
 
 [self publishStory:@"prompto" attachmentDictionary:dict];

-(void) publishStory:(NSString*)prompt attachmentDictionary:(NSDictionary*)dict
{
	if ([session resume])
	{
		FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.userMessagePrompt = prompt;
		dialog.attachment = [[CJSONSerializer serializer] serializeObject:dict];
		dialog.targetId = userIDString;
		[dialog show];
	}
}

-(void) publishPhoto:(NSData*)image
{
	photo = [image retain];
	
	if (![session isConnected] && ![session resume])
	{
		isWaitingForLoginToPublishPhoto = YES;
		[self showLoginDialog];
	}
	else
	{
		[[FBRequest requestWithDelegate:self] call:@"facebook.photos.upload" params:nil dataParam:(NSData*)photo];
		
		[photo release];
		photo = nil;
	}
}

-(void) publishScreenshotAsPhoto
{
	[self publishPhoto:[Screenshot takeAsPNG]];
}


// FBSessionDelegate
// Called when a user has successfully logged in and begun a session.
-(void) session:(FBSession*)session didLogin:(FBUID)uid
{
	userID = uid;
	userIDString = [NSString stringWithFormat:@"%lld", userID];
	CCLOG(@"FacebookHelper: user logged in: %lld", userIDString);

	NSNumber* publishStreamPermission = [permissions objectForKey:@"publish_stream"];
	if ([publishStreamPermission boolValue] == NO)
	{
		[self showExtendedPermissionDialog:@"publish_stream"];
	}
	else if (isWaitingForLoginToPublishPhoto)
	{
		isWaitingForLoginToPublishPhoto = NO;
		[self publishPhoto:photo];
	}
}

// Called when a user closes the login dialog without logging in.
-(void) sessionDidNotLogin:(FBSession*)session
{
	CCLOG(@"FacebookHelper: sessionDidNotLogin");
}

// Called when a session is about to log out.
-(void) session:(FBSession*)session willLogout:(FBUID)uid
{
	CCLOG(@"FacebookHelper: willLogout");
}

// Called when a session has logged out.
-(void) sessionDidLogout:(FBSession*)session
{
	CCLOG(@"FacebookHelper: sessionDidLogout");
}


// FBRequestDelegate
// Called just before the request is sent to the server.
-(void) requestLoading:(FBRequest*)request
{
	CCLOG(@"FacebookHelper: requestLoading");
}

// Called when the server responds and begins to send back data.
-(void) request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	CCLOG(@"FacebookHelper: didReceiveResponse");
}


// Called when an error prevents the request from completing successfully.
-(void) request:(FBRequest*)request didFailWithError:(NSError*)error
{
	CCLOG(@"FacebookHelper: didFailWithError: %@", [NSString stringWithFormat:@"Error(%d) %@", error.code, error.localizedDescription]);
}


// Called when a request returns and its response has been parsed into an object.
// The resulting object may be a dictionary, an array, a string, or a number, depending
// on thee format of the API response.
-(void) request:(FBRequest*)request didLoad:(id)result
{
	CCLOG(@"FacebookHelper: didLoad");
	NSDictionary* dict = (NSDictionary*)result;
	dict = nil;
}


// Called when the request was cancelled.
-(void) requestWasCancelled:(FBRequest*)request
{
	CCLOG(@"FacebookHelper: requestWasCancelled");
}


// dialog callbacks
-(void) dialogDidSucceed:(FBDialog*)dialog
{
	CCLOG(@"FacebookHelper: dialogDidSucceed - %@", dialog.title);

	if ([dialog isKindOfClass:[FBStreamDialog class]])
	{
	}
	else if ([dialog isKindOfClass:[FBPermissionDialog class]])
	{
		FBPermissionDialog* dlg = (FBPermissionDialog*)dialog;
		[permissions setValue:[NSNumber numberWithBool:YES] forKey:dlg.permission];
		[self savePermissions];

		if (isWaitingForLoginToPublishPhoto)
		{
			isWaitingForLoginToPublishPhoto = NO;
			[self publishPhoto:photo];
		}
	}
	else if ([dialog isKindOfClass:[FBLoginDialog class]])
	{
	}
}

-(void) dialogDidCancel:(FBDialog*)dialog
{
	CCLOG(@"FacebookHelper: dialogDidCancel - %@", dialog.title);
	
	if ([dialog isKindOfClass:[FBStreamDialog class]])
	{
	}
	else if ([dialog isKindOfClass:[FBPermissionDialog class]])
	{
		FBPermissionDialog* dlg = (FBPermissionDialog*)dialog;
		[permissions setValue:[NSNumber numberWithBool:NO] forKey:dlg.permission];
		[self savePermissions];
		
		if (isWaitingForLoginToPublishPhoto)
		{
			isWaitingForLoginToPublishPhoto = NO;
			[photo release];
			photo = nil;
		}
	}
	else if ([dialog isKindOfClass:[FBLoginDialog class]])
	{
	}
}


// Singleton stuff
+(FacebookHelper*) singleton
{
	@synchronized(self)
	{
		if (instanceOfFacebookHelper == nil)
		{
			[[FacebookHelper alloc] init];
		}
		
		return instanceOfFacebookHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfFacebookHelper == nil, @"Attempted to allocate a second instance of the singleton: FacebookHelper");
		instanceOfFacebookHelper = [[super alloc] retain];
		return instanceOfFacebookHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

@end
*/