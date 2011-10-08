/*!
 @header
 NPLayoutSolver.h
 Created by max on 15.01.10.
 
 @copyright 2010 Localization Suite. All rights reserved.
 */

@class NPLayoutEquation;

/*!
 @abstract The modes the solver can operate in.
 */
typedef enum {
	NPLayoutSolverMinimize,
	NPLayoutSolverMaximize
} NPLayoutSolverMode;

/*!
 @abstract A convenience interface to the lpsolve library using the datastructures from the NPLayout.
 */
@interface NPLayoutSolver : NSObject
{
	NSMutableSet		*_constraints;
	NPLayoutSolverMode	_mode;
	NSMapTable			*_tabSolution;
	NPLayoutEquation	*_targetFunc;
	CGFloat				_targetValue;
	NSMapTable			*_varSolution;
}

/*!
 @abstract Convenience allocator returning a new solver.
 */
+ (id)solver;

/*!
 @abstract The equations constraining the optimal solution space.
 @discussion Elements should be members of class NPLayoutEquation or NPLayoutOrderedSet.
 */
@property(retain) NSSet *constraints;

/*!
 @abstract Convenience for adding constraints to the set of equations.
 @discussion The passed objects should be members of class NPLayoutEquation or NPLayoutOrderedSet.
 */
- (void)addConstraints:(NSSet *)someConstraints;

/*!
 @abstract The target function which is subject to optimization.
 @discussion While the argument is a NPLayoutEquation, both it's type and the constant part will be ignored!
 */
@property(retain) NPLayoutEquation *targetFunction;

/*!
 @abstract The mode, the solver operates in.
 @discussion The default is NPLayoutSolverMinimize.
 */
@property(assign) NPLayoutSolverMode mode;

/*!
 @abstract Primary method, running the solver.
 @discussion Beforehand, all equations etc should be set appropriately. Afterwards, the solution will be set.
 @returns YES, if an optimal solution was found. NO otherwise.
 */
- (BOOL)run;

/*!
 @abstract The optimal solution for the target function.
 @discussion If the solver has not been run previously, this will be 0.
 */
@property(readonly) CGFloat targetValue;

/*!
 @abstract The optimal solutions for the tab stops in the equations.
 @discussion Returns a map table mapping from NPLayoutTabStop to NSNumbers hosting floats. If the solver has not been run previously, this will be nil.
 */
@property(readonly) NSMapTable *tabStopSolutions;

/*!
 @abstract The optimal solutions for the variables in the equations.
 @discussion Returns a map table mapping from NPLayoutEquationVariable to NSNumbers hosting floats. If the solver has not been run previously, this will be nil.
 */
@property(readonly) NSMapTable *variableSolutions;

@end
