//
//  WNEntityPool.m
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNEntityPool.h"
#import "WNEntity.h"


@interface WNEntityPool (Private)
-(void) addEntity:(WNEntity*)entity;
@end

@implementation WNEntityPool

-(id) init
{
	if ((self = [super init]))
	{
		entities_ = [[CCArray alloc] initWithCapacity:30];
	}
	
	return self;
}

+(id) pool
{
	return [[[self alloc] init] autorelease];
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[entities_ release];

	[super dealloc];
}

#pragma mark Create Entity
-(WNEntity*) createEntity;
{
	WNEntity* entity = [WNEntity entity];
	[self addEntity:entity];
	return entity;
}

-(WNEntity*) createEntityWithComponents:(WNComponent*)component1, ...
{
	WNEntity* entity = [self createEntity];
	
	va_list list;
	va_start(list, component1);
	
	WNComponent* component = component1;
	while (component)
	{
		[entity addComponent:component];
		component = va_arg(list, WNComponent*);
	}
	
	va_end(list);
	
	[entity initializeComponents];
	
	return entity;
}

-(WNEntity*) createEntityWithComponentsArray:(CCArray*)components
{
	WNEntity* entity = [self createEntity];
	
	WNComponent* component;
	CCARRAY_FOREACH(components, component)
	{
		[entity addComponent:component];
	}
	
	[entity initializeComponents];
	
	return entity;
}

#pragma mark Add Entity
-(void) addEntity:(WNEntity*)entity
{
	NSAssert(entity != nil, @"entity is nil!");
	[entities_ addObject:entity];
}

#pragma mark Get Entity
-(WNEntity*) getEntityByTag:(int)tag
{
	WNEntity* entity = nil;
	CCARRAY_FOREACH(entities_, entity)
	{
		if (entity.node.tag == tag)
		{
			break;
		}
	}	
	
	return entity;
}

#pragma mark Remove Entity
-(void) removeEntity:(WNEntity*)entity
{
	if (entity != nil)
	{
		[entity removeEntity];
		[entities_ removeObject:entity];
	}
}

@end
