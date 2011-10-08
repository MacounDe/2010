//
//  EntityComponentTest.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <objc/runtime.h>

#import "EntityComponentTest.h"

#import "WNEntity.h"
#import "WNEntityPool.h"
#import "WNSceneManager.h"

#import "WNWrapAroundBorderComponent.h"
#import "WNDrawAtOpposingBorderComponent.h"
#import "WNMoveComponent.h"
#import "WNSpriteComponent.h"

@interface EntityComponentTest : CCLayer
{}
-(void) tick;
@end

@implementation EntityComponentTest

-(id) init
{
	if( (self=[super init] ) )
	{
		self.isTouchEnabled = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		CCLabel *label = [CCLabel labelWithString:@"TEST" fontName:@"Marker Felt" fontSize:250];
		label.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		label.color = ccGRAY;
		[self addChild:label];

		// create the entity via the pool
		WNEntity* entity = [[WNEntityPool sharedPool] createEntity];
		// the first thing you do with an entity is to create and add a WNNodeComponent derived object
		WNSpriteComponent* spr = [WNSpriteComponent componentWithEntity:entity];
		spr.file = @"Icon.png";
		spr.parent = self;
		spr.z = 0;
		spr.tag = 665;
		// initialize the component to do one-time setup work, and also add the entity with its node as child
		[spr initializeComponent];

		// now you can setup entity properties as needed
		// most of the properties get forwarded to the CCNode object so they'll have to wait till after component initialize
		entity.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		entity.scale = 0.6789f;
		entity.rotation = CCRANDOM_0_1() * 360;
		
		// create other components as needed
		WNMoveComponent* move = [WNMoveComponent componentWithEntity:entity];
		//move.velocity = CGPointMake(3.456789f, 1.2345456f);
		move.speed = 250;
		move.direction = 0;
		move.tag = 111;
		[move initializeComponent];
		
		WNWrapAroundBorderComponent* wrap = [WNWrapAroundBorderComponent componentWithEntity:entity];
		wrap.boundary = CGRectMake(0, 0, screenSize.width, screenSize.height);
		wrap.tag = 123;
		[wrap initializeComponent];
		
		WNDrawAtOpposingBorderComponent* drawDouble = [WNDrawAtOpposingBorderComponent componentWithEntity:entity];
		[drawDouble initializeComponent];

		
		//[entity removeComponentByTag:123];

		// load entities & components from XML instead (or in addition)
		
		[self schedule:@selector(tick) interval:0.1f];
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) tick
{
	{
		WNEntity* entity = [[WNEntityPool sharedPool] getEntityByTag:665];
		WNMoveComponent* move = (WNMoveComponent*)[entity getComponentByTag:111];
		move.direction -= 4;
		
		entity.node.rotation += 4;
	}
	{
		WNEntity* entity = [[WNEntityPool sharedPool] getEntityByTag:666];
		WNMoveComponent* move = (WNMoveComponent*)[entity getComponentByTag:111];
		move.direction += 5;
		
		entity.node.rotation += 2;
	}
}
@end

@implementation TestCase

-(void) applicationDidFinishLaunching:(UIApplication*)application
{	
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:NO];
	
	// must be called before any othe call to the director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeMainLoop];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];	
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];	
	
	CCScene *scene = [CCScene node];
	CCNode *node = [EntityComponentTest node];
	[scene addChild:node];
	
	[WNSceneManager sharedManager];
	
	[[CCDirector sharedDirector] runWithScene: scene];
	
	unsigned int varCount;
	
	Ivar *vars = class_copyIvarList([TestCase class], &varCount);
	
	for (unsigned int i = 0; i < varCount; i++) {
		Ivar var = vars[i];
		
		const char* name = ivar_getName(var);
		const char* typeEncoding = ivar_getTypeEncoding(var);
		NSLog(@"name: %@, type: (%@)", [NSString stringWithCString:name encoding:NSASCIIStringEncoding], [NSString stringWithCString:typeEncoding encoding:NSASCIIStringEncoding]);
	}
	
	free(vars);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) dealloc
{
	[window release];
	[super dealloc];
}
@end
