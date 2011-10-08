//
//  WNSpriteBatchNodeWithTextureComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNSpriteBatchNodeWithTextureComponent describe me! */
@interface WNSpriteBatchNodeWithTextureComponent : WNNodeComponent
{
	@private
	CCTexture2D* texture_;
	NSUInteger capacity_;
}

@property (nonatomic, retain) CCTexture2D* texture;
@property (nonatomic) NSUInteger capacity;

@end
