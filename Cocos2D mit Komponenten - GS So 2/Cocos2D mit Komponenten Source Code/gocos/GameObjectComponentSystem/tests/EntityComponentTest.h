//
//  EntityComponentTest.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "WNComponent.h"
#import "WNSpriteComponent.h"

@interface TestCase : NSObject <UIApplicationDelegate>
{
	IBOutlet UIWindow				*window;
	
	id anId;
	WNComponent* aComponent;
	WNSpriteComponent* anotherComponent;
}

@end
