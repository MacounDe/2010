//
//  WNSpriteWithBatchNodeComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteWithBatchNodeComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNSpriteWithBatchNodeComponent (PrivateMethods)
@end

@implementation WNSpriteWithBatchNodeComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[spriteBatchNode_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize spriteBatchNode=spriteBatchNode_;
@synthesize textureRect=textureRect_;


#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(spriteBatchNode_ != nil, @"spriteBatchNode is nil - you must set this property before creating the entity!");
	NSAssert(CGRectIsEmpty(textureRect_) == NO, @"textureRect is empty!");
	node_ = [CCSprite spriteWithBatchNode:spriteBatchNode_ rect:textureRect_];
	
	[self addNodeAsChild];
	
	[spriteBatchNode_ release];
	spriteBatchNode_ = nil;
}

@end
