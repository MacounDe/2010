//
//  FacebookButton.h
//
//  Created by Steffen Itterheim on 21.03.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

#import "SimpleButton.h"

@interface FacebookButton : SimpleButton
{

}

+(id) facebookButtonWithTarget:(id)target selector:(SEL)selector;
-(id) initWithTarget:(id)target selector:(SEL)selector;

@end
