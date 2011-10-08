//
//  Utilities.h
//
//  Created by Steffen Itterheim on 29.11.09.
//

#import "cocos2d.h"


static const int kDontCacheTexture = -666;

@interface Utilities : NSObject
{
}

+(int) getRandomNumberExceptFor:(int)except maxRand:(int)max;
+(void) removeChildrenAndPurgeUncachedTextures:(CCNode*)cleanupNode;

+(double) getAvailableBytes;
+(double) getAvailableKiloBytes;
+(double) getAvailableMegaBytes;

/* less accurate than the above code
+(unsigned int) getFreeBytes;
+(double) getFreeKiloBytes;
+(double) getFreeMegaBytes;
 */

@end
