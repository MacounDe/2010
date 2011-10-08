//
//  WNSpriteBatchNodeWithTextureComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteBatchNodeWithTextureComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNSpriteBatchNodeWithTextureComponent (PrivateMethods)
@end

@implementation WNSpriteBatchNodeWithTextureComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[texture_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize texture=texture_;
@synthesize capacity=capacity_;

#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(texture_ != nil, @"texture is nil - you must set this property before creating the entity!");
	if (capacity_ == 0)
	{
		node_ = [CCSpriteBatchNode batchNodeWithTexture:texture_];
	}
	else
	{
		node_ = [CCSpriteBatchNode batchNodeWithTexture:texture_ capacity:capacity_];
	}
	
	[self addNodeAsChild];
	
	[texture_ release];
	texture_ = nil;
}

@end
