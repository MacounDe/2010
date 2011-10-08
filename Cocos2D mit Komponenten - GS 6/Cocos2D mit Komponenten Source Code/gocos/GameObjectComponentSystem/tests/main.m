//
//  main.m
//  cocos2d-project
//
//  Created by Steffen Itterheim on 23.04.10.
//  Copyright Steffen Itterheim 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"TestCase");
    [pool release];
    return retVal;
}
