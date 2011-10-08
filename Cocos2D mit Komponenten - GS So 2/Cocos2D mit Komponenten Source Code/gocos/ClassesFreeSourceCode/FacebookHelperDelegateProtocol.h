/*
 *  FacebookHelperDelegateProtocol.h
 *
 *  Created by Steffen Itterheim on 20.03.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

@protocol FacebookHelperDelegate
-(void) onLoginDidSucceed:(FBDialog*)dialog;
-(void) onLoginDidCancel:(FBDialog*)dialog;
-(void) onLoginDidSucceed:(FBDialog*)dialog;
-(void) onLoginDidCancel:(FBDialog*)dialog;
@end
