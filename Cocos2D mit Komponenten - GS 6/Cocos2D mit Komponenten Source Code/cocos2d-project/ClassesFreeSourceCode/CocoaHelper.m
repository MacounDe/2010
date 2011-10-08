//
//  CocoaHelper.m
//
//  Created by Steffen Itterheim on 26.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "CocoaHelper.h"


static UIViewController* viewController;

@implementation CocoaHelper

+(void) showUIViewController:(UIViewController *)controller
{
	NSAssert(viewController == nil, @"CocoaHelper - a viewController is already in use!");
	if (viewController == nil)
	{
		viewController = [controller retain];
		[[[CCDirector sharedDirector] openGLView] addSubview:viewController.view];
		[[CCDirector sharedDirector] pause];

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[CCDirector sharedDirector] openGLView] cache:YES];
		[UIView commitAnimations];
	}
}

+(void) hideUIViewController
{
	NSAssert(viewController != nil, @"CocoaHelper - no viewController is in use!");
	if (viewController != nil)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0f];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[CCDirector sharedDirector] openGLView] cache:YES];
		[UIView commitAnimations];
		
		[viewController.view removeFromSuperview];
		[viewController.view.superview removeFromSuperview];
		[viewController release];
		viewController = nil;

		[[CCDirector sharedDirector] resume];
		//[[CCDirector sharedDirector] drawScene];
	}
}

@end
