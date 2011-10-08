//
//  WNSpriteWithSpriteFrameNameComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNSpriteWithSpriteFrameNameComponent describe me! */
@interface WNSpriteWithSpriteFrameNameComponent : WNNodeComponent
{
	@private
	NSString* spriteFrameName_;
}

@property (nonatomic, copy) NSString* spriteFrameName;

@end
