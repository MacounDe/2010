//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"

// only added here to ensure that box2d settings are correct (if not you'll get a lot of compile errors)
#import "Box2D.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	CCScene *scene = [CCScene node];
	HelloWorld *layer = [HelloWorld node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		// available Preprocessor Macros:
		// DEBUG, RELEASE
		// LITE_VERSION, FULL_VERSION
		// TARGET_IPAD, TARGET_IPHONE_IPOD
#if DEBUG
		CCLabel* label = [CCLabel labelWithString:@"Hello, DEBUG!" fontName:@"Marker Felt" fontSize:64];
#else
		CCLabel* label = [CCLabel labelWithString:@"Hello, RELEASE!" fontName:@"Marker Felt" fontSize:64];
#endif

		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 );
		[self addChild: label];
		
		/* ... trying to test static analyzer here ...
		// over-releasing an object:
		[label release];
		[label release];
		
		// allocating but not freeing an object
		NSString* str;
		int number;
		CCLabel* newLabel = [[CCLabel alloc] initWithString:str fontName:str fontSize:number];
		[newLabel setPosition:CGPointZero];
		*/
	}
	return self;
}

-(void) dealloc
{

	[super dealloc];
}

@end
