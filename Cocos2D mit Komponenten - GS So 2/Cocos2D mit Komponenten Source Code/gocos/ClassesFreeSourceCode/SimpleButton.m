//
//  SimpleButton.m
//
//  Created by Steffen Itterheim on 27.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

// this class wraps a Menu with just one item to make creating simple buttons easier

#import "SimpleButton.h"

#import "TextureAtlasManager.h"

// menuitem selected images have this filename suffix (change as needed)
const NSString* kSelectedImageSuffix = @"_aktiv";

@interface SimpleButton (Private)
@end

@implementation SimpleButton

@synthesize menu;

+(id) simpleButtonAtPosition:(CGPoint)position image:(NSString*)image target:(id)target selector:(SEL)selector
{
	NSAssert(target != nil, @"SimpleButton - target is nil!");
	return [[[self alloc] initWithPosition:position image:image target:target selector:selector] autorelease];
}

-(id) initWithPosition:(CGPoint)position image:(NSString*)image target:(id)target selector:(SEL)selector
{
	if ((self = [super init]))
	{
		CCSprite* normalSprite = nil;
		CCSprite* selectedSprite = nil;
		CCMenuItemSprite* item = nil;
		
		NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
		NSString* selectedImage = [NSString stringWithFormat:@"%@%@.png", image, kSelectedImageSuffix];
		
		if ([[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:normalImage] == nil)
		{
			normalSprite = [CCSprite spriteWithFile:normalImage];
			selectedSprite = [CCSprite spriteWithFile:selectedImage];
			item = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:selector];
		}
		else
		{
			normalSprite = [[TextureAtlasManager singleton] getSpriteByName:normalImage];
			selectedSprite = [[TextureAtlasManager singleton] getSpriteByName:selectedImage];
			item = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:selector];
		}

		int dummyList[2] = {0, 0};
		menu = [[CCMenu alloc] initWithItems:(CCMenuItem*)item vaList:(va_list)dummyList];
		menu.position = position;
		[self addChild:menu];
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	[menu release];
	[super dealloc];
}

-(void) setIsEnabled:(bool)enabled
{
	menu.isTouchEnabled = enabled;

	for (CCMenuItem* item in [menu children])
	{
		[item setIsEnabled:enabled];
	}
}

+(void) setIsEnabledForAllButtons:(CCArray*)children enabled:(bool)enabled
{
	CCNode* node;
	CCARRAY_FOREACH(children, node)
	{
		if ([node isKindOfClass:[SimpleButton class]])
		{
			[((SimpleButton*)node) setIsEnabled:enabled];
		}
		else
		{
			[SimpleButton setIsEnabledForAllButtons:[node children] enabled:enabled];
		}
	}
}

-(void) setColor:(ccColor3B)color
{
	color_ = color;
	menu.color = color;
}

-(ccColor3B) color
{
	return color_;
}

-(GLubyte) opacity
{
	return opacity_;
}

-(void) setOpacity:(GLubyte)opacity
{
	opacity_ = opacity;
	menu.opacity = opacity;
}

@end
