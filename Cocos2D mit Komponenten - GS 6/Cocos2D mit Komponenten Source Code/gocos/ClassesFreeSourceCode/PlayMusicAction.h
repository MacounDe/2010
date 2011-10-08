//
//  PlayMusicAction.h
//
//  Created by Steffen Itterheim on 30.01.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//  You're free to use, modify and redistribute this file as long as the Copyright notice is not changed
//

#import "cocos2d.h"

// plays a sequence of music files one after the other
@interface PlayMusicAction : CCAction
{
	unsigned int currentFile;
	NSMutableArray* musicFiles;
	bool isMusicPlaying;
	bool noMoreFiles;
}

+(id) actionWithCapacity:(int)capacity;
-(id) initWithCapacity:(int)capacity;

-(void) addMP3File:(NSString*)mp3File;

@end
