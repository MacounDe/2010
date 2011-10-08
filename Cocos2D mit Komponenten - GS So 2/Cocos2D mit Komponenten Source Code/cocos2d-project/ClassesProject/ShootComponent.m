//
//  ShootComponent.m
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "ShootComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"
#import "WNEntityPool.h"
#import "WNScene.h"
#import "WNSceneManager.h"
#import "RemoveSelfComponent.h"
#import "MyGameDelegate.h"
#import "CollisionComponent.h"

@interface ShootComponent (PrivateMethods)
@end

@implementation ShootComponent

@synthesize shootDelay;

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[super dealloc];
}


#pragma mark Component-specific methods



#pragma mark required Component method overrides
-(void) onInitialize
{
}

-(void) demo1
{
	WNScene* currentScene = [WNSceneManager sharedManager].currentScene;
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:currentScene];
	spriteComponent.file = @"Icon.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 400;
	
	WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent component];
	wrap.boundary = CGRectMake(0, 0, 480, 320);
	
	WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent component];
	
	WNEntity* entity = [currentScene.entityPool createEntityWithComponents:spriteComponent, move, wrap, drawDouble, nil];
	entity.position = CGPointMake(owner_.node.position.x + 40, owner_.node.position.y);
	entity.scale = 0.5f;
	entity.rotation = 90;
}

-(void) demo2
{
	WNScene* currentScene = [WNSceneManager sharedManager].currentScene;
	WNSpriteWithFileComponent* spriteComponent = [WNSpriteWithFileComponent componentWithParentNode:currentScene];
	spriteComponent.file = @"Icon.png";
	
	WNMoveComponent* move = [WNMoveComponent component];
	move.speed = 400;
	
	WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent component];
	wrap.boundary = CGRectMake(0, 0, 480, 320);
	
	WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent component];
	
	RemoveSelfComponent* remove = [RemoveSelfComponent component];
	remove.timeToLive = 5.0f;
	
	CollisionComponent* collision = [CollisionComponent component];
	collision.collisionTag = kPlayerEntity;
	
	WNEntity* entity = [currentScene.entityPool createEntityWithComponents:spriteComponent, move, wrap, drawDouble, remove, collision, nil];
	entity.position = CGPointMake(owner_.node.position.x + 44, owner_.node.position.y);
	entity.scale = 0.5f;
	entity.rotation = 90;
}

-(void) onUpdate:(ccTime)delta
{
	totalDeltaTime += delta;
	if (totalDeltaTime > shootDelay)
	{
		totalDeltaTime = 0;

		//[self demo1];
		[self demo2];
	}
}

@end
