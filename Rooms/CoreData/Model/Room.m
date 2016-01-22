//
//  Room.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "Room.h"
#import "Device.h"
#import "CDManager.h"

@implementation Room

+ (Room *)addNewRoomFromList:(NSDictionary *)list {
    
    NSError *error = nil;
    Room *room = nil;

    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(self)];
    
    NSString *roomID = list[@"id"];
    request.predicate = [NSPredicate predicateWithFormat:@"roomID = %@", roomID];
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (error || !result) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else if (result.firstObject) {
        
        room = result.firstObject;
        [self updateRoom:room fromList:list];
        
    } else {
        room = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        [self updateRoom:room fromList:list];
    }
        
    [self saveInContext:context];
    
    return room;
}




+ (void)updateRoom:(Room *)room fromList:(NSDictionary *)list {
    
    room.name = list[@"name"];
    room.roomID = list[@"id"];
}


+ (void)currentRoom:(Room *)room addDeviceWithName:(NSString *)name {
    
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    [room addDevicesObject:[Device withName:name]];
    [self saveInContext:context];
}



+ (void)remove:(Room *)room {
    
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    [context deleteObject:room];
    [self saveInContext:context];
}


+ (void)saveInContext:(NSManagedObjectContext *)context {
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"ERROR save context: %@", error.description);
    }
}

@end
