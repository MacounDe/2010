//
//  ShakeHelper.h
//
//  Created by Steffen Itterheim on 29.11.09.
//

#import "cocos2d.h"

@protocol ShakeHelperDelegate
-(void) onShake;
@end


@interface ShakeHelper : NSObject <UIAccelerometerDelegate>
{
	BOOL histeresisExcited;
	UIAcceleration* lastAcceleration;
	
	NSObject<ShakeHelperDelegate>* delegate;
}

+(id) shakeHelperWithDelegate:(NSObject<ShakeHelperDelegate>*)del;
-(id) initShakeHelperWithDelegate:(NSObject<ShakeHelperDelegate>*)del;

@end
