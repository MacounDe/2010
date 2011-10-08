//Step0 -> Step1
//
//Info.plist
//-: UIApplicationExitsOnSuspend
//+: UIBackgroundModes
//  + item0 = audio
//  
//-> Show = Crash





// CALevelMeter.mm
// +:
- (void)registerForBackgroundNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(pauseTimer)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resumeTimer)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_showsPeaks = YES;
		_channelNumbers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
		_vertical = NO;
		_useGL = YES;
		_meterTable = new MeterTable(kMinDBvalue);
		[self layoutSubLevelMeters];
		// ++++
        [self registerForBackgroundNotifications];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		_showsPeaks = YES;
		_channelNumbers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
		_vertical = NO;
		_useGL = YES;
		_meterTable = new MeterTable(kMinDBvalue);
		[self layoutSubLevelMeters];
		// ++++
        [self registerForBackgroundNotifications];
	}
	return self;
}

// ->Show = kein Crash mehr, aber keiner Remote Events etc.





//Step1 -> Step2
//avTouchAppDelegate:

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    // ++++
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	NSLog( @"yo" );
}

// ->Show = Statusbar Audio und Icon im Dock, aber keine Events kommen an
// ->Show = iPod übernimmt - letzte App gewinnt immer





// Step2 -> Step3
// MyWindow Klasse erläutern
// MainWindow.xib -> Klasse ist nicht mehr Window, sondern MyWindow
//
// ->Show = Remot reagiert, aber crash wegen OpenGL





 
// Step3 -> Step4
// avTouchController.mm

- (void)registerForBackgroundNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(inBackground)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(inForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void)inBackground {
    background = YES;
}

- (void)inForeground {
    background = NO;
}

// awakefromnib:
// ++
[self registerForBackgroundNotifications];

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p {
	[p pause];
    if ( background )
    {
        [self updateViewForPlayerStateInBackground:p];
    }
    else
    {
        [self updateViewForPlayerState:p];
    }
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p {
	if ([p play])
	{
        if ( background )
        {
            [self updateViewForPlayerStateInBackground:p];
        }
        else
        {
            [self updateViewForPlayerState:p];
        }
	}
	else
		NSLog(@"Could not play %@\n", p.url);
}

// ->Show = Finale Fassung erreicht, auch im Lockscreen gibt es die Remote Steuerung / Headphones
