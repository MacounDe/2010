/*!
 @header
 NPLayoutTabStop.h
 Created by max on 29.11.09.
 
 @copyright 2009 Localization Suite. All rights reserved.
 */

/*!
 @abstract Object representing either an vertical or an horizontal tab stop.
 @discussion Tab stops form a graph by the largerTabStops property, determining the order of positions. Tabs not reachable by traversion the larger or smaller tab stops properties only are to be seen as independent from each other. However, as each tab graph must have exactly one minimal and one maximal element, any pair of tabs stops of the same grpah have a commom predecessor and a common successor. Also the graph must be acyclic. If these properties are violated, some algorithms might not work or throw an exception.
 */
@interface NPLayoutTabStop : NSObject <BLPropertyListSerialization>
{
	NSHashTable	*_cells;
	NSHashTable	*_constraints;
	CGFloat		_currentPosition;
	NSSet		*_largerTabs;
	CGFloat		_originalPosition;
	BOOL		_positionFixed;
	NSHashTable	*_smallerTabs;
	
	// Lazy deserialization
	NSArray		*_largerTabNames;
}

/*!
 @abstract Creates a new autoreleased tab stop with a given position.
 @discussion The returned tab stop has both the originalPosition and the currentPosition property set to position. The position is set to be not fixed.
 */
+ (id)tabStopWithPosition:(CGFloat)position;

/*!
 @abstract In the partially ordered set of tab stops, the set of directly larger tab stops.
 @discussion Represents a NSSet of NPLayoutTabStops. This is the primitive ordering for tab stops and determines the smallerTabStops property of the contained objects.
 */
@property(retain) NSSet *largerTabStops;

/*!
 @abstract Convenience method for adding a tab stop to the set of larger tab stops.
 @discussion If the passed tab stop is already in the set of larger tab stops, this method does nothing.
 */
- (void)addLargerTabStop:(NPLayoutTabStop *)tabStop;

/*!
 @abstract Convenience method for removing a tab stop from the set of larger tab stops.
 @discussion If the passed tab stop is not in the set of larger tab stops, this method does nothing.
 */
- (void)removeLargerTabStop:(NPLayoutTabStop *)tabStop;

/*!
 @abstract In the partially ordered set of tab stops, the set of directly smaller tab stops.
 @discussion Represents a NSSet of NPLayoutTabStops. This is convenience property only and is determined by the predecessor's largerTabStops properties only.
 */
@property(readonly) NSSet *smallerTabStops;

/*!
 @abstract Creates a enumerator for traversing the graph of tabs in order.
 @discussion Returns - beginning with the tab stop that is was derived from - all descending tab stops. The initial tab stop must be the minimal element of it's graph and therefor not have any smaller tab stops - otherwise an NSInternalInconsistencyException is thrown upon requesting the first object from the enumerator. The enumerator may also throw at any time if the graph of tabs is not sound in respect to the definition of a sound tab graph - see class description for details.
 */
- (NSEnumerator *)enumerator;

/*!
 @abstract The cells that are using this tab stop.
 @discussion The cells using this tab stop either as left, right, top or bottom end. This reference is defined by the cell using the tab stop, therefore this is just a convenience method for a weak property.
 */
@property(readonly) NSSet *attachedCells;

/*!
 @abstract The positon of the tab stop upon creation.
 @discussion Should not be changed afterwards and is therefore readonly.
 */
@property(readonly) CGFloat originalPosition;

/*!
 @abstract The position that has been assigned either manually or dynamically.
 */
@property(assign) CGFloat currentPosition;

/*!
 @abstract Whether the tab stop must stay at it's current position or not.
 */
@property(assign) BOOL positionIsFixed;

/*!
 @abstract The constraints using the tab stop.
 @discussion Elements are of class NPLayoutDistanceConstraint, this property is determined by the properties of the constraints and as such is read-only.
 */
@property(readonly) NSSet *attachedConstraints;

/*!
 @abstract The set of names of the tab stop.
 @discussion Within the containing layout each name is unique for this tab stop. Can only be read as the value of this property depends on the attached cells.
 */
@property(readonly) NSSet *names;

/*!
 @abstract The names of the tab stop joined into one unique name.
 */
@property(readonly) NSString *name;

/*!
 @abstract The name of the tab stop imposed by the attached cell.
 @discussion Throws if the cell is not attached to the tab stop.
 */
- (NSString *)nameForCell:(NPLayoutCell *)cell;

@end

