//
//  BundleHelper.h
//
//  Created by Steffen Itterheim on 22.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

@interface BundleHelper : NSObject {}

+(NSString*) getBundleVersion;
+(NSString*) getBundleCostumKey:(NSString*)key;
+(NSString*) getBundleIdentifier;
+(NSString*) getBundlePath;

+(NSString*) getDocumentsPathToFile:(NSString*)file;

@end
