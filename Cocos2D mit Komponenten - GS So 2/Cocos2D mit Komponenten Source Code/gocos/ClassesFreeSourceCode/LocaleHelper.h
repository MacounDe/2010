//
//  LocaleHelper.h
//
//  Created by Steffen Itterheim on 28.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//


typedef enum
{
	kLanguageEnglish,
	kLanguageGerman,
	
	MAX_Language,
} ELanguage;


@interface LocaleHelper : NSObject
{
}

+(ELanguage) getPreferredLanguage;
+(void) setLanguage:(ELanguage)language;
+(NSString*) getLanguageTable;
+(ELanguage) getCurrentLanguage;
+(NSString*) getCurrentLanguageString;

@end
