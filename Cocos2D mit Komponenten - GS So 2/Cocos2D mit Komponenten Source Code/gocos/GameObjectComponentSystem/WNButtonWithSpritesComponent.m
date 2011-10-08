//
//  WNButtonWithSpritesComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNButtonWithSpritesComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNButtonWithSpritesComponent (PrivateMethods)
@end

@implementation WNButtonWithSpritesComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[normalSprite_ release];
	[selectedSprite_ release];
	[disabledSprite_ release];
	[buttonName_ release];
	[onTouchedNotificationName_ release];
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize normalSprite=normalSprite_;
@synthesize selectedSprite=selectedSprite_;
@synthesize disabledSprite=disabledSprite_;
@synthesize buttonName=buttonName_;

-(void) onButtonActivated
{
	// TODO: allow a delegate to be set ... makes more sense (one button = one receiver ... in most cases)
	WNLOG(@"button activated, sending notification: %@", onTouchedNotificationName_);
	[self sendNotificationName:onTouchedNotificationName_];
}

-(void) setMenuItemEnabled:(bool)enabled
{
	CCMenu* menu = [self menu];
	CCMenuItem* item = (CCMenuItem*)[[menu children] objectAtIndex:0];
	[item setIsEnabled:enabled];
}

-(void) setButtonEnabled:(NSNotification*)notification
{
	[self setMenuItemEnabled:YES];
}

-(void) setButtonDisabled:(NSNotification*)notification
{
	[self setMenuItemEnabled:NO];
}

#pragma mark required Component method overrides
-(void) onInitialize
{
	NSAssert(normalSprite_ != nil, @"normalSprite is nil!");
	NSAssert(selectedSprite_ != nil, @"selectedSprite is nil!");
	NSAssert(buttonName_ != nil, @"buttonName_ is nil!");

	// Register Notifications
	onTouchedNotificationName_ = [[NSString stringWithFormat:@"%@Activated", buttonName_] retain];

	NSString* setEnabled = [NSString stringWithFormat:@"%@SetEnabled", buttonName_];
	NSString* setDisabled = [NSString stringWithFormat:@"%@SetDisabled", buttonName_];
	[self registerForNotificationsByName:setEnabled sender:nil selector:@selector(setButtonEnabled:)];
	[self registerForNotificationsByName:setDisabled sender:nil selector:@selector(setButtonDisabled:)];
	
	// Create the MenuItemSprite
	CCMenuItemSprite* menuItemSprite = nil;
	SEL callback = @selector(onButtonActivated);

	if (disabledSprite_ != nil)
	{
		menuItemSprite = [CCMenuItemSprite itemFromNormalSprite:normalSprite_ selectedSprite:selectedSprite_ disabledSprite:disabledSprite_ target:self selector:callback];
	}
	else
	{
		menuItemSprite = [CCMenuItemSprite itemFromNormalSprite:normalSprite_ selectedSprite:selectedSprite_ target:self selector:callback];
	}

	// Create the Menu with just the one item
	node_ = [CCMenu menuWithItems:menuItemSprite, nil];
	[self addNodeAsChild];
	
	[normalSprite_ release];
	normalSprite_ = nil;
	[selectedSprite_ release];
	selectedSprite_ = nil;
	[disabledSprite_ release];
	disabledSprite_ = nil;
}

@end
