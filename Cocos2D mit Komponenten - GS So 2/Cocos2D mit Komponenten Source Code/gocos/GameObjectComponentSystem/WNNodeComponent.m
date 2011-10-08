//
//  WNNodeComponent.m
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"
#import "WNEntity.h"

@interface WNNodeComponent (Private)
@end

@implementation WNNodeComponent

-(id) initWithParentNode:(CCNode*)node
{
	if ((self = [super init]))
	{
		parentNode_ = node;
	}
	
	return self;
}

+(id) componentWithParentNode:(CCNode*)node
{
	return [[[self alloc] initWithParentNode:node] autorelease];
}

-(id) initWithParentComponent:(WNNodeComponent*)nodeComponent
{
	if ((self = [super init]))
	{
		parentNodeComponent_ = nodeComponent;
	}
	
	return self;
}

+(id) componentWithParentComponent:(WNNodeComponent*)nodeComponent
{
	return [[[self alloc] initWithParentComponent:nodeComponent] autorelease];
}

+(id) component
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"WNNodeComponent based classes must be initialized with componentWithParent method!", NSStringFromSelector(_cmd)];
	return nil;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[node_ release];
	[super dealloc];
}

#pragma mark Component-specific methods

@dynamic parentNode;
-(CCNode*) parentNode
{
	return parentNode_;
}
-(void) setParentNode:(CCNode*)node
{
	NSAssert(isInitialized_ == NO, @"component already initialied, can't change parent anymore!");
	parentNode_ = node;
}

@dynamic parentNodeComponent;
-(WNNodeComponent*) parentNodeComponent
{
	return parentNodeComponent_;
}
-(void) setParentNodeComponent:(WNNodeComponent*)nodeComponent
{
	NSAssert(isInitialized_ == NO, @"component already initialied, can't change parent anymore!");
	parentNodeComponent_ = nodeComponent;
}

@synthesize z=z_;

-(CCNode*) tryAssignParentNodeFromParentNodeComponent
{
	if (parentNodeComponent_ != nil)
	{
		NSAssert(isInitialized_ == NO, @"can't change parent node after component has been initialized!");
		parentNode_ = parentNodeComponent_.node;
	}
	
	return parentNode_;
}

-(void) addNodeAsChild
{
	[self tryAssignParentNodeFromParentNodeComponent];
	
	NSAssert(parentNode_ != nil, @"parent is nil!");
	NSAssert(node_ != nil, @"node is nil!");
	[parentNode_ addChild:node_ z:z_ tag:tag_];
}

#pragma mark CCNode Accessors

@dynamic node;
-(CCNode*) node
{
	NSAssert(isInitialized_, @"Component is not yet initialized");
	NSAssert(node_ != nil, @"node is nil - component not yet initialized?");
	return node_;
}

@dynamic sprite;
-(CCSprite*) sprite
{
	NSAssert(isInitialized_, @"Component is not yet initialized");
	NSAssert([node_ isKindOfClass:[CCSprite class]], @"node is not a CCSprite!");
	return (CCSprite*)node_;
}

@dynamic spriteBatch;
-(CCSpriteBatchNode*) spriteBatch
{
	NSAssert(isInitialized_, @"Component is not yet initialized");
	NSAssert([node_ isKindOfClass:[CCSpriteBatchNode class]], @"node is not a CCSpriteBatchNode!");
	return (CCSpriteBatchNode*)node_;
}

@dynamic layer;
-(CCLayer*) layer
{
	NSAssert(isInitialized_, @"Component is not yet initialized");
	NSAssert([node_ isKindOfClass:[CCLayer class]], @"node is not a CCLayer!");
	return (CCLayer*)node_;
}

@dynamic menu;
-(CCMenu*) menu
{
	NSAssert(isInitialized_, @"Component is not yet initialized");
	NSAssert([node_ isKindOfClass:[CCMenu class]], @"node is not a CCMenu!");
	return (CCMenu*)node_;
}

#pragma mark required Component method overrides
// not needed but must override to avoid exception
-(void) onInitialize
{
	// init the CCNode or derived class here
	// must retain the node!
	node_ = [CCNode node];
	[self addNodeAsChild];
}

@end
