//
//  WNEntity.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 12.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "WNComponent.h"
#import "WNMacros.h"
#import "WNNodeComponent.h"

// FIXME: move this enum to node component
typedef enum
{
	CocosNodeTypeUNSET = 0,
	CocosNodeTypeCCNode,
	CocosNodeTypeCCSprite,
	
	MAX_CocosNodeType,
} ECocosNodeType;

/** the single game object class used for all purposes and implements game logic via game components.
 Has a Facade via Message Forwarding so it accepts any message a CCNode class would. */
@interface WNEntity : NSObject
{
@private
	NSString* name_;

	WNNodeComponent* nodeComponent_; // weak ref
	
	/** list of registered game components which this entity is using */
	CCArray* components_;
}

/** used to identify the entity by name */
@property (nonatomic, copy) NSString* name;

/** WNNodeComponent derivced object used to represent this entity in the cocos2d engine.
 Is not valid until a WNNodeComponent is added and fully initialized! */
@property (nonatomic, readonly) WNNodeComponent* nodeComponent;
/** CCNode derived object used to represent this entity in the cocos2d engine. Shorthand for calling [[entity nodeComponent] node]
  Is not valid until a WNNodeComponent is added and fully initialized! */
@property (nonatomic, readonly) CCNode* node;

/** returns autoreleased entity */
+(id) entity;

// adds entity node component to this entity's node component so that cocos2d-wise they are connected
// addChildEntity:entity

-(void) removeEntity;

/** update is called every frame */
-(void) update:(ccTime)delta;

/** Adds a component to this entity. */
-(void) addComponent:(WNComponent*)newComponent;
/** gets a component by tag */
-(WNComponent*) getComponentByTag:(int)tag;
/** removes a component by tag */
-(void) removeComponentByTag:(int)tag;
// remove, removeAll, get, getBy.., componentExists, ... createFromTemplate ...

/** After adding all individual components this initializes them. */
-(void) initializeComponents;

@end


// ============================================================================================================
// CCNode Facade - we declare all forwarded properties and methods in a category just to avoid compile errors
// the actual message forwarding is done by the methodSignatureForSelector: and forwardInvocation: methods
// ============================================================================================================
@interface WNEntity (CCNodeForwarding)

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;
@property (nonatomic) float scale;
@property (nonatomic) int tag;

-(CCAction*) runAction: (CCAction*) action;
-(void) stopAllActions;
-(void) stopAction: (CCAction*) action;
-(void) stopActionByTag:(int) tag;
-(CCAction*) getActionByTag:(int) tag;
-(int) numberOfRunningActions;

@end
