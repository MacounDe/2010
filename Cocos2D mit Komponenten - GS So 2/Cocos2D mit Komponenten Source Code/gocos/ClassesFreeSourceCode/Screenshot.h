//
//  Screenshot.h
//
// original Screenshot code by manucorporat
// see: http://www.cocos2d-iphone.org/forum/topic/1722#post-19601

#import "cocos2d.h"

@interface Screenshot : NSObject {}

+(UIImage*) takeAsUIImage;
+(CCTexture2D*) takeAsTexture2D;
+(NSData*) takeAsPNG;

@end
