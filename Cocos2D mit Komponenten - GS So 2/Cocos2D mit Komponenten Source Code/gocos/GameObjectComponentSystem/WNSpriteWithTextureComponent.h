//
//  WNSpriteWithTextureComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNSpriteWithTextureComponent describe me! */
@interface WNSpriteWithTextureComponent : WNNodeComponent
{
	@private
	CCTexture2D* texture_;
	CGRect textureRect_;
}

@property (nonatomic, retain) CCTexture2D* texture;
@property (nonatomic) CGRect textureRect;


@end
