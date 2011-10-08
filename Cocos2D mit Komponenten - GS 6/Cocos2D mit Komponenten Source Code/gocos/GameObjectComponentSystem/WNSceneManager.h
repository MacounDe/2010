//
//  WNSceneManager.h
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

@class WNScene;

/** Singleton for managing the WNScene hierarchy */
@interface WNSceneManager : NSObject
{
@private
	WNScene* currentScene_;
	
	// TODO: list all xml files which contain scenes and store them with scene name as key
	NSMutableDictionary* sceneFiles;
}

@property (nonatomic, readonly) WNScene* currentScene;

/** returns the singleton object, like this: [WNSceneManager sharedWNSceneManager] */
+(WNSceneManager*) sharedManager;

/** runs or replaces the current scene with the new scene */
-(void) switchToScene:(WNScene*)newScene;

/** switches to the scene with the given name */
-(void) switchToSceneByName:(NSString*)sceneName;

@end
