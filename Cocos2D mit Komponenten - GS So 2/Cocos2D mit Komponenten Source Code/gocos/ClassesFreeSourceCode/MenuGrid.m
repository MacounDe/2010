//
//  MenuGrid.m
//
//  Created by Steffen Itterheim on 29.11.09.
//
// Replacement for CCMenu that is easier to use and allows grid alignment
// Note: reuses a lot of code from CCMenu, so a lot of this code is *not* mine, specifically touch detection/handling

// EXAMPLE USE:
/*
self.anchorPoint = CGPointZero;
self.position = CGPointZero;

NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:51];
for (int i = 1; i <= MAX_CharacterTypes; ++i)
{
	// create a menu item for each character
	NSString* image = [NSString stringWithFormat:@"mc_button_%i", i];
	NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
	NSString* selectedImage = [NSString stringWithFormat:@"%@_aktiv.png", image];
	
	CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
	CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
	CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:selector];
	[allItems addObject:item];
}

MenuGrid* menuGrid = [MenuGrid menuWithArray:allItems fillStyle:kMenuGridFillColumnsFirst itemLimit:8 padding:CGPointMake(36.5f, 59.5f)];
menuGrid.anchorPoint = CGPointZero;
menuGrid.position = CGPointMake(32, 412);
[self addChild:menuGrid];
*/

#import "MenuGrid.h"

@interface MenuGrid (Private)
-(CCMenuItem*) itemForTouch:(UITouch*)touch;
@end

@implementation MenuGrid

@synthesize padding;

+(id) menuWithArray:(NSMutableArray*)items fillStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit padding:(CGPoint)pad
{
	return [[[self alloc] initWithArray:items fillStyle:fillStyle itemLimit:itemLimit padding:pad] autorelease];
}

-(id) initWithArray:(NSMutableArray*)items fillStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit padding:(CGPoint)pad
{
	if ((self = [super init]))
	{
		self.isTouchEnabled = YES;
		padding = pad;
		
		int z = 0;
		for (id item in items)
		{
			[self addChild:item z:z tag:z];
			++z;
		}
		
		[self layoutWithStyle:fillStyle itemLimit:itemLimit];
	}
	
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

	[super dealloc];
}

-(void) layoutWithStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit;
{
	int col = 0, row = 0, itemCount = 0;
	for (CCMenuItem* item in self.children)
	{
		CGPoint newPosition = CGPointMake(self.position.x + col * padding.x, self.position.y - row * padding.y);
		item.position = newPosition;
		++itemCount;

		if (fillStyle == kMenuGridFillColumnsFirst)
		{
			++col;
			if (itemCount == itemLimit)
			{
				itemCount = 0;
				col = 0;
				++row;
			}
		}
		else
		{
			++row;
			if (itemCount == itemLimit)
			{
				itemCount = 0;
				row = 0;
				++col;
			}
		}
	}
}

// copied from CCMenu
-(id) addChild:(CCMenuItem*)child z:(int)z tag:(int)aTag
{
	NSAssert([child isKindOfClass:[CCMenuItem class]], @"MenuGrid only supports MenuItem objects as children");
	return [super addChild:child z:z tag:aTag];
}

// copied from CCMenu
-(CCMenuItem*) itemForTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	for (CCMenuItem* item in [self children])
	{
		CGPoint local = [item convertToNodeSpace:touchLocation];
		
		CGRect r = [item rect];
		r.origin = CGPointZero;
		
		if (CGRectContainsPoint(r, local))
		{
			return item;
		}
	}
	
	return nil;
}

// touch events copied from CCMenu
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (state != kMenuStateWaiting)
	{
		return NO;
	}
	
	selectedItem = [self itemForTouch:touch];
	[selectedItem selected];
	
	if (selectedItem)
	{
		state = kMenuStateTrackingTouch;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
	[selectedItem unselected];
	[selectedItem activate];
	
	state = kMenuStateWaiting;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
	
	[selectedItem unselected];
	
	state = kMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [self itemForTouch:touch];
	
	if (currentItem != selectedItem)
	{
		[selectedItem unselected];
		selectedItem = currentItem;
		[selectedItem selected];
	}
}


// CCRGBAProtocol
@synthesize opacity=opacity_, color=color_;

-(void) setOpacity:(GLubyte)newOpacity
{
	opacity_ = newOpacity;
	for (id<CCRGBAProtocol> item in [self children])
	{
		[item setOpacity:opacity_];
	}
}

-(void) setColor:(ccColor3B)color
{
	color_ = color;
	for (id<CCRGBAProtocol> item in [self children])
	{
		[item setColor:color_];
	}
}

@end
