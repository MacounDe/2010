//
//  BundleHelper.m
//
//  Created by Steffen Itterheim on 22.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "BundleHelper.h"

@implementation BundleHelper

+(NSString*) getBundleVersion
{
	return (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+(NSString*) getBundleCostumKey:(NSString*)key
{
	return (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

+(NSString*) getBundleIdentifier
{
	return (NSString*)[[NSBundle mainBundle] bundleIdentifier];
}

+(NSString*) getBundlePath
{
	return (NSString*)[[NSBundle mainBundle] bundlePath];
}

+(NSString*) getDocumentsPathToFile:(NSString*)file
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *filePath = [documents stringByAppendingPathComponent:file];
	return filePath;
}

@end
