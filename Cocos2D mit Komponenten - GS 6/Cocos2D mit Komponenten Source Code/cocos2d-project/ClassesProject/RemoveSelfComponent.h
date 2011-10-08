//
//  RemoveSelfComponent.h
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** TODO: RemoveSelfComponent describe me! */
@interface RemoveSelfComponent : WNComponent
{
	@private
	ccTime totalDeltaTime;
	ccTime timeToLive;
}

@property (nonatomic) ccTime timeToLive;

@end
