//
//  WNEntityLoader.m
//
//  Created by Steffen Itterheim on 14.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNSceneLoader.h"

#import "WNEntityLoader.h"


@interface WNSceneLoader (Private)
@end

@implementation WNSceneLoader

static WNSceneLoader *instanceOfWNSceneLoader;

-(id) init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
	[instanceOfWNSceneLoader release];
	instanceOfWNSceneLoader = nil;

	[super dealloc];
}

#pragma mark parse mode

-(void) setDelegateForElement:(NSString*)element
{
	element = [element lowercaseString];
	
	if ([element isEqualToString:@"entity"])
	{
		
	}
	else if ([element isEqualToString:@"components"])
	{
	}
	else if ([element isEqualToString:@"properties"])
	{
	}
	else
	{
	}
}


#pragma mark elements collection

/*
-(void) newElementLoaderCollection
{
	NSAssert(elementLoaders == nil, @"elementLoaders already allocated!");
	elementLoaders = ccArrayNew(100);
}

-(void) freeElementLoaderCollection
{
	NSAssert(elementLoaders != nil, @"elementLoaders not allocated!");
	ccArrayFree(elementLoaders);
}

-(void) addToElementLoaderCollection:(id)entityLoader
{
	NSAssert(elementLoaders != nil, @"elementLoaders not allocated!");
	CCLOG(@"add element: %@", entityLoader);
	ccArrayAppendObjectWithResize(elementLoaders, entityLoader);
}

-(id) getLastObjectFromElementLoaderCollection
{
	NSAssert(elementLoaders != nil, @"elementLoaders not allocated!");
	id lastObject = nil;
	int lastIndex = elementLoaders->num;
	if (lastIndex > 0)
	{
		lastObject = elementLoaders->arr[lastIndex - 1];
	}
	
	return lastObject;
}

-(void) removeLastObjectFromElementLoaderCollection
{
	NSAssert(elementLoaders != nil, @"elementLoaders not allocated!");
	int lastIndex = elementLoaders->num;
	if (lastIndex > 0)
	{
		CCLOG(@"remove element: %@", [self getLastObjectFromElementLoaderCollection]);
		ccArrayFastRemoveObjectAtIndex(elementLoaders, lastIndex - 1);
	}
	else
	{
		CCLOG(@"no element left to remove!");
	}
}
*/

#pragma mark load XML

-(void) loadEntitiesFromXML:(NSString*)xmlFile baseNode:(CCNode*)baseNode
{
	NSAssert(loaderObject_ == nil, @"loaderObject is not nil before parse!");
	NSAssert(baseNode_ == nil, @"baseNode is not nil before parse!");
	NSAssert(baseNode != nil, @"baseNode is nil!");
	baseNode_ = [baseNode retain];

	NSString* fullPath = [CCFileUtils fullPathFromRelativePath:xmlFile];
	NSURL* fileURL = [NSURL fileURLWithPath:fullPath];
	NSAssert1([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NO], @"file %@ does not exist!", fullPath);
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser setDelegate:self];

	CCLOG(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PARSE XML <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
	[parser parse];
	CCLOG(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> END PARSE XML <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
	NSAssert2([parser parserError] == nil, @"XML Parse Error %@ in file: %@", [parser parserError], xmlFile);
	
	[parser release];
	[loaderObject_ release];
	loaderObject_ = nil;
	[baseNode_ release];
	baseNode_ = nil;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	CCLOG(@">> %@ didStartElement: %@", NSStringFromClass([self class]), elementName);

	if ([elementName isEqualToString:kEntityElementName])
	{
		[loaderObject_ release];
		loaderObject_ = [[WNEntityLoader loaderWithAttributes:attributeDict parent:self baseNode:baseNode_] retain];
		[parser setDelegate:loaderObject_];
	}
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	CCLOG(@"<< %@ didEndElement: %@", NSStringFromClass([self class]), elementName);

}

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfWNSceneLoader == nil, @"Attempted to allocate a second instance of the singleton: WNEntityLoader");
		instanceOfWNSceneLoader = [[super alloc] retain];
		return instanceOfWNSceneLoader;
	}
	
	// to avoid compiler warning
	return nil;
}

+(WNSceneLoader*) sharedLoader
{
	@synchronized(self)
	{
		if (instanceOfWNSceneLoader == nil)
		{
			[[WNSceneLoader alloc] init];
		}
		
		return instanceOfWNSceneLoader;
	}
	
	// to avoid compiler warning
	return nil;
}

@end
#