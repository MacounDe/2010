//
//  WNSpriteWithFileComponent.h
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"


/** encapsulates a cocos2d CCSprite class object */
@interface WNSpriteWithFileComponent : WNNodeComponent
{
	@private
	NSString* file_;
}

@property (nonatomic, copy) NSString* file;

@end
