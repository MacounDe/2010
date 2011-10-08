//
//  LargeTextureLoader.m
//
//  Created by Steffen Itterheim on 16.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "LargeTextureLoader.h"

// NOTE: this is still work in progress ...

@interface LargeTextureLoader (Private)
-(void) loadNextTexture:(ccTime)delta;
@end

@implementation LargeTextureLoader

+(id) largeTextureLoaderWithDelegate:(CCNode<LargeTextureLoaderDelegate>*)del textureNames:(NSArray*)textureNames interval:(float)interval
{
	return [[[self alloc] initWithDelegate:del textureNames:textureNames interval:interval] autorelease];
}

-(id) initWithDelegate:(CCNode<LargeTextureLoaderDelegate>*)del textureNames:(NSArray*)textureNames interval:(float)interval
{
	if ((self = [super init]))
	{
		names = [textureNames copy];
		numLeftToLoad = [names count];
		
		delegate = del;
		[delegate addChild:self];
		[self schedule:@selector(loadNextTexture:) interval:interval];
	}

	return self;
}

-(void) dealloc
{
	[names release];
	[super dealloc];
}

-(void) loadNextTexture:(ccTime)delta
{
	if (numLeftToLoad > 0)
	{
		[delegate onBeforeTextureLoad:@""];
		
		[delegate onAfterTextureLoad:@"" texture:nil];
		numLeftToLoad--;
	}
	else if (numLeftToLoad == 0)
	{
		[delegate onCompletedTextureLoad];
		// self release???
	}
}

@end
