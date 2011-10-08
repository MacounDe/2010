//
//  CollisionComponent.h
//
//  Created by Steffen Itterheim on 02.10.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** TODO: CollisionComponent describe me! */
@interface CollisionComponent : WNComponent
{
	@private
	int collisionTag;
}

@property (nonatomic) int collisionTag;

@end
