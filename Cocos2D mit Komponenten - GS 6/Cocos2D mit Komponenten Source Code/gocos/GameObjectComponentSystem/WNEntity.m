//
//  WNEntity.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 12.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNEntity.h"


@interface WNEntity (Private)
-(void) verifyInitOnlyOnce;
-(void) verifyInitComplete;
-(void) evaluateComponents:(ccTime)delta;
@end


@implementation WNEntity

/** update delta time will be capped if this is > 0 to ensure that objects don't jump around on screen
 when something happens that requires a huge amount of CPU time.
 0.08 means the game will slow down at about ~10 fps instead of skipping simulation ahead of time */
static float EntityUpdateDeltaLimit = 0.08f;

@synthesize name=name_;
@synthesize nodeComponent=nodeComponent_;

@dynamic node;
-(CCNode*) node
{
	//NSAssert(nodeComponent_ != nil, @"nodeComponent is nil, can't access node (yet) or Entity does not have a WNNodeComponent (yet)! The order of creating/loading and adding components is important, make sure a WNNodeComponent always comes first!!");
	//NSAssert([nodeComponent_ node] != nil, @"nodeComponent's node is nil, can't access node (yet), probably WNNodeComponent not yet initialized!");
	return [nodeComponent_ node];
}

#pragma mark init
/** initialize everything else */
-(void) initCommon
{
	name_ = nil;
	components_ = [[CCArray alloc] initWithCapacity:2];
	[[CCScheduler sharedScheduler] scheduleUpdateForTarget:self priority:-1000 paused:NO];

}


-(id) init
{
	if ((self = [super init]))
	{
		[self initCommon];
	}
	
	return self;
}

+(id) entity
{
	return [[[self alloc] init] autorelease];
}

#pragma mark dealloc
-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[[CCScheduler sharedScheduler] unscheduleAllSelectorsForTarget:self];

	[components_ release];
	
	[super dealloc];
}

#pragma mark pause/resume

// FIXME: when and how (or from whom) are onPause / onResume called??
-(void) onPauseGame
{
	[[CCScheduler sharedScheduler] pauseTarget:self];
}

-(void) onResumeGame
{
	[[CCScheduler sharedScheduler] resumeTarget:self];
}

#pragma mark update
-(void) update:(ccTime)delta
{
	if (delta > EntityUpdateDeltaLimit)
	{
		CCLOG(@"deltaLimit hit - original delta was %.4f, got capped to %.4f", delta, EntityUpdateDeltaLimit);
		delta = EntityUpdateDeltaLimit;
	}
	
	[self evaluateComponents:delta];
}

#pragma mark components
-(void) evaluateComponents:(ccTime)delta
{
	WNComponent* component;
	CCARRAY_FOREACH(components_, component)
	{
		[component evaluate:delta];
	}
}

-(void) tryAssignNodeComponent:(WNComponent*)component
{
	if ([component isKindOfClass:[WNNodeComponent class]])
	{
		if (nodeComponent_ != nil)
		{
			CCLOG(@"Adding child WNNodeComponent (%@) to (%@) in Entity (%@)", nodeComponent_, component, self);
		}
		else
		{
			nodeComponent_ = (WNNodeComponent*)component; // weak ref
		}
	}
}

-(void) addComponent:(WNComponent*)newComponent
{
	NSAssert(newComponent != nil, @"component is nil!");
	
	[self tryAssignNodeComponent:newComponent];
	[components_ addObject:newComponent];
}

-(WNComponent*) getComponentByTag:(int)tag
{
	WNComponent* component;
	CCARRAY_FOREACH(components_, component)
	{
		if (component.tag == tag)
		{
			break;
		}
	}
	
	return component;
}

-(void) removeComponentByTag:(int)tag
{
	WNComponent* component;
	CCARRAY_FOREACH(components_, component)
	{
		if (component.tag == tag)
		{
			[components_ fastRemoveObject:component];
			break;
		}
	}
}

-(WNComponent*) getComponentByClass:(Class)class
{
	WNComponent* componentFound = nil;
	
	WNComponent* component;
	CCARRAY_FOREACH(components_, component)
	{
		if ([component isKindOfClass:class])
		{
			componentFound = component;
			break;
		}
	}
	
	return componentFound;
}

-(NSString*) getClassNameByAttributesString:(NSString*)attributesString
{
	NSString* className = nil;

	if ([attributesString hasPrefix:@"T@"])
	{
		NSArray* splitString = [attributesString componentsSeparatedByString:@","];
		for (NSString* string in splitString)
		{
			className = [string substringWithRange:NSMakeRange(3, [string length] - 4)];
			break;
		}
	}
	
	return className;
}

/** How Component Injection works:
 - check all properties of the component
 - find properties which are pointers (prefix: T@)
 - get the Class of this property type, check if it implements WNComponentProtocol
 - try to find a component in entity of that Class
 - if found: inject the component by assigning the pointer to it directly to the iVar with the same name as the property
 - if not found: throw exception that requested component is not part of the entity
 */
-(void) tryInjectComponents:(WNComponent*)component
{
	unsigned int count;
	objc_property_t* properties = class_copyPropertyList([component class], &count);
	for (unsigned int i = 0; i < count; i++)
	{
		objc_property_t property = properties[i];
		
		NSString* attributesString = [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding];
		NSString* className = [self getClassNameByAttributesString:attributesString];
		
		Class class = NSClassFromString(className);
		if ([class conformsToProtocol:@protocol(WNComponentProtocol)])
		{
			const char* propertyName = property_getName(property);

			WNComponent* requestedComponent = [self getComponentByClass:class];
			WNLOG(@"INJECT COMPONENT: %@.%@.%@ = %@", self, component, [NSString stringWithCString:propertyName encoding:NSASCIIStringEncoding], requestedComponent);
			
			if (requestedComponent == nil)
			{
				[NSException raise:NSInternalInconsistencyException 
							format:@"Property '%@' requested component '%@' to be injected which is not a component of %@!", propertyName, className, self];
			}
			
			// inject the requested component directly into the ivar (assuming property name & ivar name match)
			object_setInstanceVariable(component, propertyName, requestedComponent);
		}
	}

	free(properties);
}

-(void) initializeComponents
{
	WNComponent* component;
	CCARRAY_FOREACH(components_, component)
	{
		[component setOwnerOnInit:self];
		[self tryInjectComponents:component];
	}
	
	NSAssert(nodeComponent_ != nil, @"Entity does not have a node component! Add a WNNodeComponent or derived class.");

	// Second iteration is necessary to ensure all Components are properly initialized.
	CCARRAY_FOREACH(components_, component)
	{
		[component initializeComponent];
	}
}


#pragma mark CCNode Facade - Message Forwarding

// learn more about message forwarding in the Apple docs:
// http://developer.apple.com/iphone/library/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html

// get the method signature from the node object if WNEntity doesn't respond to the selector
-(NSMethodSignature*) methodSignatureForSelector:(SEL)aSelector
{
	NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature)
	{
		signature = [[self node] methodSignatureForSelector:aSelector];
    }
    return signature;
}

// call the node's message for all messages that WNEntity doesn't implement
// the entity basically behaves like a CCNode or any of its inherited classes
-(void) forwardInvocation:(NSInvocation*)anInvocation
{
    if ([[self node] respondsToSelector:[anInvocation selector]])
	{
		//WNLOG(@"Forward Invocation of: %@", NSStringFromSelector(anInvocation.selector));
        [anInvocation invokeWithTarget:[self node]];
	}
    else
	{
        [super forwardInvocation:anInvocation];
	}
}

-(void) removeEntity
{
	[nodeComponent_ retain];
	
	[components_ removeAllObjects];
	
	[nodeComponent_.node removeFromParentAndCleanup:YES];
	//[nodeComponent_ release];
	
	nodeComponent_ = nil;
}

@end
