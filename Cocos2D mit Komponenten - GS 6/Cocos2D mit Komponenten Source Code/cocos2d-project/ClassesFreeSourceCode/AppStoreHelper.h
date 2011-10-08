//
//  AppStoreHelper.h
//  MixMax
//
//  Created by Steffen Itterheim on 15.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//


@interface AppStoreHelper : NSObject 
{
}

+(NSString*) getAppStoreURLforSearchTerm:(NSString*)searchTerm;
+(NSString*) getAppDeveloperiTunesURL:(NSString*)artistURL;
//+(NSString*) getAppiPhoneAppStoreURL;

@end
