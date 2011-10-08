//
//  WNDrawAtOpposingBorderComponent.h
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"

/** draws a Sprite entity at opposing sides of the given boundary rect (usually the screen) */
@interface WNDrawAtOpposingBorderComponent : WNComponent
{
	@private
	CGSize screenSize_;
	CGPoint boundaryCenter_;
	CGRect boundary_;
	ccArray* spriteDoubles_;
	bool spriteDoublesVisible;
}

@property (nonatomic) CGRect boundary;

@end
