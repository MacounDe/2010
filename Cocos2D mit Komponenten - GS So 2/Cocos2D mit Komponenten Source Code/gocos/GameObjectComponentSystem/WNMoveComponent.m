//
//  WNMoveComponent.m
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNMoveComponent.h"
#import "WNComponents.h"
#import "WNEntity.h"

@interface WNMoveComponent (Private)
-(void) calculateVelocityFromDirectionAndSpeed;
@end

@implementation WNMoveComponent

#pragma mark Component-specific methods

@synthesize velocity=velocity_;
@dynamic direction, speed;

-(float) direction
{
	return direction_;
}
-(void) setDirection:(float)newDirection
{
	direction_ = newDirection;
	[self calculateVelocityFromDirectionAndSpeed];
}

-(float) speed
{
	return speed_;
}
-(void) setSpeed:(float)newSpeed
{
	speed_ = newSpeed;
	[self calculateVelocityFromDirectionAndSpeed];
}

-(void) calculateVelocityFromDirectionAndSpeed
{
	float radianDir = CC_DEGREES_TO_RADIANS(direction_);
	CGPoint v = CGPointMake(cosf(radianDir) * speed_, sinf(radianDir) * speed_);
	velocity_ = v;
}

-(void) stop
{
	velocity_ = CGPointZero;
}

#pragma mark required Component method overrides
-(void) onInitialize
{
}

-(void) onUpdate:(ccTime)delta
{
	owner_.position = CGPointMake(owner_.position.x + (velocity_.x * delta), owner_.position.y + (velocity_.y * delta));
}

@end
