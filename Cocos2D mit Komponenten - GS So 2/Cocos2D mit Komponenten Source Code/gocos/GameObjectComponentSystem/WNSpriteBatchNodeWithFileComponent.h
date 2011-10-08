//
//  WNSpriteBatchNodeWithFileComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNSpriteBatchNodeWithFileComponent describe me! */
@interface WNSpriteBatchNodeWithFileComponent : WNNodeComponent
{
	@private
	NSString* file_;
	NSUInteger capacity_;
}

@property (nonatomic, copy) NSString* file;
@property (nonatomic) NSUInteger capacity;

@end
