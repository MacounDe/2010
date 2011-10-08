//
//  WNComponent.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 12.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponent.h"
#import "WNEntity.h"


@interface WNComponent (Private)
-(void) verifyInitComplete;
@end


@implementation WNComponent

@synthesize name=name_;
@synthesize owner=owner_;
@synthesize tag=tag_;
@synthesize isEnabled=isEnabled_;
@synthesize isInitialized=isInitialized_;

#pragma mark init
-(id) init
{
	if ((self = [super init]))
	{
		tag_ = kCCNodeTagInvalid;
		name_ = nil;
		notificationCenter_ = [NSNotificationCenter defaultCenter];
	}
	
	return self;
}

+(id) component
{
	return [[[self alloc] init] autorelease];
}

#pragma mark dealloc
-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	if (owner_ != nil)
	{
		//[self sendNotificationName:kNotificationComponentRemoved];
	}

	[owner_ release];
	[name_ release];
	
	[self removeNotificationObserver];
	
	[super dealloc];
}

#pragma mark onInitialize
-(void) setOwnerOnInit:(WNEntity*)owningEntity
{
	NSAssert(owner_ == nil, @"component already has an owner!");
	owner_ = [owningEntity retain];
}

-(void) initializeComponent
{
	[self onInitialize];
	isInitialized_ = YES;
	isEnabled_ = [self respondsToSelector:@selector(onUpdate:)];
}

-(void) onInitialize
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"You must override %@ in your class implementation!", NSStringFromSelector(_cmd)];
}

#pragma mark evaluate & update
-(void) evaluate:(ccTime)delta
{
	NSAssert(isInitialized_, @"Component is not initialized! Did you forget to call [component initialize] ?");

	if (isEnabled_)
	{
		[self onUpdate:delta];
	}
}

#pragma mark Notifications

-(void) checkNotificationName:(NSString*)notificationName
{
	if (notificationName == nil)
	{
		[NSException raise:NSInternalInconsistencyException format:@"Notification name is nil!"];
	}
	
	if ([notificationName length] <= 1)
	{
		[NSException raise:NSInternalInconsistencyException 
					format:@"Notification name '%@' is too short, must be at least 2 characters long!", notificationName];
	}
}

-(void) sendNotificationName:(NSString* const)notificationName
{
	[self sendNotificationName:notificationName userInfo:nil];
}

-(void) sendNotificationName:(NSString* const)notificationName userInfo:(NSMutableDictionary*)userInfo
{
#ifdef DEBUG
	[self checkNotificationName:notificationName];
	WNLOG(@"SENDING NOTIFICATION: %@", notificationName);
#endif

	[notificationCenter_ postNotificationName:notificationName object:self userInfo:userInfo];
}

-(void) registerForNotificationsByName:(NSString*)notificationName
{
	[self registerForNotificationsByName:notificationName sender:nil];
}

-(void) registerForNotificationsByName:(NSString*)notificationName sender:(WNComponent*)sender
{
	// Find the selector based on the notification name
	NSString* selectorName = [NSString stringWithFormat:@"received%@:", notificationName];
	SEL selector = NSSelectorFromString(selectorName);
	
	[self registerForNotificationsByName:notificationName sender:sender selector:selector];
}

-(void) registerForNotificationsByName:(NSString*)notificationName sender:(WNComponent*)sender selector:(SEL)selector
{
#ifdef DEBUG
	[self checkNotificationName:notificationName];
	WNLOG(@"RECEIVE NOTIFICATION: %@", notificationName);
#endif

	// Ensure that this selector method is actually implemented.
	// Note: NSSelectorFromString creates the selector whether the method exists or not! So you can't check for: selector == nil
	Method method = class_getInstanceMethod([self class], selector);
	if (method == nil)
	{
		[NSException raise:NSInternalInconsistencyException 
					format:@"%@ does not respond to selector -(void) %@:(NSNotification*)notification -- Tip: check if selector is spelled correctly including case!", self, NSStringFromSelector(selector)];
	}
	
	[notificationCenter_ addObserver:self selector:selector name:notificationName object:sender];
}

-(void) removeNotificationObserver
{
	[notificationCenter_ removeObserver:self];
}

-(void) removeNotificationObserverFromName:(NSString*)notificationName
{
	[notificationCenter_ removeObserver:self name:notificationName object:nil];
}

-(void) removeNotificationObserverFromSender:(WNEntity*)sender
{
	[notificationCenter_ removeObserver:self name:nil object:sender];
}

-(void) removeNotificationObserverFromName:(NSString*)notificationName sender:(WNEntity*)sender
{
	[notificationCenter_ removeObserver:self name:notificationName object:sender];
}

#pragma mark NSCopying

-(id) copyWithZone:(NSZone*)zone
{
	NSAssert(isInitialized_ == NO, @"components can only be copied before they have been initialized!");
	
	// FIXME: NSCopyObject is dangerous and may become deprecated... This is just a temporary solution
	return NSCopyObject(self, 0, zone);
}
@end
