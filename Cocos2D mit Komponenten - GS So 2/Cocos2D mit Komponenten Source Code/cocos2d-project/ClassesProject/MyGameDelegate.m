//
//  MyGameDelegate.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 08.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "MyGameDelegate.h"

#import "WNScene.h"
#import "WNSceneManager.h"

#import "ShootComponent.h"

#import <objc/runtime.h>

@implementation MyGameDelegate

+(id) gameDelegate
{
	return [[[self alloc] init] autorelease];
}

-(void) onBeforeWindowAttachedToDirectorView
{
	[[CCDirector sharedDirector] setDisplayFPS:NO];
}

-(void) demo1
{
	WNScene* scene = [WNScene node];
	
	CCColorLayer* colorLayer = [CCColorLayer layerWithColor:ccc4(120, 120, 120, 255)];
	[scene addChild:colorLayer z:-10];
	
	
	
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:scene];
	spriteComponent.file = @"alien.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 100;
	
	WNEntity* entity = [scene.entityPool createEntityWithComponents:spriteComponent, move, nil];
	entity.tag = kPlayerEntity;
	entity.position = CGPointMake(32, 32);

	
	
	[[WNSceneManager sharedManager] switchToScene:scene];
}

-(void) demo2
{
	WNScene* scene = [WNScene node];
	
	CCColorLayer* colorLayer = [CCColorLayer layerWithColor:ccc4(120, 120, 120, 255)];
	[scene addChild:colorLayer z:-10];
	
	
	
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:scene];
	spriteComponent.file = @"alien.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 100;
	
	// NEW:
	WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent component];
	wrap.boundary = CGRectMake(0, 0, 480, 320);
	
	// NEW:
	WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent component];
	
	WNEntity* entity = [scene.entityPool createEntityWithComponents:spriteComponent, move, wrap, drawDouble, nil];
	entity.tag = kPlayerEntity;
	entity.position = CGPointMake(32, 32);
	

	
	[[WNSceneManager sharedManager] switchToScene:scene];
}

-(void) demo3
{
	WNScene* scene = [WNScene node];
	
	CCColorLayer* colorLayer = [CCColorLayer layerWithColor:ccc4(120, 120, 120, 255)];
	[scene addChild:colorLayer z:-10];
	
	
	
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:scene];
	spriteComponent.file = @"alien.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 100;
	
	WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent component];
	wrap.boundary = CGRectMake(0, 0, 480, 320);
	
	WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent component];
	
	// NEW:
	ShootComponent* shoot = [ShootComponent component];
	shoot.shootDelay = 2.2f;
	
	WNEntity* entity = [scene.entityPool createEntityWithComponents:spriteComponent, move, wrap, drawDouble, shoot, nil];
	entity.tag = kPlayerEntity;
	entity.position = CGPointMake(32, 32);
	
	
	
	[[WNSceneManager sharedManager] switchToScene:scene];
}


-(void) onButton:(NSNotification*)notification
{
	WNScene* currentScene = [WNSceneManager sharedManager].currentScene;
	if (currentScene.isPaused)
	{
		[[WNSceneManager sharedManager].currentScene onResumeGame];
	}
	else
	{
		[[WNSceneManager sharedManager].currentScene onPauseGame];
	}
}

-(void) demo4
{
	WNScene* scene = [WNScene node];
	
	CCColorLayer* colorLayer = [CCColorLayer layerWithColor:ccc4(120, 120, 120, 255)];
	[scene addChild:colorLayer z:-10];
	
	
	
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:scene];
	spriteComponent.file = @"alien.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 100;
	
	WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent component];
	wrap.boundary = CGRectMake(0, 0, 480, 320);
	
	WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent component];
	
	ShootComponent* shoot = [ShootComponent component];
	shoot.shootDelay = 2.5f;
	
	WNEntity* entity = [scene.entityPool createEntityWithComponents:spriteComponent, move, wrap, drawDouble, shoot, nil];
	entity.tag = kPlayerEntity;
	entity.position = CGPointMake(32, 32);
	
	
	
	// NEW: Add a pause/resume button
	WNButtonWithSpritesComponent* buttonComponent = [WNButtonWithSpritesComponent componentWithParentNode:scene];
	buttonComponent.normalSprite = [CCSprite spriteWithFile:@"Icon.png"];
	buttonComponent.selectedSprite = [CCSprite spriteWithFile:@"alien.png"];
	buttonComponent.buttonName = @"MyButton";
	WNEntity* buttonEntity = [scene.entityPool createEntityWithComponents:buttonComponent, nil];
	buttonEntity.position = CGPointMake(240, 260);
	
	// reveice button messages
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onButton:) name:@"MyButtonActivated" object:nil];
	
	
	[[WNSceneManager sharedManager] switchToScene:scene];
}

-(void) onReadyToRunFirstScene
{
	//[self demo1];
	//[self demo2];
	//[self demo3];
	[self demo4];
}

@end
