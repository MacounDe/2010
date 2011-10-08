//
//  WNScene.m
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNScene.h"

#import "WNComponent.h"
#import "WNEntityPool.h"


@interface WNScene (Private)
//-(void) loadSceneFromFile:(NSString*)file;
@end

@implementation WNScene

@synthesize entityPool=entityPool_;

-(void) initCommon
{
	entityPool_ = [[WNEntityPool pool] retain];
}

/*
+(id) sceneFromFile:(NSString*)file
{
	return [[[self alloc] init] autorelease];
}

-(id) initFromFile:(NSString*)file
{
	if ((self = [super init]))
	{
		[self initCommon];
		[self loadSceneFromFile:file];
	}
	
	return self;
}
*/

-(id) init
{
	if ((self = [super init]))
	{
		[self initCommon];
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[entityPool_ release];
	
	[super dealloc];
}

#pragma mark onEnter/onExit
-(void) onEnter
{
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	[super onExit];
}

#pragma mark LoadScene
/*
-(void) loadSceneFromFile:(NSString*)file
{
	
}
 */

#pragma mark SetPaused/SetPlaying
// this is done only to have the "Game Paused" popup dialog appear when the game is interrupted (incoming call, device turned off)
-(void) setIsPlaying:(bool)isPlaying
{
	WNAppDelegate* appDelegate = (WNAppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.isPlaying = isPlaying;
	
	// we let the AppDelegate know that we want to be called (or not)
	// when events happen which should pause the game
	if (isPlaying)
	{
		if (appDelegate.pauseDelegate != self)
		{
			[appDelegate setPauseDelegate:self];
		}
	}
	else
	{
		[appDelegate setPauseDelegate:nil];
	}
}

-(void) setIsPaused:(bool)isPaused
{
	WNAppDelegate* appDelegate = (WNAppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.isPaused = isPaused;
}

-(bool) isPlaying
{
	WNAppDelegate* appDelegate = (WNAppDelegate*)[[UIApplication sharedApplication] delegate];
	return appDelegate.isPlaying;
}

-(bool) isPaused
{
	WNAppDelegate* appDelegate = (WNAppDelegate*)[[UIApplication sharedApplication] delegate];
	return appDelegate.isPaused;
}

#pragma mark GameScene - Pause
// called by WNAppDelegate
-(void) onPauseGame
{
	[self setIsPlaying:NO];
	[self setIsPaused:YES];
	[[CCDirector sharedDirector] pause];
	
	//[ui showPauseGameDialog];
	
	// if the GameScene has a selector scheduled we might want to unschedule it during pause
	// we don't so this is just a hint in case you ever add a scheduled selector
	//[self unschedule:@selector(update:)];
}

// should only be called by the pause menu ui
-(void) onResumeGame
{
	[self setIsPlaying:YES];
	[self setIsPaused:NO];
	[[CCDirector sharedDirector] resume];
	
	// re-schedule any selectors
	//[self schedule:@selector(update:)];
}


@end
