//
//  PlayMusicAction.m
//
//  Created by Steffen Itterheim on 30.01.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//  You're free to use, modify and redistribute this file as long as the Copyright notice is not changed
//

#import "PlayMusicAction.h"
#import "SimpleAudioEngine.h"


@interface PlayMusicAction (Private)
-(void) onMusicDone;
@end

@implementation PlayMusicAction

+(id) actionWithCapacity:(int)capacity
{
	return [[[self alloc] initWithCapacity:capacity] autorelease];
}

-(id) initWithCapacity:(int)capacity
{
	if ((self = [super init]))
	{
		currentFile = 0;
		musicFiles = [[NSMutableArray alloc] initWithCapacity:capacity];

		[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(onMusicDone)];
	}

	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	[musicFiles removeAllObjects];
	[musicFiles release];
	
	// receive no more notifications as this object is now deallocated
	[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:nil selector:nil];
	
	// stops current speech/music instantly if user switches screens or the action gets deallocated otherwise
	// comment this line if you would rather have the current speech/music play to the end (the next one, if any, will not be played)
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	
	[super dealloc];
}

-(void) addMP3File:(NSString*)mp3File
{
	[musicFiles addObject:mp3File];
}

-(void) onMusicDone
{
	isMusicPlaying = NO;
	currentFile++;
}

-(BOOL) isDone
{
	// no more files and last file stopped playing? Then we're done ...
	return (noMoreFiles && isMusicPlaying == NO);
}

-(void) step:(ccTime)delta
{
	NSAssert([musicFiles count] > 0, @"PlayMusicAction - no files in array!");

	// if we still have files and no music is playing, play the next music file
	noMoreFiles = (currentFile == [musicFiles count]);
	if (!noMoreFiles && isMusicPlaying == NO)
	{
		isMusicPlaying = YES;
		NSString* musicFile = [musicFiles objectAtIndex:currentFile];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:musicFile loop:NO];
	}
}

@end
