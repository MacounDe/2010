//
//  TextureAtlasManager.m
//
//  Created by Steffen Itterheim on 02.12.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "TextureAtlasManager.h"
#import "Utilities.h"


@interface TextureAtlasManager (Private)
@end

@implementation TextureAtlasManager

static TextureAtlasManager *instanceOfTextureAtlasManager;

+(TextureAtlasManager*) singleton
{
	@synchronized(self)
	{
		if (instanceOfTextureAtlasManager == nil)
		{
			[[TextureAtlasManager alloc] init];
		}
		
		return instanceOfTextureAtlasManager;
	}
	
	// to avoid compiler warning
	return nil;
}

+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfTextureAtlasManager == nil, @"Attempted to allocate a second instance of the singleton: TextureAtlasManager");
		instanceOfTextureAtlasManager = [[super alloc] retain];
		return instanceOfTextureAtlasManager;
	}
	
	// to avoid compiler warning
	return nil;
}

-(TextureAtlasManager*) init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	[instanceOfTextureAtlasManager release];
	instanceOfTextureAtlasManager = nil;
	
	[super dealloc];
}

/*
-(void) loadTextures
{
	double startKb = [Utilities getAvailableKiloBytes];

	[self loadTextureByName:@"Atlas_Tierteile1"];
	double tex1Kb = [Utilities getAvailableKiloBytes];
	[[CCDirector sharedDirector] drawScene];
	[self loadTextureByName:@"Atlas_Tierteile2"];
	double tex2Kb = [Utilities getAvailableKiloBytes];
	[[CCDirector sharedDirector] drawScene];
	[self loadTextureByName:@"Atlas_Tierteile3"];
	double tex3Kb = [Utilities getAvailableKiloBytes];
	[[CCDirector sharedDirector] drawScene];
	[self loadTextureByName:@"Atlas_Tierteile4"];
	double tex4Kb = [Utilities getAvailableKiloBytes];
	[[CCDirector sharedDirector] drawScene];

	double finalKb = [Utilities getAvailableKiloBytes];

	NSString* memText = [NSString stringWithFormat:@"loadTextures memory:\nstart KB = %f\nText1 = %f\nText2 = %f\nText3 = %f\nText4 = %f\nfinal KB = %f", startKb, tex1Kb, tex2Kb, tex3Kb, tex4Kb, finalKb];
	CCLOG(@"%@", memText);
}
*/

-(void) loadTextureByName:(NSString*)name
{
	NSString* plist = [name stringByAppendingPathExtension:@"plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plist];
}

-(void) removeTextureByName:(NSString*)name
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrameByName:name];
}

-(CCSprite*) getSpriteByName:(NSString*)name
{
	return [CCSprite spriteWithSpriteFrameName:name];
}

@end
