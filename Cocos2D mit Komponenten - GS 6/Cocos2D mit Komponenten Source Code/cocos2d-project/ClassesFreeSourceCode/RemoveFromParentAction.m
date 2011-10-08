//
//  RemoveFromParentAction.m
//
//  Created by Steffen Itterheim on 24.02.10.
//
// code is from djdrzzy as posted on the cocos2d forum: http://www.cocos2d-iphone.org/forum/topic/981

#import "RemoveFromParentAction.h"

@implementation RemoveFromParentAction

+(id) action
{
	return [[[self alloc] init] autorelease];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[[aTarget parent] removeChild:aTarget cleanup:YES];
}

@end
