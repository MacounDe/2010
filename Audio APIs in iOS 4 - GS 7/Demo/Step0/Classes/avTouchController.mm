/*
 
 File: avTouchController.mm
 Abstract: n/a
 Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 
 */


#import "avTouchController.h"
#include "CALevelMeter.h"

// amount to skip on rewind or fast forward
#define SKIP_TIME 1.0			
// amount to play between skips
#define SKIP_INTERVAL .2

@implementation avTouchController

@synthesize fileName;
@synthesize playButton;
@synthesize ffwButton;
@synthesize rewButton;
@synthesize volumeSlider;
@synthesize progressBar;
@synthesize currentTime;
@synthesize duration;
@synthesize lvlMeter_in;

@synthesize updateTimer;
@synthesize player;

@synthesize background;


void RouteChangeListener(	void *                  inClientData,
							AudioSessionPropertyID	inID,
							UInt32                  inDataSize,
							const void *            inData);
															
-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	progressBar.value = p.currentTime;
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];

	if (updateTimer) 
		[updateTimer invalidate];
		
	if (p.playing)
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
		[lvlMeter_in setPlayer:p];
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
		[lvlMeter_in setPlayer:nil];
		updateTimer = nil;
	}
	
}

- (void)updateViewForPlayerStateInBackground:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
	
	if (p.playing)
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
	}
	else
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
	}	
}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
	duration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
	progressBar.maximumValue = p.duration;
	volumeSlider.value = p.volume;
}

- (void)rewind
{
	AVAudioPlayer *p = rewTimer.userInfo;
	p.currentTime-= SKIP_TIME;
	[self updateCurrentTimeForPlayer:p];
}

- (void)ffwd
{
	AVAudioPlayer *p = ffwTimer.userInfo;
	p.currentTime+= SKIP_TIME;	
	[self updateCurrentTimeForPlayer:p];
}

- (void)awakeFromNib
{
	// Make the array to store our AVAudioPlayer objects
	soundFiles = [[NSMutableArray alloc] initWithCapacity:3];

	playBtnBG = [[UIImage imageNamed:@"play.png"] retain];
	pauseBtnBG = [[UIImage imageNamed:@"pause.png"] retain];

	[playButton setImage:playBtnBG forState:UIControlStateNormal];

	updateTimer = nil;
	rewTimer = nil;
	ffwTimer = nil;
	
	duration.adjustsFontSizeToFitWidth = YES;
	currentTime.adjustsFontSizeToFitWidth = YES;
	progressBar.minimumValue = 0.0;	
	
	// Load the array with the sample file
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"]];

	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];	
	if (self.player)
	{
		fileName.text = [NSString stringWithFormat: @"%@ (%d ch.)", [[player.url relativePath] lastPathComponent], player.numberOfChannels, nil];
		[self updateViewForPlayerInfo:player];
		[self updateViewForPlayerState:player];
		player.numberOfLoops = 1;
		player.delegate = self;
	}
	
	OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if (result)
		NSLog(@"Error initializing audio session! %d", result);
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
	if (setCategoryError)
		NSLog(@"Error setting category! %d", setCategoryError);
	
	result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
	if (result) 
		NSLog(@"Could not add property listener! %d", result);
	
	[fileURL release];
}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
	[self updateViewForPlayerState:p];
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
	if ([p play])
	{
		[self updateViewForPlayerState:p];
	}
	else
		NSLog(@"Could not play %@\n", p.url);
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
	if (player.playing == YES)
		[self pausePlaybackForPlayer: player];
	else
		[self startPlaybackForPlayer: player];
}

- (IBAction)rewButtonPressed:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(rewind) userInfo:player repeats:YES];
}

- (IBAction)rewButtonReleased:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = nil;
}

- (IBAction)ffwButtonPressed:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(ffwd) userInfo:player repeats:YES];
}

- (IBAction)ffwButtonReleased:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = nil;
}

- (IBAction)volumeSliderMoved:(UISlider *)sender
{
	player.volume = [sender value];
}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
	player.currentTime = sender.value;
	[self updateCurrentTimeForPlayer:player];
}

- (void)dealloc
{
	[super dealloc];
	
	[fileName release];
	[playButton release];
	[ffwButton release];
	[rewButton release];
	[volumeSlider release];
	[progressBar release];
	[currentTime release];
	[duration release];
	[lvlMeter_in release];
	
	[updateTimer release];
	[player release];
	
	[playBtnBG release];
	[pauseBtnBG release];	
}

#pragma mark AudioSession handlers

void RouteChangeListener(	void *                  inClientData,
							AudioSessionPropertyID	inID,
							UInt32                  inDataSize,
							const void *            inData)
{
	avTouchController* This = (avTouchController*)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];

		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {

			[This pausePlaybackForPlayer:This.player];
		}
	}
}

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
		
	[p setCurrentTime:0.];
	[self updateViewForPlayerState:p];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption begin. Updating UI for new state");
	// the object has already been paused,	we just need to update UI
    [self updateViewForPlayerState:p];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption ended. Resuming playback");
	[self startPlaybackForPlayer:p];
}

@end