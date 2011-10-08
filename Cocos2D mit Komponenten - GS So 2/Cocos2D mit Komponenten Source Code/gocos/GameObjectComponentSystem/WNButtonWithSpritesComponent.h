//
//  WNButtonWithSpritesComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** A CCMenu node with one CCMenuItemSprite acting as a simple button. Sends message "buttonName + Activated" when touched.
 Reacts to "buttonName + SetEnabled" and "buttonName + SetDisabled" notifications. For example if buttonName = "MyButton"
 then the message to send to disable this button must be named "MyButtonSetDisabled" */
@interface WNButtonWithSpritesComponent : WNNodeComponent
{
	@private
	CCSprite* normalSprite_;
	CCSprite* selectedSprite_;
	CCSprite* disabledSprite_;
	NSString* buttonName_;
	
	NSString* onTouchedNotificationName_;
}

/** must be set */
@property (nonatomic, retain) CCSprite* normalSprite;
/** must be set */
@property (nonatomic, retain) CCSprite* selectedSprite;
/** optional */
@property (nonatomic, retain) CCSprite* disabledSprite;
/** Used to prefix notification names. Eg buttonName + OnTouched ...
 For example, if buttonName = MyButton the Notification sent is named MyButtonActivated */
@property (nonatomic, copy) NSString* buttonName;

@end
