//
//  MyGameDelegate.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNFoundation.h"

@interface MyGameDelegate : NSObject <WNGameDelegate>
{

}

/** returns an autoreleased instance of this class */
+(id) gameDelegate;

@end
