//
//  WNSpriteWithSpriteFrameNameComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteWithSpriteFrameNameComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNSpriteWithSpriteFrameNameComponent (PrivateMethods)
@end

@implementation WNSpriteWithSpriteFrameNameComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[spriteFrameName_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize spriteFrameName=spriteFrameName_;

#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(spriteFrameName_ != nil, @"spriteFrameName is nil - you must set this property before creating the entity!");
	node_ = [CCSprite spriteWithSpriteFrameName:spriteFrameName_];
	[self addNodeAsChild];
	
	[spriteFrameName_ release];
	spriteFrameName_ = nil;
}

@end
