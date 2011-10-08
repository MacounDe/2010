//
//  WNSpriteComponent.m
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteComponent.h"
#import "WNEntity.h"

@interface WNSpriteComponent (Private)
@end

@implementation WNSpriteComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[file_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize file=file_;

@dynamic sprite;
-(CCSprite*) sprite
{
	NSAssert(isInitialized_, @"Component is not yet initialized, please don't call this accessor right away.");
	NSAssert([node_ isKindOfClass:[CCSprite class]], @"node is not a CCSprite!");
	return (CCSprite*)node_;
}

#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(file_ != nil, @"file is nil - you must set this property before adding this component!");
	node_ = [[CCSprite spriteWithFile:file_] retain];
	[self addNodeToParent];
	
	[file_ release];
	file_ = nil;
}

@end
