//
//  LayoutHelper.m
//
//  Created by Steffen Itterheim on 28.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

/*
 
 This class helps layout buttons and Sprites and can be extended to layout any CCLayer type (todo).
 It helped me to align the buttons with the layout templates i got from the artist.
 He did not provide me with the actual coordinates so i needed to find a quick and intuitive way
 to make the buttons match his template's position. The solution was to simply be able to drag
 around any button and keep moving it around until it aligns with the template.

 Simply add:
   [LayoutHelper helperWithSprite:sprite parent:self];
 with "sprite" being any sprite to be able to touch and drag it around on the current layer.
 
 TODO:
 	- extend to work with any CCLayer type, or CCNode that implements the CCTextureProtocol
 	- add a snap to grid functionality for setting up menu buttons
 	- more control over the features (blinking, opacity changes) without having to change this code
	- save coordinates as XML or plist file which can then be loaded by GUI elements
 		(assuming that in simulator we have easy access to app generated files ...)

 */

#import "LayoutHelper.h"
#import "SimpleButton.h"


@interface LayoutHelper (Private)
-(void) initSpriteWithSourceSprite:(CCSprite*)sourceSprite;
-(id) initWithSimpleButton:(SimpleButton*)simpleButton;
-(id) initWithLabel:(CCLabel*)label parent:(CCNode*)par;
-(void) updateLabelText;
-(void) blink:(id)sender;
@end

@implementation LayoutHelper

+(id) helperWithSprite:(CCSprite*)spr parent:(CCNode*)par
{
	return [[[self alloc] initWithSprite:spr parent:par] autorelease];
}

-(id) initWithSprite:(CCSprite*)spr parent:(CCNode*)par
{
	if ((self = [super init]))
	{
		parentNode = par;
		
		self.isTouchEnabled = YES;
		[self initSpriteWithSourceSprite:spr];
	}
	
	return self;
}

+(id) helperWithSimpleButton:(SimpleButton*)simpleButton
{
	return [[[self alloc] initWithSimpleButton:simpleButton] autorelease];
}

-(id) initWithSimpleButton:(SimpleButton*)simpleButton
{
	if ((self = [super init]))
	{
		parentNode = [simpleButton retain];
		
		self.isTouchEnabled = YES;
		self.position = simpleButton.menu.position;

		// find and get the menu item's texture
		CCSprite* sourceSprite = nil;
		for (CCMenuItemSprite* item in simpleButton.menu.children)
		{
			if ([item isKindOfClass:[CCMenuItemSprite class]])
			{
				item.visible = NO;
				sourceSprite = (CCSprite*)[item normalImage];
				break;
			}
		}
		
		NSAssert(sourceSprite != nil, @"source sprite not found!");

		[self initSpriteWithSourceSprite:sourceSprite];
		
		// we don't want the button to work while layouting
		[simpleButton setIsEnabled:NO];
		//button.opacity = 1;
	}
	
	return self;
}

-(void) initSpriteWithSourceSprite:(CCSprite*)sourceSprite
{
	// make a copy of the sprite at the same position which we can drag around
	sprite = [CCSprite spriteWithTexture:[sourceSprite texture]];
	sprite.anchorPoint = sourceSprite.anchorPoint;
	sprite.position = sourceSprite.position;
	[self addChild:sprite z:0];
	
	// we need to print out the current position so we can transfer this to code after layouting
	positionLabel = [CCLabel labelWithString:@"" fontName:@"Verdana" fontSize:20];
	positionLabel.color = ccMAGENTA;
	[self updateLabelText];
	[self addChild:positionLabel z:1];
	
	// make sure we are on top of the thing we're layouting
	[parentNode addChild:self z:9999];
	
	// blink the sprite to see if it matches the underlying layout (optional, comment this line if it annoys you)
	[self schedule:@selector(blink:) interval:0.5f];
}

+(id) helperWithLabel:(CCLabel*)label parent:(CCNode*)par;
{
	return [[[self alloc] initWithLabel:label parent:par] autorelease];
}

-(id) initWithLabel:(CCLabel*)label parent:(CCNode*)par;
{
	if ((self = [super init]))
	{
		parentNode = [par retain];
		
		self.isTouchEnabled = YES;
		CCSprite* spr = [CCSprite spriteWithTexture:label.texture];
		spr.position = label.position;
		spr.anchorPoint = CGPointZero;
		[self initSpriteWithSourceSprite:spr];
	}
	
	return self;
}

-(void) dealloc
{
	[parentNode release];
	[super dealloc];
}

-(void) blink:(id)sender
{
	// did you try turning it off and on again? ;)
	// helps to see any mismatch with the underlying layout image ... you may not need or want this
	// NOTE: i do not use visible property here because while the sprite is not visible it can not be touched/dragged!
	if (!isDragging)
	{
		if (sprite.opacity == 255)
		{
			sprite.opacity = 1;
		}
		else
		{
			sprite.opacity = 255;
		}
	}
}

-(void) updateLabelText
{
	[positionLabel setString:[NSString stringWithFormat:@"%.0f, %.0f", self.position.x, self.position.y]];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// we want to see what's underneath the movable sprite (change opacity as needed)
	sprite.opacity = 80;
	isDragging = YES;
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	// keep dragging me down ... err, around
	self.position = location;
	[self updateLabelText];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// back to normal ...
	sprite.opacity = 255;
	[self updateLabelText];
	isDragging = NO;
}

@end
