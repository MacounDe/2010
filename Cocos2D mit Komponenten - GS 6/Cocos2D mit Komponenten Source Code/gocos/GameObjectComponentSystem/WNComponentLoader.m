//
//  WNComponentLoader.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNComponentLoader.h"
#import "WNEntity.h"
#import "WNEntityLoader.h"
#import "WNEntityPool.h"
#import "WNSceneLoader.h"
#import "WNPropertyLoader.h"


@interface WNComponentLoader (Private)
-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode owner:(WNEntity*)owner;
@end

@implementation WNComponentLoader

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode owner:(WNEntity*)owner
{
	return [[[self alloc] initWithAttributes:attributeDict parent:parent baseNode:baseNode owner:owner] autorelease];
}

-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent baseNode:(CCNode*)baseNode owner:(WNEntity*)owner
{
	if ((self = [super init]))
	{
		NSAssert(parent != nil, @"parent is nil!");
		NSAssert(baseNode != nil, @"baseNode is nil!");
		NSAssert(owner != nil, @"owner is nil!");

		parent_ = [parent retain];
		baseNode_ = [baseNode retain];
		owner_ = [owner retain];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[owner_ release];
	[baseNode_ release];
	[parent_ release];
	
	[super dealloc];
}

#pragma mark Create Component
-(void) createComponent:(NSString*)componentClassName attributes:(NSDictionary*)attributes
{
	currentComponent_ = nil;
	
	Class componentClass = NSClassFromString(componentClassName);
	NSAssert1(componentClass != nil, @"component class %@ does not exist!", componentClassName);
	
	if (componentClass)
	{
		currentComponent_ = [componentClass componentWithEntity:owner_];
		if ([currentComponent_ isKindOfClass:[WNNodeComponent class]])
		{
			((WNNodeComponent*)currentComponent_).parent = baseNode_;
		}
	}
}

-(void) addComponent
{
	[currentComponent_ initializeComponent];
}

#pragma mark XML Parsing
-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	CCLOG(@">> %@ didStartElement: %@", NSStringFromClass([self class]), elementName);

	if ([elementName isEqualToString:kPropertiesElementName])
	{
		id loader = [WNPropertyLoader loaderWithAttributes:attributeDict parent:self propertyObject:currentComponent_];
		[parser setDelegate:loader];
	}
	else
	{
		[self createComponent:elementName attributes:attributeDict];
	}
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	CCLOG(@"<< %@ didEndElement: %@", NSStringFromClass([self class]), elementName);
	
	if ([elementName isEqualToString:kPropertiesElementName])
	{
		// do nothing
	}
	else if ([elementName isEqualToString:kComponentsElementName])
	{
		[parser setDelegate:parent_];
	}
	else
	{
		[self addComponent];
	}
}

@end
