//
//  WNComponentLoader.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WNComponent;
@class WNEntity;

@interface WNComponentLoader : NSObject
{
	@private
	id parent_;
	CCNode* baseNode_;
	WNEntity* owner_;
	WNComponent* currentComponent_; // weak ref
}

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode owner:(WNEntity*)owner;

@end
