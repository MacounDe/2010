//
//  WNEntityLoader.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 14.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WNEntity;

@interface WNEntityLoader : NSObject 
{
	@private
	id parent_;
	CCNode* baseNode_;
	NSDictionary* attributes_;
	WNEntity* entity_; // weak ref
}

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode;

@end
