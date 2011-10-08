//
//  WNLayerComponent.m
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNLayerComponent.h"

#import "WNComponents.h"
#import "WNEntity.h"

@interface WNLayerComponent (PrivateMethods)
@end

@implementation WNLayerComponent

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[super dealloc];
}


#pragma mark Component-specific methods

@synthesize layerColor=layerColor_;

#pragma mark required Component method overrides
-(void) onInitialize
{
	if (layerColor_.r == 0 && layerColor_.g == 0 && layerColor_.b == 0 && layerColor_.a == 0)
	{
		node_ = [CCLayer node];
	}
	else
	{
		node_ = [CCColorLayer layerWithColor:layerColor_];
	}

	
	[self addNodeAsChild];
}

@end
