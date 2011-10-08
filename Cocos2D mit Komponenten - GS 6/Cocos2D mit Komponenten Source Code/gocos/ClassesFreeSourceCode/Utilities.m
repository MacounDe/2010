//
//  Utilities.m
//
//  Created by Steffen Itterheim on 29.11.09.
//

#include <sys/sysctl.h>  
#import <mach/mach.h>
#import <mach/mach_host.h>

#import "Utilities.h"

#import "SimpleButton.h"


@interface Utilities (Private)
@end

@implementation Utilities

// returns a random number in the range 0 to (max - 1), excluding the number "except"
+(int) getRandomNumberExceptFor:(int)except maxRand:(int)max
{
	NSAssert(max > 1, @"getRandomNumberExceptFor requires maxRand > 1");
	int number;
	
	do
	{
		number = random() % max;
	}
	while (number == except);	// in the rare case that we got the "except" number, simply try again
	
	return number;
}

// helpful to remove only specific textures from the CCTextureCache
// this is only supposed to be called during dealloc!
+(void) removeChildrenAndPurgeUncachedTextures:(CCNode*)cleanupNode
{
	NSMutableArray* textures = [[NSMutableArray alloc] initWithCapacity:10];
	
	for (CCNode* node in cleanupNode.children)
	{
		if (![node isKindOfClass:[CCNode class]])
		{
			continue;
		}
		
		// look for the node tag
		if (node.tag == kDontCacheTexture)
		{
			if ([node isKindOfClass:[CCSprite class]])
			{
				CCSprite* s = (CCSprite*)node;
				[textures addObject:[s texture]];
			}
			else if ([node isKindOfClass:[SimpleButton class]])
			{
				SimpleButton* sb = (SimpleButton*)node;
				for (CCMenuItemSprite* item in sb.menu.children)
				{
					if ([item isKindOfClass:[CCMenuItemSprite class]])
					{
						CCSprite* sprite = (CCSprite*)[item normalImage];
						if (sprite)
						{
							[textures addObject:[sprite texture]];
						}
						
						sprite = (CCSprite*)[item selectedImage];
						if (sprite)
						{
							[textures addObject:[sprite texture]];
						}
						
						sprite = (CCSprite*)[item disabledImage];
						if (sprite)
						{
							[textures addObject:[sprite texture]];
						}
					}
				}
			}
			else
			{
				NSAssert(nil, @"removeChildrenAndPurgeUncachedTextures - kDontCacheTexture tag used on unsupported class type");
			}
		}
	}
	
	// remove all the children so we can safely remove the unused textures
	[cleanupNode removeAllChildrenWithCleanup:YES];
	
	for (CCTexture2D* texture in textures)
	{
		[[CCTextureCache sharedTextureCache] removeTexture:texture];
	}
	
	[textures removeAllObjects];
	[textures release];
}


// original code from here: http://developers.enormego.com/view/iphone_sdk_available_memory
+(double) getAvailableBytes
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if (kernReturn != KERN_SUCCESS)
	{
		return NSNotFound;
	}
	
	return (vm_page_size * vmStats.free_count);
}

+(double) getAvailableKiloBytes
{
	return [Utilities getAvailableBytes] / 1024.0;
}

+(double) getAvailableMegaBytes
{
	return [Utilities getAvailableKiloBytes] / 1024.0;
}

/* 
 this code seems to be less accurate than the above, it frequently reports more free memory
 the above code seems to be closer to the truth as it will show 3-4 free memory when
 receiving memory warnings compared to the code below where it triggers around 6-7 Mb supposedly free memory
 
// original code from here: http://adeem.me/blog/2009/04/01/get-the-amount-of-free-memory-available/
+(unsigned int) getFreeBytes
{
	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;
	host_port = mach_host_self();
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	host_page_size(host_port, &pagesize);
	vm_statistics_data_t vm_stat;
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
	{
		NSLog(@"Failed to fetch vm statistics");
		return 0;
	}
	
	// Stats in bytes
	natural_t mem_free = vm_stat.free_count * pagesize;
	return (unsigned int)mem_free;
}

+(double) getFreeKiloBytes
{
	return (double)([Utilities getFreeBytes] / 1024.0);
}

+(double) getFreeMegaBytes
{
	return (double)([Utilities getFreeKiloBytes] / 1024.0);
}
*/

@end
