//
//  SterntalerAppDelegate.h
//  Sterntaler
//
//  Created by Uli Kusterer on 21.08.10.
//  Copyright 2010 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ULISterntalerAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
