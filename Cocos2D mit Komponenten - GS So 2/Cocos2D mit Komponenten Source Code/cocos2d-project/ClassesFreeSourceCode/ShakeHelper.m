//
//  ShakeHelper.m
//
//  Created by Steffen Itterheim on 29.11.09.
//

// NOTE: the original shake detection code is from the Internet but unfortunately i can't remember where it is from, 
// otherwise i would have credited it.

#import "ShakeHelper.h"


@interface ShakeHelper (Private)
@end

@implementation ShakeHelper

// Ensures the shake is strong enough on at least two axes before declaring it a shake.
// "Strong enough" means "greater than a client-supplied threshold" in G's.
static BOOL AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) 
{
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

+(id) shakeHelperWithDelegate:(NSObject<ShakeHelperDelegate>*)del
{
	return [[[self alloc] initShakeHelperWithDelegate:del] autorelease];
}

-(id) initShakeHelperWithDelegate:(NSObject<ShakeHelperDelegate>*)del
{
	if ((self = [super init]))
	{
		delegate = del;
		[UIAccelerometer sharedAccelerometer].delegate = self;
	}
	
	return self;
}

-(void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration 
{
	if (lastAcceleration)
	{
		if (!histeresisExcited && AccelerationIsShaking(lastAcceleration, acceleration, 0.8)) 
		{
			histeresisExcited = YES;
			
			[delegate onShake];
		}
		else if (histeresisExcited && !AccelerationIsShaking(lastAcceleration, acceleration, 0.2))
		{
			histeresisExcited = NO;
		}
	}

	[lastAcceleration release];
	lastAcceleration = [acceleration retain];
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	[UIAccelerometer sharedAccelerometer].delegate = nil;
	[lastAcceleration release];
	[super dealloc];
}

@end
