//
//  WNComponent.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 12.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNMacros.h"


#define COMPONENT_DEBUG 1


/** list of notification types any Component might send */
static NSString* const kNotificationComponentAdded = @"onComponentAdded";
static NSString* const kNotificationComponentRemoved = @"onComponentRemoved";

/** defines the messages all components must implement */
@protocol WNComponentProtocol
/** First message received, use to run first-time setup stuff. IMPORTANT: there's no guarantee that other WNNodeComponent's nodes are initialized at this point! */
-(void) onInitialize;

@optional
/** Called every frame but only when implemented. */
-(void) onUpdate:(ccTime)delta;
@end

@class WNEntity;

/** base class for all components, implements the WNComponentProtocol and NSCopying for template support */
@interface WNComponent : NSObject <WNComponentProtocol, NSCopying>
{
	@protected

	/** component's entity */
	WNEntity* owner_;
	
	int tag_;
	
//@private
	bool isEnabled_;
	bool isInitialized_;
	
@private
	NSString* name_;
	NSNotificationCenter* notificationCenter_;
}

/** used to identify the entity by name */
@property (nonatomic, copy) NSString* name;

/** the entity owning this component */
@property (nonatomic, readonly) WNEntity* owner;
/** used to identify component by tag */
@property (nonatomic) int tag;
/** an enabled component gets its update method called each frame */
@property (nonatomic) bool isEnabled;
/** used to verify that the component was properly initialized (TO BE REMOVED) */
@property (nonatomic, readonly) bool isInitialized;

/** returns an autoreleased component */
+(id) component;

// TODO:
// ? onComponentAdded, onComponentRemoved, ...

/** send a notification with the given name */
-(void) sendNotificationName:(NSString* const)notificationName;
/** send a notification with the given name and a NSMutableDictionary containing whatever info needed to pass along */
-(void) sendNotificationName:(NSString* const)notificationName userInfo:(NSMutableDictionary*)userInfo;

/** adds a component as an observer to notifications of the specified name, no matter who is sending them. 
 Calls selector based on notificationName in format: -(void) received<NotificationName>:(NSNotification*)notification */
-(void) registerForNotificationsByName:(NSString*)notificationName;
/** adds a component as an observer to notifications of the specificed name from the specified sending component.
 Calls selector based on notificationName in format: -(void) received<NotificationName>:(NSNotification*)notification */
-(void) registerForNotificationsByName:(NSString*)notificationName sender:(WNComponent*)sender;
/** adds a component as an observer to notifications of the specificed name from the specified sending component.
 Calls the specified selector. */
-(void) registerForNotificationsByName:(NSString*)notificationName sender:(WNComponent*)sender selector:(SEL)selector;

/** removes this component as observer */
-(void) removeNotificationObserver;
/** removes this component as observer for notifications with the given name */
-(void) removeNotificationObserverFromName:(NSString*)notificationName;
/** removes this component as observer from notifications of the given entity */
-(void) removeNotificationObserverFromSender:(WNEntity*)sender;
/** removes this component as observer from notifications with the given name and sending entity */
-(void) removeNotificationObserverFromName:(NSString*)notificationName sender:(WNEntity*)sender;



// SYSTEM-INTERNAL METHODS:

/** DO NOT CALL YOURSELF - called by entity to set it as owner of the component */
-(void) setOwnerOnInit:(WNEntity*)owningEntity;

/** DO NOT CALL YOURSELF - called by entity each frame, calls update if component is enabled */
-(void) evaluate:(ccTime)delta;

/** DO NOT CALL YOURSELF - called by entity to send onInitialize message. */
-(void) initializeComponent;


@end
