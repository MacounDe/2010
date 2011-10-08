//
//  ULISprite.m
//  Sterntaler
//
//  Created by Uli Kusterer on 22.08.10.
//  Copyright 2010 Uli Kusterer. All rights reserved.
//

#import "ULISprite.h"


@implementation ULISprite

@synthesize frame = mFrame;	// Overriding setter below.
@synthesize secondsPerCell = mSecondsPerCell;
@synthesize cellAdvancement = mCellAdvancement;
@synthesize offsetPerCell = mOffsetPerCell;
@synthesize offsetPerLoop = mOffsetPerLoop;
@synthesize loopBackAndForth = mLoopBackAndForth;
@synthesize paused = mPaused;
@synthesize tag = mTag;
@synthesize limitRect = mLimitRect;
@synthesize delegate = mDelegate;


+(void)	checkForCollisionsOfSprites: (NSArray*)firstGroup withSprites: (NSArray*)secondGroup
{
	for( ULISprite* currFirstSprite in firstGroup )
	{
		for( ULISprite* currSecondSprite in secondGroup )
		{
			if( [currFirstSprite collidesWithSprite: currSecondSprite] )
			{
				id<ULISpriteDelegate>	del = [currFirstSprite delegate];
				if( [del respondsToSelector: @selector(sprite:collidedWithSprite:)] )
					[del sprite: currFirstSprite collidedWithSprite: currSecondSprite];
				else
				{
					del = [currSecondSprite delegate];
					if( [del respondsToSelector: @selector(sprite:collidedWithSprite:)] )
						[del sprite: currFirstSprite collidedWithSprite: currSecondSprite];
				}
			}
		}
	}
	
	for( ULISprite* currFirstSprite in firstGroup )
	{
		id<ULISpriteDelegate>	del = [currFirstSprite delegate];
		NSRect	limitRect = [currFirstSprite limitRect];
		if( NSIsEmptyRect(limitRect) )
			continue;
		NSRect	firstSpriteRect = [currFirstSprite frame];
		NSRect	visualRect = NSIntersectionRect(firstSpriteRect, limitRect );
		if( !NSEqualRects(visualRect, firstSpriteRect) )
		{
			if( [del respondsToSelector: @selector(spriteHitScreenEdge:)] )
				[del spriteHitScreenEdge: currFirstSprite];
			else
				[currFirstSprite setPaused: YES];
		}
	}
	
	for( ULISprite* currSecondSprite in secondGroup )
	{
		id<ULISpriteDelegate>	del = [currSecondSprite delegate];
		NSRect	limitRect = [currSecondSprite limitRect];
		if( NSIsEmptyRect(limitRect) )
			continue;
		NSRect	secondSpriteRect = [currSecondSprite frame];
		NSRect	visualRect = NSIntersectionRect(secondSpriteRect, limitRect );
		if( !NSEqualRects(visualRect, secondSpriteRect) )
		{
			if( [del respondsToSelector: @selector(spriteHitScreenEdge:)] )
				[[currSecondSprite delegate] spriteHitScreenEdge: currSecondSprite];
			else
				[currSecondSprite setPaused: YES];
		}
	}
}


-(id)	initWithImageNamed: (NSString*)baseName
{
	if(( self = [super init] ))
	{
		mAnimationCells = [[NSMutableArray alloc] init];
		mAnimationCellsR = [[NSMutableArray alloc] init];
		
		NSImage*	image2 = nil;
		NSImage*	image = [NSImage imageNamed: baseName];
		if( image )
		{
			[mAnimationCells addObject: image];
			image2 = [NSImage imageNamed: [baseName stringByAppendingString: @"R"]];
			if( image2 )
				[mAnimationCellsR addObject: image2];
			else
				[mAnimationCellsR addObject: image];
		}
		else
		{
			NSInteger	x = 1;
			do
			{
				NSString*	imageName = [NSString stringWithFormat: @"%@%ld", baseName, x++];
				image = [NSImage imageNamed: imageName];
				if( image )
				{
					[mAnimationCells addObject: image];
					image2 = [NSImage imageNamed: [imageName stringByAppendingString: @"R"]];
					if( image2 )
						[mAnimationCellsR addObject: image2];
					else
						[mAnimationCellsR addObject: image];
				}
			}
			while( image != nil );
		}
		
		mCellAdvancement = 1;
		
		if( [mAnimationCells count] > 0 )
		{
			mFrame.size = [[mAnimationCells objectAtIndex: 0] size];
		}
		
		mPauseAfterLoopCount = -1;
	}
	
	return self;
}


-(void)	dealloc
{
	DESTROY(mAnimationCells);
	DESTROY(mAnimationCellsR);
	
	[super dealloc];
}


-(NSImage*)	image
{
	return (mCellAdvancement < 0) ? [mAnimationCellsR objectAtIndex: mCurrentCellIndex] : [mAnimationCells objectAtIndex: mCurrentCellIndex];
}


-(void)	advance
{
	NSRect		oldFrame = mFrame;
	
	//UKLog( @"ADVANCE %@:", [[mAnimationCells objectAtIndex: 0] name] );
	//UKLog( @"\tcurrentCellIndex = %ld",mCurrentCellIndex);
	
	// Advance the cell counter:
	mCurrentCellIndex += abs(mCellAdvancement);
	if( mCurrentCellIndex >= [mAnimationCells count] || mCurrentCellIndex < 0 )	// At last (or first) cell?
	{
		if( mLoopBackAndForth )
		{
			//UKLog( @"\tcellAdvancement %ld -- > %ld",mCellAdvancement,-mCellAdvancement);
			mCellAdvancement = -mCellAdvancement;		// Go backwards again.
			mCurrentCellIndex -= 2 * mCellAdvancement;	// Correct for overshoot above *and* actually go back once.
			if( mCurrentCellIndex >= [mAnimationCells count] || mCurrentCellIndex < 0 )	// Still outta range? Some nit set loop back/forth on a 2-frame animation.
			{
				//UKLog( @"\t(overshot)",mCurrentCellIndex);
				 mCurrentCellIndex = 0;	// Fallback, go to first (and prolly only other) frame.
			}
			//UKLog( @"\tcurrentCellIndex = %ld",mCurrentCellIndex);
		}
		else
		{
			mCurrentCellIndex = 0;	// Wrap back to start.
			//UKLog( @"\tWrapping currentCellIndex = 0");
		}
			 
		// Move if animation requires this:
		if( mOffsetPerLoop.width != 0 || mOffsetPerLoop.height != 0 )
		{
			mFrame.origin.x += mOffsetPerLoop.width * (CGFloat)mCellAdvancement;
			mFrame.origin.y += mOffsetPerLoop.height * (CGFloat)mCellAdvancement;
			//UKLog( @"\tLoop end move = { %f, %f }",mOffsetPerLoop.width * (CGFloat)mCellAdvancement,mOffsetPerLoop.height * (CGFloat)mCellAdvancement);
		}
		
		if( mPauseAfterLoopCount > -1 )
		{
			mPauseAfterLoopCount--;
			//UKLog( @"\tpauseAfterLoopCount = %ld",mPauseAfterLoopCount);
		}
	}
	
	// Move if animation requires this:
	if( mOffsetPerCell.width != 0 || mOffsetPerCell.height != 0 )
	{
		mFrame.origin.x += mOffsetPerCell.width * (CGFloat)mCellAdvancement;
		mFrame.origin.y += mOffsetPerCell.height * (CGFloat)mCellAdvancement;
		//UKLog( @"\tCell move = { %f, %f }",mOffsetPerCell.width * (CGFloat)mCellAdvancement,mOffsetPerCell.height * (CGFloat)mCellAdvancement);
	}
	
	// Remember we did this, so an -advance: call can know not to call us:
	mLastCellAdvanceTime = [NSDate timeIntervalSinceReferenceDate];
	
	// Notify delegate:
	if( [mDelegate respondsToSelector: @selector(spriteNeedsRedraw:oldFrame:newFrame:)] )
		[mDelegate spriteNeedsRedraw: self oldFrame: oldFrame newFrame: mFrame];
	
	if( mPauseAfterLoopCount == 0 )
	{
		mPaused = YES;
		mPauseAfterLoopCount = -1;	// Reset to not pausing.
		//UKLog( @"\tLoop count hit 0. Pausing.");
	}
}


-(IBAction)	advance: (id)sender
{
	if( mCellAdvancement != 0 && !mPaused && [NSDate timeIntervalSinceReferenceDate] > (mLastCellAdvanceTime +mSecondsPerCell) )
		[self advance];
}


-(void)	setFrame: (NSRect)newFrame
{
	NSRect		oldFrame = mFrame;
	mFrame = newFrame;
	
	// Notify delegate:
	if( [mDelegate respondsToSelector: @selector(spriteNeedsRedraw:oldFrame:newFrame:)] )
		[mDelegate spriteNeedsRedraw: self oldFrame: oldFrame newFrame: mFrame];
}


-(void)	runOneAnimationLoop
{
	if( mCellAdvancement < 0 )
	{
		if( mPauseAfterLoopCount > 0 )
			mPauseAfterLoopCount--;
		else
			mCellAdvancement = 1;
	}
	
	if( mPauseAfterLoopCount < 0 )
		mPauseAfterLoopCount = 1;
	else
		mPauseAfterLoopCount++;
	
	mPaused = (mPauseAfterLoopCount < 1);
}


-(void)	runOneAnimationLoopBackwards
{
	if( mCellAdvancement > 0 )
	{
		if( mPauseAfterLoopCount > 0 )
			mPauseAfterLoopCount--;
		else
			mCellAdvancement = -1;
	}
	
	if( mPauseAfterLoopCount < 0 )
		mPauseAfterLoopCount = 1;
	else
		mPauseAfterLoopCount++;
	
	mPaused = (mPauseAfterLoopCount < 1);
}


-(BOOL)	collidesWithSprite: (ULISprite*)otherSprite
{
	// Probably the most inefficient pixel-precise hit testing code ever written:
	
	NSRect		selfFrame = [self frame];
	NSRect		otherFrame = [otherSprite frame];
	NSRect		intersectionRect = NSIntersectionRect(selfFrame, otherFrame);
	if( !NSIsEmptyRect(intersectionRect) )	// If rects aren't even close, don't bother looking at pixels.
	{
		// Grab those parts of both sprites' images that overlap:
		NSRect		selfLocalPartBox = NSOffsetRect(intersectionRect,-selfFrame.origin.x,-selfFrame.origin.y);
		[[self image] lockFocus];
			NSBitmapImageRep	*selfPart = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: selfLocalPartBox] autorelease];
		[[self image] unlockFocus];
		
		NSRect		otherLocalPartBox = NSOffsetRect(intersectionRect,-otherFrame.origin.x,-otherFrame.origin.y);
		[[otherSprite image] lockFocus];
			NSBitmapImageRep	*otherPart = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: otherLocalPartBox] autorelease];
		[[otherSprite image] unlockFocus];
		
		// Draw both images on top each other, one with SourceIn mode, which intersects them effectively:
		NSImage*	collidedImg = [[[NSImage alloc] initWithSize: intersectionRect.size] autorelease];
		[collidedImg lockFocus];
		[selfPart drawAtPoint: NSZeroPoint];
		[otherPart drawInRect: NSZeroRect fromRect: NSZeroRect operation: NSCompositeSourceIn fraction: 1.0 respectFlipped: YES hints: nil];
		[collidedImg unlockFocus];
		
		// Now take that image and look if it has any opaque pixels:
		NSRect				localRect = intersectionRect;
		localRect.origin = NSZeroPoint;
		CGImageRef			theImage = [collidedImg CGImageForProposedRect: &localRect context: nil hints: nil];
		NSBitmapImageRep*	collidedBIRep = [[[NSBitmapImageRep alloc] initWithCGImage: theImage] autorelease];
		for( int y = 0; y < intersectionRect.size.height; y++ )
		{
			for( int x = 0; x < intersectionRect.size.width; x++ )
			{
				if( [[collidedBIRep colorAtX: x y: y] alphaComponent] > 0.5 )
					return YES;
			}
		}

	}
	
	return NO;
}


-(NSString*)	description
{
	return [NSString stringWithFormat: @"%@<%p> \"%@\"", [self class], self, [[mAnimationCells objectAtIndex: 0] name]];
}

@end
