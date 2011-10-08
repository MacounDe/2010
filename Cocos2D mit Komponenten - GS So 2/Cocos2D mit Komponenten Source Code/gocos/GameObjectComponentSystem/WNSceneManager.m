//
//  WNSceneManager.m
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <objc/runtime.h>

#import "WNSceneManager.h"

#import "WNComponent.h"
#import "WNComponents.h"
#import "WNEntity.h"
#import "WNEntityPool.h"
#import "WNScene.h"
#import "WNSceneManager.h"

@interface WNSceneManager (Private)
@end

@implementation WNSceneManager

static WNSceneManager *instanceOfWNSceneManager;

@synthesize currentScene=currentScene_;

-(id) init
{
	if ((self = [super init]))
	{
		// print out statistic infos
		CCLOG(@"============== Instance Sizes ==============");
		CCLOG(@"WNComponent: %i bytes", class_getInstanceSize([WNComponent class]));
		CCLOG(@"WNNodeComponent: %i bytes", class_getInstanceSize([WNNodeComponent class]));
		CCLOG(@"WNEntity: %i bytes", class_getInstanceSize([WNEntity class]));
		CCLOG(@"WNEntityPool: %i bytes", class_getInstanceSize([WNEntityPool class]));
		CCLOG(@"WNScene: %i bytes", class_getInstanceSize([WNScene class]));
		CCLOG(@"WNSceneManager: %i bytes", class_getInstanceSize([WNSceneManager class]));
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[instanceOfWNSceneManager release];
	instanceOfWNSceneManager = nil;

	[super dealloc];
}

#pragma mark Scene switching
-(void) switchToScene:(WNScene*)newScene
{
	bool runScene = (currentScene_ == nil);
	[currentScene_ release];
	currentScene_ = [newScene retain];

	// TODO: support transitions
	if (runScene)
	{
		[[CCDirector sharedDirector] runWithScene:currentScene_];
	}
	else
	{
		[[CCDirector sharedDirector] replaceScene:currentScene_];
	}
}

-(void) switchToSceneByName:(NSString*)sceneName
{
	// TODO: Hmmm ...
}

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfWNSceneManager == nil, @"Attempted to allocate a second instance of the singleton: WNSceneManager");
		instanceOfWNSceneManager = [[super alloc] retain];
		return instanceOfWNSceneManager;
	}
	
	// to avoid compiler warning
	return nil;
}

+(WNSceneManager*) sharedManager
{
	@synchronized(self)
	{
		if (instanceOfWNSceneManager == nil)
		{
			[[WNSceneManager alloc] init];
		}
		
		return instanceOfWNSceneManager;
	}
	
	// to avoid compiler warning
	return nil;
}

@end
