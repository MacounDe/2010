//
//  LayoutHelper.h
//
//  Created by Steffen Itterheim on 28.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

//@class SimpleButton;

@interface LayoutHelper : CCLayer
{
	CCNode* parentNode;
	CCSprite* sprite;
	CCLabel* positionLabel;
	
	bool isDragging;
}

+(id) helperWithSprite:(CCSprite*)spr parent:(CCNode*)par;
-(id) initWithSprite:(CCSprite*)spr parent:(CCNode*)par;

/*
+(id) helperWithSimpleButton:(SimpleButton*)simpleButton;
-(id) initWithSimpleButton:(SimpleButton*)simpleButton;
 */

@end
