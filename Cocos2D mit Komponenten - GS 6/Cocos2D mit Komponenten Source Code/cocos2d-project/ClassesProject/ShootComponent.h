//
//  ShootComponent.h
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** TODO: ShootComponent describe me! */
@interface ShootComponent : WNComponent
{
	@private
	ccTime shootDelay;
	ccTime totalDeltaTime;
}

@property (nonatomic) ccTime shootDelay;

@end
