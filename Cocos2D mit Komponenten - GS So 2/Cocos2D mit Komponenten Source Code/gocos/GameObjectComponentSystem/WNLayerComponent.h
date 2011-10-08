//
//  WNLayerComponent.h
//
//  Created by Steffen Itterheim on 13.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "WNNodeComponent.h"

/** TODO: WNLayerComponent describe me! */
@interface WNLayerComponent : WNNodeComponent
{
	@private
	ccColor4B layerColor_;
}

@property (nonatomic) ccColor4B layerColor;

@end
