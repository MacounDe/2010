//
//  FacebookButton.m
//
//  Created by Steffen Itterheim on 21.03.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "FacebookButton.h"


@interface FacebookButton (Private)
@end

@implementation FacebookButton

+(id) facebookButtonWithTarget:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithTarget:target selector:selector] autorelease];
}

-(id) initWithTarget:(id)target selector:(SEL)selector
{
	if ((self = [super initWithPosition:CGPointMake(320 - 23, 480 - 23) image:@"facebook_button" target:target selector:selector]))
	{
	}
	
	return self;
}

@end
