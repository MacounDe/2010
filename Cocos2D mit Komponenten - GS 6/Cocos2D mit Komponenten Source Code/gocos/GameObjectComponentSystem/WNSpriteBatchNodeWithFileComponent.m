//
//  WNSpriteBatchNodeWithFileComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSpriteBatchNodeWithFileComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNSpriteBatchNodeWithFileComponent (PrivateMethods)
@end

@implementation WNSpriteBatchNodeWithFileComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[file_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize file=file_;
@synthesize capacity=capacity_;

#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(file_ != nil, @"file is nil - you must set this property before creating the entity!");
	if (capacity_ == 0)
	{
		node_ = [CCSpriteBatchNode batchNodeWithFile:file_];
	}
	else
	{
		node_ = [CCSpriteBatchNode batchNodeWithFile:file_ capacity:capacity_];
	}
	
	[self addNodeAsChild];
	
	[file_ release];
	file_ = nil;
}

@end
