//
//  MyGameDelegate.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "MyGameDelegate.h"

#import "WNScene.h"
#import "WNSceneManager.h"

@implementation MyGameDelegate

+(id) gameDelegate
{
	return [[[self alloc] init] autorelease];
}

-(void) onBeforeWindowAttachedToDirectorView
{
	
}

-(void) onReadyToRunFirstScene
{
	WNScene* scene = [WNScene node];
	
	/*
	// register new entity template with name (in WNEntityTemplates)
	// create components and add to template until done
	// q: how would this work with components using proper constructor syntax instead of properties?
	WNSpriteComponent* comp = [WNSpriteComponent componentWithEntity:nil];
	comp.file = @"test";
	comp.tag = 123;
	comp.z = 22;
	WNSpriteComponent* comp2 = [comp copy];
	comp2 = nil;
	*/
	
	[[WNSceneManager sharedManager] switchToScene:[CCFadeTransition transitionWithDuration:2 scene:scene withColor:ccRED]];
}

@end
