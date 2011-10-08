//
//  WNPropertyLoader.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 15.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSceneLoader.h"
#import "WNPropertyLoader.h"

@interface WNPropertyLoader (Private)
-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent propertyObject:(id)propertyObject;
@end

@implementation WNPropertyLoader

+(id) loaderWithAttributes:(NSDictionary*)attributeDict parent:(id)parent propertyObject:(id)propertyObject
{
	return [[[self alloc] initWithAttributes:attributeDict parent:parent propertyObject:propertyObject] autorelease];
}

-(id) initWithAttributes:(NSDictionary*)attributeDict parent:(id)parent propertyObject:(id)propertyObject
{
	if ((self = [super init]))
	{
		NSAssert(parent != nil, @"parent is nil!");
		NSAssert(propertyObject != nil, @"propertyObject is nil!");
		
		parent_ = [parent retain];
		propertyObject_ = [propertyObject retain];
		
		for (id key in attributeDict)
		{
			CCLOG(@"\tAttribute: %@=%@", key, [attributeDict objectForKey:key]);
		}
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[propertyObject_ release];
	[parent_ release];
	
	[super dealloc];
}

#pragma mark Set Property
-(void) setInvocationArgument:(NSInvocation*)invocation type:(NSString*)type value:(NSString*)value
{
	const int argIndex = 2;
	
	if ([type isEqualToString:@"int"])
	{
		int number = [value intValue];
		[invocation setArgument:&number atIndex:argIndex];
	}
	else if ([type isEqualToString:@"bool"])
	{
		bool bit = [value boolValue];
		[invocation setArgument:&bit atIndex:argIndex];
	}
	else if ([type isEqualToString:@"float"])
	{
		float number = [value floatValue];
		[invocation setArgument:&number atIndex:argIndex];
	}
	else if ([type isEqualToString:@"double"])
	{
		double number = [value doubleValue];
		[invocation setArgument:&number atIndex:argIndex];
	}
	else if ([type isEqualToString:@"NSString"])
	{
		[invocation setArgument:&value atIndex:argIndex];
	}
	else if ([type isEqualToString:@"CGPoint"])
	{
		CGPoint point = CGPointFromString(value);
		[invocation setArgument:&point atIndex:argIndex];
	}
	else if ([type isEqualToString:@"CGSize"])
	{
		CGSize size = CGSizeFromString(value);
		[invocation setArgument:&size atIndex:argIndex];
	}
	else if ([type isEqualToString:@"CGRect"])
	{
		CGRect rect = CGRectFromString(value);
		[invocation setArgument:&rect atIndex:argIndex];
	}
	else
	{
		NSAssert2(nil, @"unsupported property type '%@' with value '%@' detected!", type, value);
	}
}

-(void) setProperty:(NSString*)propertyName attributes:(NSDictionary*)propertyAttributes
{
	NSString* selectorName = [NSString stringWithFormat:@"set%@:", propertyName];
	SEL propertySelector = NSSelectorFromString(selectorName);
	NSAssert2(propertySelector != nil, @"Selector %@ for property %@ not found!", selectorName, propertyName);

	NSString* type = [propertyAttributes objectForKey:@"type"];
	NSAssert(type != nil, @"Property type attribute not found in attribute list!");
	NSString* value = [propertyAttributes objectForKey:@"value"];
	NSAssert(value != nil, @"Property value attribute not found in attribute list!");

	if (propertySelector != nil && type != nil && value != nil)
	{
		NSMethodSignature* sig = [[propertyObject_ class] instanceMethodSignatureForSelector:propertySelector];
		NSAssert2(sig != nil, @"MethodSignature for object %@ and selector %@ is nil!", propertyObject_, selectorName);
		
		if (sig != nil)
		{
			NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
			NSAssert(invocation != nil, @"invocation is nil!");
			
			CCLOG(@"\tInvoke: %@%@ (%@)", selectorName, value, type);
			[invocation setTarget:propertyObject_];
			[invocation setSelector:propertySelector];
			[self setInvocationArgument:invocation type:type value:value];
			[invocation invoke];
		}
	}
}

#pragma mark XML Parsing
-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	CCLOG(@">> %@ didStartElement: %@", NSStringFromClass([self class]), elementName);
	[self setProperty:elementName attributes:attributeDict];
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	CCLOG(@"<< %@ didEndElement: %@", NSStringFromClass([self class]), elementName);
	
	if ([elementName isEqualToString:kPropertiesElementName])
	{
		[parser setDelegate:parent_];
	}
}

@end
