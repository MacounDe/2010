//
//  WNSpriteComponent.h
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

@class CCSprite;

/** encapsulates a cocos2d CCSprite class object */
@interface WNSpriteComponent : WNNodeComponent
{
	@private
	NSString* file_;
}

@property (nonatomic, readonly) CCSprite* sprite;
@property (nonatomic, copy) NSString* file;

@end
