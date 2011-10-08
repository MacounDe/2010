//
//  AppStoreHelper.m
//  MixMax
//
//  Created by Steffen Itterheim on 15.02.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "AppStoreHelper.h"


@implementation AppStoreHelper

// Creates an App Store URL for the iPhone's App Store that shows the desired search term
// that seems to be the only way to show all the Apps of a particular company
// original code obtained from here:
// http://arstechnica.com/apple/news/2008/12/linking-to-the-stars-hacking-itunes-to-solicit-reviews.ars
+(NSString*) getAppStoreURLforSearchTerm:(NSString*)searchTerm
{
	NSString* escapedSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* url = @"http://phobos.apple.com/WebObjects/MZSearch.woa/wa/search?";
	NSString* urlParams = @"WOURLEncoding=ISO8859_1&lang=1&output=lm&country=US";
	return [NSString stringWithFormat:@"%@%@&term=%@&media=software", url, urlParams, escapedSearchTerm];
}

+(NSString*) getAppDeveloperiTunesURL:(NSString*)artistURL
{
	return [NSString stringWithFormat:@"http://itunes.apple.com/us/artist/%@", artistURL];
}

@end
