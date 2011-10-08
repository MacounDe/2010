//
//  LargeTextureLoader.h
//
//  Created by Steffen Itterheim on 16.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"

@protocol LargeTextureLoaderDelegate
-(void) onBeforeTextureLoad:(NSString*)name;
-(void) onAfterTextureLoad:(NSString*)name texture:(CCTexture2D*)texture;
-(void) onCompletedTextureLoad;
@end


@interface LargeTextureLoader : CCNode
{
	CCNode<LargeTextureLoaderDelegate>* delegate;
	
	NSArray* names;
	int numLeftToLoad;
}

+(id) largeTextureLoaderWithDelegate:(CCNode<LargeTextureLoaderDelegate>*)del textureNames:(NSArray*)textureNames interval:(float)interval;
-(id) initWithDelegate:(CCNode<LargeTextureLoaderDelegate>*)del textureNames:(NSArray*)textureNames interval:(float)interval;

@end
