//
//  MyGameDelegate.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 08.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNFoundation.h"

typedef enum
{
	kPlayerEntity = 1,
} EntityTags;

@interface MyGameDelegate : NSObject <WNGameDelegate>
{
	
}

/** returns an autoreleased instance of this class */
+(id) gameDelegate;

@end