//
//  ULISterntalerStageView.m
//  Sterntaler
//
//  Created by Uli Kusterer on 22.08.10.
//  Copyright 2010 Uli Kusterer. All rights reserved.
//

#import "ULISterntalerStageView.h"
#import "ULISprite.h"


NSInteger	gNumCoins = 0;	// Also contains bills (as 10 coins).


@implementation ULISterntalerStageView

-(id)	initWithFrame: (NSRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
	{
		srand(time(NULL));
		
        mFallingObjects = [[NSMutableArray alloc] init];
		mPlayer = [[ULISprite alloc] initWithImageNamed: @"SterntalerWalkAnimation"];
		NSRect	theFrame = [mPlayer frame];
		theFrame.origin.y = frame.size.height * 0.1;
		theFrame.origin.x = frame.size.width / 2.0;
		[mPlayer setOffsetPerLoop: NSMakeSize(-12, 0)];
		[mPlayer setPaused: YES];
		[mPlayer setDelegate: self];
		[mPlayer setFrame: theFrame];
		
		[self addCoinSprites: 10];
		[self addBillSprites: 3];
		[self addMagpieSprites: 1];
		
		mAnimationTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.025 target: self selector: @selector(advanceAnimation:) userInfo: nil repeats: YES] retain];
		[[NSRunLoop currentRunLoop] addTimer: mAnimationTimer forMode: NSEventTrackingRunLoopMode];	// So game continues while menus are opened.
    }
    return self;
}


-(void)	dealloc
{
	DESTROY(mAnimationTimer);
	DESTROY(mFallingObjects);
	DESTROY(mPlayer);
	
	[super dealloc];
}


-(void)	addCoinSprites: (NSInteger)numCoins
{
	ULISprite*	currSprite = nil;
	NSSize		stageSize = [self bounds].size;
	NSRect		theLimitRect = [self bounds];
	theLimitRect.size.height *= 2.0;
	for( NSInteger x = 0; x < numCoins; x++ )
	{
		currSprite = [[[ULISprite alloc] initWithImageNamed: @"SterntalerCoin"] autorelease];
		NSRect	theFrame = [currSprite frame];
		theFrame.origin.x = rand() % (int)stageSize.width;
		theFrame.origin.y = stageSize.height +rand() % 100;
		[currSprite setFrame: theFrame];
		[currSprite setSecondsPerCell: 0.05];
		[currSprite setOffsetPerCell: NSMakeSize(0, -1 -(rand() % 5))];
		[currSprite setLimitRect: theLimitRect];
		[currSprite setTag: 1];	// We use tag for amount of currency added.
		[currSprite setDelegate: self];
		[mFallingObjects addObject: currSprite];
	}
}


-(void)	addBillSprites: (NSInteger)numBills
{
	ULISprite*	currSprite = nil;
	NSSize		stageSize = [self bounds].size;
	NSRect		theLimitRect = [self bounds];
	theLimitRect.size.height *= 2.0;
	for( NSInteger x = 0; x < numBills; x++ )
	{
		currSprite = [[[ULISprite alloc] initWithImageNamed: @"SterntalerBillAnimation"] autorelease];
		NSRect	theFrame = [currSprite frame];
		theFrame.origin.x = rand() % (int)stageSize.width;
		theFrame.origin.y = stageSize.height +rand() % 100;
		[currSprite setFrame: theFrame];
		[currSprite setSecondsPerCell: 0.2];
		[currSprite setOffsetPerCell: NSMakeSize(0, -1 -(rand() % 5))];
		[currSprite setLimitRect: theLimitRect];
		[currSprite setTag: 10];	// We use tag for amount of currency added.
		[currSprite setDelegate: self];
		[mFallingObjects addObject: currSprite];
	}
}


-(void)	addMagpieSprites: (NSInteger)numMagpies
{
	ULISprite*	currSprite = nil;
	NSSize		stageSize = [self bounds].size;
	NSRect		theLimitRect = [self bounds];
	theLimitRect.size.height *= 2.0;
	for( NSInteger x = 0; x < numMagpies; x++ )
	{
		currSprite = [[[ULISprite alloc] initWithImageNamed: @"SterntalerMaggieAnimation"] autorelease];
		NSRect	theFrame = [currSprite frame];
		theFrame.origin.x = rand() % (int)stageSize.width;
		theFrame.origin.y = stageSize.height +rand() % 100;
		[currSprite setFrame: theFrame];
		[currSprite setSecondsPerCell: 0.05];
		[currSprite setOffsetPerLoop: NSMakeSize(0, -8)];
		[currSprite setLimitRect: theLimitRect];
		[currSprite setTag: -1];	// We use tag for amount of currency added.
		[currSprite setDelegate: self];
		[mFallingObjects addObject: currSprite];
	}
}


-(void)	advanceAnimation: (NSTimer*)timer
{
	for( ULISprite* currSprite in mFallingObjects )
	{
		[currSprite advance: timer];
	}
	[mPlayer advance: timer];
	
	[ULISprite checkForCollisionsOfSprites: [NSArray arrayWithObject: mPlayer] withSprites: mFallingObjects];
}

-(void)	drawOneSprite: (ULISprite*)currSprite inDirtyRect: (NSRect)dirtyRect
{
	NSImage*	theImage = [currSprite image];
	[theImage drawInRect: [currSprite frame] fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.0];
}


-(void)	drawFallingObjectsInDirtyRect: (NSRect)dirtyRect
{
	for( ULISprite* currSprite in mFallingObjects )
	{
		[self drawOneSprite: currSprite inDirtyRect: dirtyRect];
	}
}


-(void)	drawBackgroundInDirtyRect: (NSRect)dirtyRect
{
    NSRect		bounds = [self bounds];
	
	#if !DO_NO_BACKGROUND
	NSColor		*darkBlue = [NSColor colorWithCalibratedRed:0.045 green:0.196 blue:0.503 alpha:1.000];
	[darkBlue set];
	[NSBezierPath fillRect: bounds];
	#endif
}


-(void)	drawGroundInDirtyRect: (NSRect)dirtyRect
{
    NSRect		bounds = [self bounds];
	NSRect		ground = bounds;
	ground.size.height = truncf(bounds.size.height * 0.1);
	NSPoint		lineStart = NSMakePoint( NSMinX(ground), NSMaxY(ground) );
	NSPoint		lineEnd = NSMakePoint( NSMaxX(ground), NSMaxY(ground) );
	
	NSColor *darkBrown = [NSColor colorWithCalibratedRed:0.391 green:0.220 blue:0.125 alpha:1.000];
	NSColor *lightBrown = [NSColor colorWithCalibratedRed:0.632 green:0.543 blue:0.416 alpha:1.000];
	
	#if DO_GRADIENT
	NSGradient*		floorGradient = [[[NSGradient alloc] initWithStartingColor: darkBrown endingColor: lightBrown] autorelease];
	[floorGradient drawInRect: ground angle: 90.0];
	#elif !DO_NO_BACKGROUND
	[lightBrown set];
	[NSBezierPath fillRect: ground];
	#endif
	
	[NSBezierPath setDefaultLineWidth: 1.0];
	[[NSColor blackColor] set];
	#if FIX_BETWEEN_PIXELS
	lineStart.x += 0.5;
	lineStart.y += 0.5;
	lineEnd.x += 0.5;
	lineEnd.y += 0.5;
	#endif
	[NSBezierPath strokeLineFromPoint: lineStart toPoint: lineEnd];
}


-(void)	drawMoneyAmountInDirtyRect: (NSRect)dirtyRect
{
	[NSGraphicsContext saveGraphicsState];
	NSShadow			*theShadow = [[[NSShadow alloc] init] autorelease];
	#if DO_GLOW
	[theShadow setShadowColor: [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.9]];
	[theShadow setShadowOffset: NSZeroSize];
	[theShadow setShadowBlurRadius: 10];
	#else
	[theShadow setShadowColor: [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.5]];
	[theShadow setShadowOffset: NSMakeSize(4,-4)];
	[theShadow setShadowBlurRadius: 4];
	#endif
	NSDictionary		*attrs = [NSDictionary dictionaryWithObjectsAndKeys:
													[NSFont systemFontOfSize: 36], NSFontAttributeName,
													[NSColor whiteColor], NSForegroundColorAttributeName,
													theShadow, NSShadowAttributeName,
													nil];
	NSString			*amountStr = [NSString stringWithFormat: @"%d", gNumCoins];
	NSAttributedString	*attrStr = [[NSAttributedString alloc] initWithString: amountStr attributes: attrs];
	NSPoint				pos = NSMakePoint(16, [self bounds].size.height -[attrStr size].height -8);
	[attrStr drawAtPoint: pos];
	[NSGraphicsContext restoreGraphicsState];
}


-(void)	drawRect: (NSRect)dirtyRect
{
    [self drawBackgroundInDirtyRect: dirtyRect];
	[self drawFallingObjectsInDirtyRect: dirtyRect];
	[self drawGroundInDirtyRect: dirtyRect];
	[self drawOneSprite: mPlayer inDirtyRect: dirtyRect];
	[self drawMoneyAmountInDirtyRect: dirtyRect];
}


-(BOOL)	acceptsFirstResponder
{
	return YES;
}


-(BOOL)	becomeFirstResponder
{
	return YES;
}


-(BOOL)	resignFirstResponder
{
	return YES;
}


-(void)	keyDown: (NSEvent*)evt
{
	mAreHandlingKeyRepeat = [evt isARepeat];
	[self interpretKeyEvents: [NSArray arrayWithObject: evt]];
}


-(void)	moveLeft: (id)sender
{
	if( !mAreHandlingKeyRepeat || [mPlayer paused] )	// Wait for current keypress to finish before accepting another key repeat.
		[mPlayer runOneAnimationLoop];
}


-(void)	moveRight: (id)sender
{
	if( !mAreHandlingKeyRepeat || [mPlayer paused] )	// Wait for current keypress to finish before accepting another key repeat.
		[mPlayer runOneAnimationLoopBackwards];
}


-(void)	spriteNeedsRedraw: (ULISprite*)sender oldFrame: (NSRect)oldFrame newFrame: (NSRect)newFrame
{
	[self setNeedsDisplay: YES];
}


-(void)	sprite: (ULISprite*)sender collidedWithSprite: (ULISprite*)otherSprite
{
	NSSize		stageSize = [self bounds].size;
	//if( [otherSprite tag] > 0 )
	{
		gNumCoins += [otherSprite tag];
		
		NSRect	theFrame = [otherSprite frame];
		theFrame.origin.x = rand() % (int)stageSize.width;
		theFrame.origin.y = stageSize.height +rand() % 100;
		[otherSprite setFrame: theFrame];
	}
}


-(void)	spriteHitScreenEdge: (ULISprite*)sender
{
	NSSize	stageSize = [self bounds].size;
	NSRect	theFrame = [sender frame];
	theFrame.origin.x = rand() % (int)stageSize.width;
	theFrame.origin.y = stageSize.height +rand() % 100;
	[sender setFrame: theFrame];
}

@end
