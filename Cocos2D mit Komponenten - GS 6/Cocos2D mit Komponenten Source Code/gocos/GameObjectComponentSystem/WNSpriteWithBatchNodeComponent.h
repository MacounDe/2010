//
//  WNSpriteWithBatchNodeComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNSpriteWithBatchNodeComponent describe me! */
@interface WNSpriteWithBatchNodeComponent : WNNodeComponent
{
	@private
	CCSpriteBatchNode* spriteBatchNode_;
	CGRect textureRect_;
}

@property (nonatomic, retain) CCSpriteBatchNode* spriteBatchNode;
@property (nonatomic) CGRect textureRect;

@end
