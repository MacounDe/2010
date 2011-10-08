//
//  FacebookPublishPhotoHelper.m
//
//  Created by Steffen Itterheim on 21.03.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "FacebookPublishPhotoHelper.h"
/*
#import "FacebookHelper.h"
#import "Screenshot.h"


@implementation FacebookPublishPhotoHelper

+(id) facebookPublishPhoto
{
	return [[[self alloc] init] autorelease];	
}

-(id) init
{
	if ((self = [super init]))
	{
		
	}
	
	return self;
}

-(void) dealloc
{
	[[FacebookHelper singleton].session.delegates removeObject: self];
	[super dealloc];
}

-(void) publishPhoto:(NSData*)image
{
	if (![[FacebookHelper singleton].session resume])
	{
		//[[FacebookHelper singleton] tryResumeSessionOtherwiseLogin];
	}
	
	if ([[FacebookHelper singleton].session resume])
	{
		[[FBRequest requestWithDelegate:self] call:@"facebook.photos.upload" params:nil dataParam:(NSData*)image];
	}
}

-(void) publishScreenshotAsPhoto
{
	[self publishPhoto:[Screenshot takeAsPNG]];
}


// callbacks
-(void) session:(FBSession*)fbSession didLogin:(FBUID)uid
{
	CCLOG(@"FacebookPublishPhotoHelper: user logged in");
}

-(void) dialogDidSucceed:(FBDialog*)dialog
{
	CCLOG(@"FacebookPublishPhotoHelper: dialogDidSucceed");
}

-(void) dialogDidCancel:(FBDialog*)dialog
{
	CCLOG(@"FacebookPublishPhotoHelper: dialogDidCancel");
}

// FBRequestDelegate
- (void)requestLoading:(FBRequest*)request
{
	CCLOG(@"FacebookPublishPhotoHelper: requestLoading");
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	CCLOG(@"FacebookPublishPhotoHelper: didReceiveResponse");
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	CCLOG(@"FacebookPublishPhotoHelper: didFailWithError: %@", [NSString stringWithFormat:@"Error(%d) %@", error.code, error.localizedDescription]);
}


- (void)request:(FBRequest*)request didLoad:(id)result
{
	CCLOG(@"FacebookPublishPhotoHelper: didLoad");
}


- (void)requestWasCancelled:(FBRequest*)request
{
	CCLOG(@"FacebookPublishPhotoHelper: requestWasCancelled");
}


@end
*/