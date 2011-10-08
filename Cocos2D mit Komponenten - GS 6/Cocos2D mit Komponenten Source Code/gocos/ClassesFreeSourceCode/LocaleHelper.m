//
//  LocaleHelper.m
//
//  Created by Steffen Itterheim on 28.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "LocaleHelper.h"


static const NSString* supportedLanguages[MAX_Language] = {@"en", @"de"};
static ELanguage preferredLanguage = MAX_Language;
static ELanguage currentLanguage = MAX_Language;
static NSString* currentLanguageTable = @"English";


@interface LocaleHelper (Private)
@end

@implementation LocaleHelper

+(NSString*) getLanguageTable
{
	return currentLanguageTable;
}

+(ELanguage) getPreferredLanguage
{
	if (currentLanguage != MAX_Language)
	{
		return currentLanguage;
	}
	
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	
	for (NSString* language in languages)
	{
		for (int i = 0; i < MAX_Language; ++i)
		{
			NSString* supportedLanguage = (NSString*)supportedLanguages[i];
			
			if ([language isEqualToString:supportedLanguage])
			{
				preferredLanguage = (ELanguage)i;
				return preferredLanguage;
			}
		}
	}
	
	// return the first (default) language as fallback
	preferredLanguage = (ELanguage)0;
	return preferredLanguage;
}

+(void) setLanguage:(ELanguage)language
{
	currentLanguage = language;
	
	switch (language)
	{
		case kLanguageGerman:
			currentLanguageTable = @"German";
			break;
			
		default:
			currentLanguageTable = @"English";
			break;
	}
}

+(ELanguage) getCurrentLanguage
{
	return currentLanguage;
}

+(NSString*) getCurrentLanguageString
{
	NSString* languageString;
	
	switch (currentLanguage)
	{
		case kLanguageGerman:
			languageString = @"de";
			break;
			
		default:
			languageString = @"en";
			break;
	}
	
	return languageString;
}

@end
