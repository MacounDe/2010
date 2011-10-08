//
//  WNMoveComponent.h
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** Moves an object based on a direction vector but allows user to change or read direction and speed via seperate properties.
 Note that it is more efficient to change the velocity property directly, since changing direction and speed will update both
 using a calculation that involves several multiplications and divisions and cosf/sinf. But for convenience this is sufficiently fast
 unless you intend to update speed and direction of several dozens of objects every frame. */
@interface WNMoveComponent : WNComponent
{
	@private
	CGPoint velocity_;
	
	float direction_, speed_;
}

@property (nonatomic) CGPoint velocity;

@property (nonatomic) float direction;
@property (nonatomic) float speed;

-(void) stop;

@end
