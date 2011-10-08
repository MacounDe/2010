//
//  WNDrawAtOpposingBorderComponent.m
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNDrawAtOpposingBorderComponent.h"
#import "WNComponents.h"
#import "WNEntity.h"

const int kNumOpposingSprites = 3;

@interface WNDrawAtOpposingBorderComponent (Private)
@end

@implementation WNDrawAtOpposingBorderComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	if (spriteDoubles_ != nil)
	{
		CCSprite* sprite = (CCSprite*)owner_.node;
		for (int i = 0; i < kNumOpposingSprites; i++)
		{
			[[sprite parent] removeChild:spriteDoubles_->arr[i] cleanup:YES];
		}
		ccArrayFree(spriteDoubles_);
	}

	[super dealloc];
}


#pragma mark Component-specific methods

@dynamic boundary;
-(CGRect) boundary
{
	return boundary_;
}
-(void) setBoundary:(CGRect)boundary
{
	boundary_ = boundary;
	boundaryCenter_ = CGPointMake((boundary_.size.width - boundary_.origin.x) / 2,
								  (boundary_.size.height - boundary_.origin.y) / 2);
}

-(void) updateSpriteDoublesProperties
{
	CCSprite* sprite = (CCSprite*)owner_.node;

	for (int i = 0; i < kNumOpposingSprites; i++)
	{
		CCSprite* spriteDouble = spriteDoubles_->arr[i];
		spriteDouble.rotation = sprite.rotation;
		spriteDouble.scale = sprite.scale;
		spriteDouble.flipX = sprite.flipX;
		spriteDouble.flipY = sprite.flipY;

		CGPoint pos = owner_.position;
		CGPoint oppositePosition = pos;

		if (i == 0 || i == 1)
		{
			if (pos.x > boundaryCenter_.x)
			{
				oppositePosition.x = pos.x - (boundary_.size.width - boundary_.origin.x);
			}
			else
			{
				oppositePosition.x = pos.x + (boundary_.size.width - boundary_.origin.x);
			}
		}
		if (i == 0 || i == 2)
		{
			if (pos.y > boundaryCenter_.y)
			{
				oppositePosition.y = pos.y - (boundary_.size.height - boundary_.origin.y);
			}
			else
			{
				oppositePosition.y = pos.y + (boundary_.size.height - boundary_.origin.y);
			}
		}
		
		spriteDouble.position = oppositePosition;
	}
}

-(void) spriteDoublesSetVisible:(bool)vis
{
	for (int i = 0; i < kNumOpposingSprites; i++)
	{
		CCSprite* sprite = spriteDoubles_->arr[i];
		sprite.visible = vis;
	}
}

#pragma mark required Component method overrides
-(void) onInitialize
{
	//[self willReceiveMessages:YES];
	
	NSAssert([owner_.node isKindOfClass:[CCSprite class]], @"this component currently only works for Sprite entities!");
	
	spriteDoubles_ = ccArrayNew(kNumOpposingSprites);

	// at the moment requires that node is a CCSprite and texture rect never changes (no animation)
	for (int i = 0; i < kNumOpposingSprites; i++)
	{
		CCSprite* sprite = (CCSprite*)owner_.node;
		CCSprite* spriteDouble = [CCSprite spriteWithTexture:[sprite texture]];

		spriteDouble.position = sprite.position;
		spriteDouble.visible = NO;
		
		CCNode* parent = [sprite parent];
		NSAssert(parent != nil, @"parent is nil - node hasn't been added as child to a parent node yet!");
		[parent addChild:spriteDouble z:sprite.zOrder];
		ccArrayAppendObjectWithResize(spriteDoubles_, spriteDouble);
	}

	[self updateSpriteDoublesProperties];

	// by default boundary is the screen area
	screenSize_ = [[CCDirector sharedDirector] winSize];
	self.boundary = CGRectMake(0, 0, screenSize_.width, screenSize_.height);
}

-(void) onUpdate:(ccTime)delta
{
	CGRect entityBBox = [owner_.node boundingBox];
	if (CGRectContainsRect(boundary_, entityBBox))
	{
		if (spriteDoublesVisible)
		{
			spriteDoublesVisible = NO;
			[self spriteDoublesSetVisible:NO];
		}
	}
	else
	{
		if (spriteDoublesVisible == NO)
		{
			spriteDoublesVisible = YES;
			[self spriteDoublesSetVisible:YES];
		}

		[self updateSpriteDoublesProperties];
	}
}

@end
