//
//  WNNodeComponent.h
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"


/** encapsulates a cocos2d CCNode class object */
@interface WNNodeComponent : WNComponent
{
@protected
	CCNode* node_;
	CCNode* parentNode_; // weak ref to parent
	WNNodeComponent* parentNodeComponent_; // weak ref to parent node component
@private
	int z_;
}

@property (nonatomic, assign) CCNode* parentNode;
@property (nonatomic, assign) WNNodeComponent* parentNodeComponent;
@property (nonatomic) int z;

// Node accessors ... use depending on the WNNodeComponent subclass.
/** returns the CCNode used by WNNodeComponent */
@property (nonatomic, readonly) CCNode* node;
/** returns the CCNode casted to CCSprite, asserts that node is a CCSprite. */
@property (nonatomic, readonly) CCSprite* sprite;
/** returns the CCNode casted to CCSpriteBatchNode, asserts that node is a CCSpriteBatchNode. */
@property (nonatomic, readonly) CCSpriteBatchNode* spriteBatch;
/** returns the CCNode casted to CCLayer, asserts that node is a CCLayer. */
@property (nonatomic, readonly) CCLayer* layer;
/** returns the CCNode casted to CCMenu, asserts that node is a CCMenu. */
@property (nonatomic, readonly) CCMenu* menu;


/** Initializes a WNNodeComponent with a parent CCNode. */
+(id) componentWithParentNode:(CCNode*)node;

/** Initializes a WNNodeComponent with a parent WNNodeComponent derived object. */
+(id) componentWithParentComponent:(WNNodeComponent*)nodeComponent;

/** ONLY CALL FROM WNNodeComponent derivce classes - called to add the newly created CCNode based class as child to the entity's parent */
-(void) addNodeAsChild;

@end
