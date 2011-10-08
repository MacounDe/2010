//
//  TextureAtlasManager.h
//
//  Created by Steffen Itterheim on 02.12.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

#import <Foundation/Foundation.h>

@interface TextureAtlasManager : NSObject
{

}

+(TextureAtlasManager*) singleton;
+(id) alloc;

//-(void) loadTextures;
-(void) loadTextureByName:(NSString*)name;
-(void) removeTextureByName:(NSString*)name;
-(CCSprite*) getSpriteByName:(NSString*)name;

@end
