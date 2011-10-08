//
//  RemoveSelfComponent.m
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "RemoveSelfComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"
#import "WNEntityPool.h"
#import "WNScene.h"
#import "WNSceneManager.h"

@interface RemoveSelfComponent (PrivateMethods)
@end

@implementation RemoveSelfComponent

@synthesize timeToLive;

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
	totalDeltaTime += delta;
	if (totalDeltaTime > timeToLive)
	{
		[[WNSceneManager sharedManager].currentScene.entityPool removeEntity:owner_];
	}
}

@end
