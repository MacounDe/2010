//
//  WNEntityLoader.m
//
//  Created by Steffen Itterheim on 14.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponentLoader.h"
#import "WNEntity.h"
#import "WNEntityLoader.h"
#import "WNEntityPool.h"
#import "WNSceneLoader.h"
#import "WNPropertyLoader.h"


@interface WNEntityLoader (Private)
-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode;
-(void) createEntity;
@end

@implementation WNEntityLoader

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode
{
	return [[[self alloc] initWithAttributes:attributeDict parent:parent baseNode:baseNode] autorelease];
}

-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode
{
	if ((self = [super init]))
	{
		NSAssert(parent != nil, @"parent is nil!");
		NSAssert(baseNode != nil, @"baseNode is nil!");

		parent_ = [parent retain];
		baseNode_ = [baseNode retain];
		attributes_ = [attributeDict retain];

		[self createEntity];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[parent_ release];
	[baseNode_ release];
	[entity_ release];
	[attributes_ release];
	
	[super dealloc];
}

#pragma mark Create Entity
-(void) createEntity
{
	NSAssert(entity_ == nil, @"entity already created!");
	
	for (id key in attributes_)
	{
		CCLOG(@"\tAttribute: %@=%@", key, [attributes_ objectForKey:key]);
	}

	// create the entity and retain it while components are added to it
	//entity_ = [[[WNEntityPool sharedPool] createEntity] retain];
}

#pragma mark XML Parsing
-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	CCLOG(@">> %@ didStartElement: %@", NSStringFromClass([self class]), elementName);

	if ([elementName isEqualToString:kEntityElementName])
	{
		id loader = [[WNEntityLoader loaderWithAttributes:attributeDict parent:self baseNode:entity_.node] retain];
		[parser setDelegate:loader];
	}
	else if ([elementName isEqualToString:kComponentsElementName])
	{
		id loader = [WNComponentLoader loaderWithAttributes:attributeDict parent:self baseNode:baseNode_ owner:entity_];
		[parser setDelegate:loader];
	}
	else if ([elementName isEqualToString:kPropertiesElementName])
	{
		// FIXME: resolve the order dependency when loading from XML
		NSAssert1(entity_.nodeComponent != nil, @"A WNNodeComponent or derived class was not (yet) added to %@ entity! This indicates an element ordering problem in the XML, Components must always be loaded before Entity Properties!", entity_);
		id loader = [WNPropertyLoader loaderWithAttributes:attributeDict parent:self propertyObject:entity_.node];
		[parser setDelegate:loader];
	}
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	CCLOG(@"<< %@ didEndElement: %@", NSStringFromClass([self class]), elementName);
	
	if ([elementName isEqualToString:kEntityElementName])
	{
		[parser setDelegate:parent_];
	}
}

@end
