//
//  WNSpriteWithFileComponent.m
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteWithFileComponent.h"
#import "WNEntity.h"

@interface WNSpriteWithFileComponent (Private)
@end

@implementation WNSpriteWithFileComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[file_ release];
	[super dealloc];
}

#pragma mark Component-specific methods

@synthesize file=file_;


#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(file_ != nil, @"file is nil - you must set this property before creating the entity!");
	node_ = [CCSprite spriteWithFile:file_];
	[self addNodeAsChild];
	
	[file_ release];
	file_ = nil;
}

@end
