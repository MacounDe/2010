//
//  WNAppDelegate.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 21.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNAppDelegate.h"


@interface WNAppDelegate (Private)
-(void) orientationChanged:(NSNotification*)notification;
@end

@implementation WNAppDelegate

static NSObject<WNGameDelegate>* gameDelegate = nil;

@synthesize window;
@synthesize isPlaying, isPaused;
@synthesize pauseDelegate;


+(void) setGameDelegate:(NSObject<WNGameDelegate>*)delegate
{
	[gameDelegate release];
	gameDelegate = [delegate retain];
}

-(void) setPauseDelegate:(NSObject<WNPauseDelegate>*)delegate
{
	CCLOG(@"setPauseDelegate: existing delegate: %@ -- new delegate: %@", pauseDelegate, delegate);
	
	// I don't do proper retain/release here because the WNScene is responsible for adding/removing itself
	// you'll have only one WNScene running and you should notice the assert if you do something wrong
	// If you try to use proper retain/release cycle here you can easily trap yourself into endless calls to this method,
	// leading to a stack overflow crash - that's because WNScene calls this method in dealloc and then releasing
	// the delegate here will cause dealloc to be called again, calling this method, ad infinitum ...
	// but maybe i just did something terribly wrong and didn't want to spend more time to figure it out because
	// it's working just fine this way :)   ... if you want to wrap your head around it, be my guest!
	if (delegate != nil)
	{
		NSAssert(pauseDelegate == nil, @"AppDelegate - setPauseDelegate: a pause delegate is already set! This indicates an error, possibly GameScene not deallocated properly?");
		pauseDelegate = delegate;
	}
	else
	{
		pauseDelegate = nil;
	}
}

-(id) init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

void onUncaughtException(NSException* exception)
{
	NSLog(@"uncaught exception: %@", exception.description);
}

-(void) applicationDidFinishLaunching:(UIApplication*)application
{
	// TODO: load director setup from XML?
	
	NSSetUncaughtExceptionHandler(&onUncaughtException);

	// Tell the UIDevice to send notifications when the orientation changes
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(orientationChanged:) 
												 name:@"UIDeviceOrientationDidChangeNotification" 
											   object:nil];
	
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// must be called before any othe call to the director
	if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
	{
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];
	}
	
	CCDirector *director = [CCDirector sharedDirector];
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	// Create an EAGLView with a RGB8 color buffer, and a depth buffer of 24-bits
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8
								   depthFormat:GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO];
	[director setOpenGLView:glView];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];	
	
	// 2D projection
	//	[director setProjection:kCCDirectorProjection2D];
	
	// To use High-Res un comment the following line
	//	[director setContentScaleFactor:2];	

	// at this point the game delegate might set other director or global settings, or overwrite the defaults
	[gameDelegate onBeforeWindowAttachedToDirectorView];

	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	[window addSubview:glView];
	[window makeKeyAndVisible];	

	// inform game delegate that it should now run the first scene
	[gameDelegate onReadyToRunFirstScene];
}

/** This method allows us to support both landscape orientations and orientation can be changed on the fly.
 If you change this you should also modify UISupportedInterfaceOrientations in Info.plist. */
-(void) orientationChanged:(NSNotification*)notification
{
	// TODO: support the same for portrait mode as well, depending on what is set in info.plist
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
	{
		[[CCDirector sharedDirector] setDeviceOrientation:(ccDeviceOrientation)orientation];
	}
	// set default orientation on App startup (orientation "Unknown") or if orientation is not in one of the modes above on startup
	else if (hasOrientationChangedBefore == NO)
	{
		[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	}
	
	if (!hasOrientationChangedBefore)
	{
		hasOrientationChangedBefore = YES;
	}
}

-(void) applicationWillResignActive:(UIApplication*)application
{
	[[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication*)application
{
	[[CCDirector sharedDirector] resume];
	
	if (isPlaying)
	{
		// only while playing we will show a pause dialogue to stop gameplay
		// in menu screens etc. it wouldn't make sense to display a pause dialog
		[pauseDelegate onPauseGame];
	}
	else
	{
		// only resume if the pause menu isn't shown
		if (isPaused == NO)
		{
			[[CCDirector sharedDirector] resume];
		}
	}
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication*)application
{
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

-(void) applicationWillTerminate:(UIApplication*)application
{
	[[CCDirector sharedDirector] end];
}

-(void) applicationSignificantTimeChange:(UIApplication*)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

/** Note: dealloc of the AppDelegate is never called!
 This is normal behavior, see: http://stackoverflow.com/questions/2075069/iphone-delegate-controller-dealloc
 The App's memory is wiped anyway so the App doesn't go through to effort to call object's dealloc on App terminate
 still it's good practice to still write the dealloc code, in case that ever were to change
 */
-(void) dealloc
{
	[gameDelegate release];
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
