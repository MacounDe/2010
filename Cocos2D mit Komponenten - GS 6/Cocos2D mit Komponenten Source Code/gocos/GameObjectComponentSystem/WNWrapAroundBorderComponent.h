//
//  WNWrapAroundBorderComponent.h
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** if the entity moves outside the boundary (by default the screen size) it will be placed at the opposite side inside
 the boundary area. In effect this will lead to a wrap-around behavior like in the classic Asteroids game. */
@interface WNWrapAroundBorderComponent : WNComponent
{
	@private
	CGRect boundary_;
}

@property (nonatomic) CGRect boundary;

@end
