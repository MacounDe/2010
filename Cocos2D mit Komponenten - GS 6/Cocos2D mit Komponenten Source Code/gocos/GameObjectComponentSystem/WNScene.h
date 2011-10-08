//
//  WNScene.h
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"
#import "WNAppDelegate.h"

@class WNEntity;
@class WNEntityPool;

/** Parent object for a Scene built using a WNEntity hierarchy. Contains the pool of entities and so provides
 access to all entities in the scene.
 Derived from CCScene so it can be used with CCDirector's replaceScene etc methods, plus it needs to handle the onEnter and onExit messages. */
@interface WNScene : CCScene <WNPauseDelegate>
{
@private
	WNEntityPool* entityPool_;
}

@property (nonatomic, readonly) WNEntityPool* entityPool;
@property (nonatomic, readonly) bool isPlaying;
@property (nonatomic, readonly) bool isPaused;

-(void) onPauseGame;
-(void) onResumeGame;

@end
