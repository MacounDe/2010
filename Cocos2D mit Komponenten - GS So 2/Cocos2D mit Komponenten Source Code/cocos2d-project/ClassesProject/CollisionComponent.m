//
//  CollisionComponent.m
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "CollisionComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"
#import "MyGameDelegate.h"

@interface CollisionComponent (PrivateMethods)
@end

@implementation CollisionComponent

@synthesize collisionTag;

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

-(void) onUpdate:(ccTime)delta
{
	WNEntity* player = [[WNSceneManager sharedManager].currentScene.entityPool getEntityByTag:kPlayerEntity];
	if (player != nil)
	{
		CGRect bbox1 = [owner_.node boundingBox];
		CGRect bbox2 = [player.node boundingBox];
		if (CGRectIntersectsRect(bbox1, bbox2))
		{
			WNScene* currentScene = [WNSceneManager sharedManager].currentScene;
			
			CCParticleSystem* explo = [CCParticleExplosion node];
			explo.speed = 300;
			explo.life = 0.3f;
			explo.autoRemoveOnFinish = YES;
			explo.position = player.node.position;
			[currentScene addChild:explo];

			[currentScene.entityPool removeEntity:owner_];
		}
	}
}

@end
