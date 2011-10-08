//
//  SimpleButton.h
//
//  Created by Steffen Itterheim on 27.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"


static const int kButtonTag = 666;


@interface SimpleButton : CCNode <CCRGBAProtocol>
{
	GLubyte opacity_;
	ccColor3B color_;

@protected
	CCMenu* menu;
}

@property (readonly) CCMenu* menu;

-(void) setColor:(ccColor3B)color;
-(ccColor3B) color;
-(GLubyte) opacity;
-(void) setOpacity: (GLubyte) opacity;

+(void) setIsEnabledForAllButtons:(CCArray*)children enabled:(bool)enabled;
-(void) setIsEnabled:(bool)enabled;

+(id) simpleButtonAtPosition:(CGPoint)position image:(NSString*)image target:(id)target selector:(SEL)selector;
-(id) initWithPosition:(CGPoint)position image:(NSString*)image target:(id)target selector:(SEL)selector;

@end
