/*!
 @header
 NPLayoutTabStopConstraint.h
 Created by max on 29.11.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

#import <NibPreview/NPLayoutConstraint.h>

@class NPLayoutTabStop;

/*!
 @abstract Object representing restricting the distance between two fixed tab stops.
 @discussion Restricts the distance of the current position of the minimum and maximum tab stop to be larger or equal to the minimum distance and smaller or equal to the maximum distance:
 
 minDistance <= maxTabStop.currentPosition - minTabStop.currentPosition <= maxDistance
 */
@interface NPLayoutTabStopConstraint : NPLayoutConstraint
{
	CGFloat			_maxDistance;
	NPLayoutTabStop	*_maxStop;
	CGFloat			_minDistance;
	NPLayoutTabStop	*_minStop;
}

/*!
 @abstract Creates a new constraint for a pair of tab stops.
 @discussion By default, neither a minimum nor a maximum distance is set.
 */
+ (id)constraintWithMinTabStop:(NPLayoutTabStop *)minStop andMaxTabStop:(NPLayoutTabStop *)maxStop;

/*!
 @abstract The min (smaller) tab stop.
 @discussion The max tab stop should be reachable form the min tab stop.
 */
@property(retain) NPLayoutTabStop *minTabStop;

/*!
 @abstract The max (larger) tab stop.
 @discussion The max tab stop should be reachable form the min tab stop.
 */
@property(retain) NPLayoutTabStop *maxTabStop;

/*!
 @abstract The minimal distance between the two tab stops.
 @discussion Setting this property to zero means no minimum.
 */
@property(assign) CGFloat minDistance;

/*!
 @abstract The maximal distance between the two tab stops.
 @discussion Setting this property to zero means no maximum.
 */
@property(assign) CGFloat maxDistance;

@end
