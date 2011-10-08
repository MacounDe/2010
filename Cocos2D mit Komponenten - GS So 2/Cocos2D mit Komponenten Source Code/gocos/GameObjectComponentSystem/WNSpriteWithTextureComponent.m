//
//  WNSpriteWithTextureComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteWithTextureComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNSpriteWithTextureComponent (PrivateMethods)
@end

@implementation WNSpriteWithTextureComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[texture_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize texture=texture_;
@synthesize textureRect=textureRect_;


#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(texture_ != nil, @"texture is nil - you must set this property before creating the entity!");
	if (CGRectIsEmpty(textureRect_))
	{
		node_ = [CCSprite spriteWithTexture:texture_];
	}
	else
	{
		node_ = [CCSprite spriteWithTexture:texture_ rect:textureRect_];
	}

	[self addNodeAsChild];
	
	[texture_ release];
	texture_ = nil;
}

@end
