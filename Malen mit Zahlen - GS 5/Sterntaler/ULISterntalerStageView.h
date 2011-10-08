//
//  ULISterntalerStageView.h
//  Sterntaler
//
//  Created by Uli Kusterer on 22.08.10.
//  Copyright 2010 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ULISprite.h"


@interface ULISterntalerStageView : NSView <ULISpriteDelegate>
{
	NSMutableArray*		mFallingObjects;
	ULISprite*			mPlayer;
	NSTimer*			mAnimationTimer;
	BOOL				mAreHandlingKeyRepeat;
}

-(void)	addCoinSprites: (NSInteger)numCoins;
-(void)	addBillSprites: (NSInteger)numBills;
-(void)	addMagpieSprites: (NSInteger)numMagpies;

-(void)	advanceAnimation: (NSTimer*)timer;

-(void)	drawOneSprite: (ULISprite*)currSprite inDirtyRect: (NSRect)dirtyRect;
-(void)	drawFallingObjectsInDirtyRect: (NSRect)dirtyRect;
-(void)	drawBackgroundInDirtyRect: (NSRect)dirtyRect;

@end
