//
//  ULISprite.h
//  Sterntaler
//
//  Created by Uli Kusterer on 22.08.10.
//  Copyright 2010 Uli Kusterer. All rights reserved.
//

/*
	A Sprite is a wrapper for a game object with a rectangle, an image, some
	simple behaviour and an (optional) animation. It also does collision
	detection.
	
	You simply give it a string for an image name. If there is an image with
	that name, it'll load an image with that name. Otherwise, it will look for
	a series of images named name1, name2, name3 etc.
*/

#import <Cocoa/Cocoa.h>


@class ULISprite;


@protocol ULISpriteDelegate <NSObject>

@optional
-(void)	spriteHitScreenEdge: (ULISprite*)sender;	// If you don't implement this, it will move up to the edge and stop there.

-(void)	sprite: (ULISprite*)sender collidedWithSprite: (ULISprite*)otherSprite;	// Provide this if you want something to happen on collisions.

-(void)	spriteNeedsRedraw: (ULISprite*)sender oldFrame: (NSRect)oldFrame newFrame: (NSRect)newFrame;		// Queue up a redraw in the view.

@end



@interface ULISprite : NSObject
{
	NSRect					mFrame;					// The frame rectangle in which we'll draw this sprite.
	NSInteger				mCurrentCellIndex;		// The index into mAnimationCells at which we are right now.
	NSMutableArray*			mAnimationCells;		// NSImages. The "frames" of the animation. We call them "cells" like in movies to prevent confusion with the frame rect.
	NSMutableArray*			mAnimationCellsR;		// NSImages. The "frames" of the animation. When we're animating backwards.
	NSTimeInterval			mSecondsPerCell;		// Frame rate of this sprite's animation.
	NSTimeInterval			mLastCellAdvanceTime;	// Last time a call to "advance" did something.
	NSInteger				mCellAdvancement;		// 1 for forward, -1 for backward.
	NSSize					mOffsetPerCell;			// How many pixels to move the frame per animation cell (needed for e.g. falling objects).
	NSSize					mOffsetPerLoop;			// How many pixels to move the frame per whole animation (needed for e.g. walking characters).
	BOOL					mLoopBackAndForth;		// Usually animation cells will be shown 1, 2, 3, 1, 2, 3. If this is YES it'll go 1, 2, 3, 2, 1.
	BOOL					mPaused;				// Pause animation and advancements of this animation.
	NSInteger				mPauseAfterLoopCount;	// Number of loops we still have to do before we should auto-pause again.
	NSInteger				mTag;					// Tag for private use of caller.
	NSRect					mLimitRect;				// Rectangle outside of which this sprite will wrap.
	id<ULISpriteDelegate>	mDelegate;				// Delegate that gets informed of happenings in a sprite.
}

@property (assign) NSRect					frame;
@property (assign) NSTimeInterval			secondsPerCell;
@property (assign) NSInteger				cellAdvancement;
@property (assign) NSSize					offsetPerCell;
@property (assign) NSSize					offsetPerLoop;
@property (assign) BOOL						loopBackAndForth;
@property (assign) BOOL						paused;
@property (assign) NSInteger				tag;
@property (assign) NSRect					limitRect;
@property (assign) id<ULISpriteDelegate>	delegate;

+(void)		checkForCollisionsOfSprites: (NSArray*)firstGroup withSprites: (NSArray*)secondGroup;

-(id)		initWithImageNamed: (NSString*)baseName;

-(NSImage*)	image;	// Image for the current cell.

-(IBAction)	advance: (id)sender;	// Checks mLastCellAdvanceTime/mSecondsPerCell and only calls -advance if needed.
-(void)		advance;				// Actually cause advancement.

-(void)		runOneAnimationLoop;
-(void)		runOneAnimationLoopBackwards;

-(BOOL)		collidesWithSprite: (ULISprite*)otheSprite;

@end
