//
//  WNEntityLoader.h
//
//  Created by Steffen Itterheim on 14.06.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

static NSString* const kEntityElementName = @"Entity";
static NSString* const kComponentsElementName = @"Components";
static NSString* const kPropertiesElementName = @"Properties";


@class WNEntityLoader;

/** Singleton for loading entities from XML */
@interface WNSceneLoader : NSObject <NSXMLParserDelegate>
{
	@private
	id loaderObject_;
	CCNode* baseNode_;
}

/** returns the singleton object, like this: [WNEntityLoader sharedWNEntityLoader] */
+(WNSceneLoader*) sharedLoader;

/** load a hierarchy of entities from an xml file and initializes them */
-(void) loadEntitiesFromXML:(NSString*)xmlFile baseNode:(CCNode*)baseNode;

@end
