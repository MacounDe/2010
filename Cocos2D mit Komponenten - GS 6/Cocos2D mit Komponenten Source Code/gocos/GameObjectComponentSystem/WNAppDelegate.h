//
//  WNAppDelegate.h
//  cocos2d-project
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>


/** the WNGameDelegate gets UIApplicationAppDelegate messages forwarded but more appropriate for games and also because
 the WNAppDelegate does a lot of the grunt work itself */
@protocol WNGameDelegate

/** perform any specific CCDirector initialization here */
-(void) onBeforeWindowAttachedToDirectorView;
/** game view and Director are setup, it's time to run a scene - do it in this method */
-(void) onReadyToRunFirstScene;

@end


/** callback for bringing up the game pause menu */
@protocol WNPauseDelegate <NSObject>
/** called when the game is supposed to be paused, either by the device going in standby or receiving a call/SMS or when the user presses the pause button */
-(void) onPauseGame;
@end

/** This is an AppDelegate that does most of the UIApplicationDelegate stuff for you and provides common functionality like Pause/Resume
 and cocos2d setup. You can make a class that implements the WNGameDelegate protocol to write specific code for AppDelegate messages.
 Over time WNAppDelegate eventually will forward everything you need while hiding everything you don't want to see or rewrite for each project. */
@interface WNAppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow *window;

	NSObject<WNPauseDelegate>* pauseDelegate;
	
	bool hasOrientationChangedBefore;
	bool isPlaying;
	bool isPaused;
}

/** yup, that's the window */
@property (nonatomic, retain) UIWindow *window;
/** is set when the player is actively playing the game. Should be false in menu screens or anytime an interruption like a phone call
 or incoming SMS should not bring up the pause menu. For example turn-based games may decide to never set isPlaying since the player
 can take as much time as he wants. Whereas in action games or those with a time-limit just missing the first second after a call
 can get the player in serious trouble or losing the game, in that case set isPlaying to true whenever the game is played. */
@property (readwrite, nonatomic) bool isPlaying;
/** whether the game is currently paused. Determines if game needs to be resumed or a pause menu shown. */
@property (readwrite, nonatomic) bool isPaused;
/** this is a weak reference to an object implementing the PauseDelegate protocol which will handle showing and closing
 the pause menu. */
@property (readonly, assign) NSObject<WNPauseDelegate>* pauseDelegate;

/** sets the WNGameDelegate object, must be set in main.m before the call to UIApplicationMain if you want to receive the init messages. */
+(void) setGameDelegate:(NSObject<WNGameDelegate>*)delegate;

/** sets the WNPauseDelegate object, which will get pause and resume messages. */
-(void) setPauseDelegate:(NSObject<WNPauseDelegate>*)delegate;

@end
