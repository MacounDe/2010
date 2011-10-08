#import "MyWindow.h"
#import "avTouchAppDelegate.h"
#import "avTouchViewController.h"
#import "avTouchController.h"

@implementation MyWindow

-(void) makeKeyAndVisible
{
    [super makeKeyAndVisible];
    
	if ( [[UIApplication sharedApplication] respondsToSelector:@selector(beginReceivingRemoteControlEvents)] )
	{
		NSLog( @"iPhone OS 4 detected; listening to remote control events" );
		[self becomeFirstResponder];
		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	}
	else
	{
		NSLog( @"iPhone OS 3 (or older) detected; not listening to remote control events" );
	}
}

#pragma mark -
#pragma mark Remote Control
#pragma mark -

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    avTouchAppDelegate* app = (avTouchAppDelegate*) [[UIApplication sharedApplication] delegate];
    avTouchController* ctrl = app.viewController.controller;
    
    switch ( event.subtype )
    {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [ctrl playButtonPressed:nil];
            break;
        default:
            break;
    }
}

@end
