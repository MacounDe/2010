#import "SpeakerToSpeakerPolicy.h"
#import "Speaker.h"

@implementation SpeakerToSpeakerPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)source 
                                      entityMapping:(NSEntityMapping *)mapping 
                                            manager:(NSMigrationManager *)manager 
                                              error:(NSError **)error 
{
   BOOL s = [super createDestinationInstancesForSourceInstance:source 
                                                 entityMapping:mapping 
                                                       manager:manager 
                                                         error:error];
   
   if(!s) {
      return NO;
   }
   
   NSArray *sourceArray = [NSArray arrayWithObject:source];
   NSArray *d = [manager destinationInstancesForEntityMappingNamed:[mapping name] 
                                                   sourceInstances:sourceArray];
      
   NSManagedObject *destinationInstance = [d lastObject];
   
      
   NSString *name = [source valueForKey:@"name"];
   NSString *firstName = @"";
   NSString *lastName = @"";
   NSRange rangeOfSpace = [name rangeOfString:@" "];
      
   if(rangeOfSpace.location == NSNotFound) {
      firstName = name;
   }
   else {
      firstName = [name substringToIndex:rangeOfSpace.location];
      lastName = [name substringFromIndex:rangeOfSpace.location + 1];
   }
      
   [destinationInstance setValue:firstName forKey:@"firstName"];
   [destinationInstance setValue:lastName forKey:@"lastName"];

   return YES;
}

@end
