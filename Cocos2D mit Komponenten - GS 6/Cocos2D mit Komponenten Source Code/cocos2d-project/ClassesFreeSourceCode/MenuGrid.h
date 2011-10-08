//
//  MenuGrid.h
//
//  Created by Steffen Itterheim on 29.11.09.
//

#import "cocos2d.h"

typedef enum
{
	kMenuGridFillColumnsFirst,
	kMenuGridFillRowsFirst,
} EMenuGridFillStyle;

@interface MenuGrid : CCLayer <CCRGBAProtocol>
{
	MenuState state;
	CCMenuItem *selectedItem;
	
	CGPoint padding;

	// CCRGBAProtocol protocol
	GLubyte		opacity_;
	ccColor3B	color_;
}

// aligns items in grid, filling either rows or columns first before going to the next
+(id) menuWithArray:(NSMutableArray*)items fillStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit padding:(CGPoint)padding;
-(id) initWithArray:(NSMutableArray*)items fillStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit padding:(CGPoint)padding;

-(void) layoutWithStyle:(EMenuGridFillStyle)fillStyle itemLimit:(int)itemLimit;

@property (nonatomic, readwrite) CGPoint padding;

// CCRGBAProtocol protocol
@property (nonatomic,readonly) GLubyte opacity;
@property (nonatomic,readonly) ccColor3B color;

@end
