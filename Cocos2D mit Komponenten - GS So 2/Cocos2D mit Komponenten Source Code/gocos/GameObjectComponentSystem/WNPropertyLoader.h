//
//  WNPropertyLoader.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WNPropertyLoader : NSObject
{
	@private
	id parent_;
	id propertyObject_;
}

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent propertyObject:(id)propertyObject;

@end
