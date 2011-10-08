//
//  WNEntityPool.h
//
//  Created by Steffen Itterheim on 13.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

@class WNComponent;
@class WNEntity;

/** Singleton for storing and accessing all WNEntity objects in the world */
@interface WNEntityPool : NSObject
{
@private

	// FIXME: use a dictionary instead?
	CCArray* entities_;
}

/** returns an autoreleased WNEntityPool object */
+(id) pool;

/** creates a new entity and adds it to the pool */
-(WNEntity*) createEntity;
/** creates a new entity with a given list of components, then initializes the components */
-(WNEntity*) createEntityWithComponents:(WNComponent*)component1, ...;
/** creates a new entity with a given list of components, then initializes the components */
-(WNEntity*) createEntityWithComponentsArray:(CCArray*)components;

/** returns an entity from the pool which the given tag value */
-(WNEntity*) getEntityByTag:(int)tag;

/** removes the entity from the pool and scene */
-(void) removeEntity:(WNEntity*)entity;

@end
