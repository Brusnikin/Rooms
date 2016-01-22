//
//  Device.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "Device.h"
#import "CDManager.h"

@implementation Device

+ (Device *)withName:(NSString *)name {
    
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    Device *device = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    device.name = name;
        
    return device;
}



@end
