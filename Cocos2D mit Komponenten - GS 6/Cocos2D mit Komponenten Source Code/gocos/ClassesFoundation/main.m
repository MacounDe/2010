//
//  main.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 23.04.10.
//  Copyright Steffen Itterheim 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WNFoundation.h"
#import "MyGameDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	// set the game delegate before application starts, so it can receive all WNGameDelegateProtocol messages
	[WNAppDelegate setGameDelegate:[MyGameDelegate gameDelegate]];

	// run the app with the provided general-purpose AppDelegate which handles a lot of tedious stuff for you
    int retVal = UIApplicationMain(argc, argv, nil, @"WNAppDelegate");
	
    [pool release];
    return retVal;
}
