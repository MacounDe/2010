//
//  WNWrapAroundBorderComponent.m
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNWrapAroundBorderComponent.h"
#import "WNComponents.h"
#import "WNEntity.h"

@interface WNWrapAroundBorderComponent (Private)
@end

@implementation WNWrapAroundBorderComponent

#pragma mark Component-specific methods

@synthesize boundary=boundary_;

-(CGPoint) getOppositePosition
{
	CGPoint oppositePosition = owner_.position;
	
	float rightSide = boundary_.origin.x + boundary_.size.width;
	float upperSide = boundary_.origin.y + boundary_.size.height;
	
	if (oppositePosition.x < boundary_.origin.x)
	{
		oppositePosition.x = rightSide - (boundary_.origin.x - oppositePosition.x);
	}
	else if (oppositePosition.x > rightSide)
	{
		oppositePosition.x = boundary_.origin.x + (oppositePosition.x - rightSide);
	}
	
	if (oppositePosition.y < boundary_.origin.y)
	{
		oppositePosition.y = upperSide - (boundary_.origin.y - oppositePosition.y);
	}
	else if (oppositePosition.y > upperSide)
	{
		oppositePosition.y = boundary_.origin.y + (oppositePosition.y - upperSide);
	}
	
	return oppositePosition;
}

#pragma mark required Component method overrides

-(void) onInitialize
{
	// by default boundary is the screen area
	//CGSize screenSize = [[CCDirector sharedDirector] winSize];
	//boundary_ = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

-(void) onUpdate:(ccTime)delta
{
	if (CGRectContainsPoint(boundary_, owner_.position) == NO)
	{
		// outside, wrap it around
		CGPoint pos = [self getOppositePosition];
		[owner_ setPosition:pos];
		
		NSAssert(CGRectContainsPoint(boundary_, owner_.position),
				 @"entity still outside boundary rect after wrap - could be an interfering move action?");
	}
}

@end
