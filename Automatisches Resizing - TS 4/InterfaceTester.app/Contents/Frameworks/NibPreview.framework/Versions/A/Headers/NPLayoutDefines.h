/*!
 @header
 NPLayoutDefines.h
 Created by max on 13.01.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */


/*!
 @abstract Specifies a direction for a computation or a property.
 */
typedef enum {
	NPLayoutHorizontal,
	NPLayoutVertical
} NPLayoutDirection;

/*!
 @abstract Border definitions used for layout specifications.
 */
typedef enum {
	NPLayoutLeftBorder		= 0,
	NPLayoutRightBorder		= 1,
	NPLayoutBottomBorder	= 2,
	NPLayoutTopBorder		= 3,
	NPLayoutBorderCount
} NPLayoutBorder;

/*!
 @abstract When iterating through all broders, this is the value to start with.
 */
#define NPLayoutMinBorder	NPLayoutLeftBorder

/*!
 @abstract When iterating through all broders, this is the value to end with.
 */
#define NPLayoutMaxBorder	NPLayoutTopBorder


/*!
 @abstract Border definition masks used for layout specifications.
 */
typedef enum {
	NPLayoutLeftBorderMask		= 1<<NPLayoutLeftBorder,
	NPLayoutRightBorderMask		= 1<<NPLayoutRightBorder,
	NPLayoutTopBorderMask		= 1<<NPLayoutTopBorder,
	NPLayoutBottomBorderMask	= 1<<NPLayoutBottomBorder
} NPLayoutBorderMask;

/*!
 @abstract Returns the position of a border of a rect.
 */
CGFloat NSRectGetBorder(NSRect rect, NPLayoutBorder border);

/*!
 @abstract Sets the position of a border of a rect.
 */
NSRect NSRectSetBorder(NSRect rect, NPLayoutBorder border, CGFloat position);

/*!
 @abstract Moves a border of a rect by offset.
 */
#define NSRectMoveBorder(__rect, __border, __offset)	\
				NSRectSetBorder((__rect), (__border), NSRectGetBorder((__rect), (__border)) + (__offset))

