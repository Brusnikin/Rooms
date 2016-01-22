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
        
    [self saveInContext];
    
    return room;
}



+ (Room *)updateRoom:(Room *)room fromList:(NSDictionary *)list {
    
    room.name = list[@"name"];
    room.roomID = list[@"id"];
    
    return room;
}


+ (void)currentRoom:(Room *)room addDeviceWithName:(NSString *)name {
    
    [room addDevicesObject:[Device withName:name]];
    [self saveInContext];
}


+ (void)removeRoomAtIndex:(NSUInteger)index {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(self)];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    [context deleteObject:result[index]];
    
    [self saveInContext];
}


+ (Room *)currentRoom {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(self)];
    NSArray *rooms = [context executeFetchRequest:request error:&error];
    
    return rooms.lastObject;
}


+ (Room *)roomAtIndex:(NSUInteger)index {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass(self)];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSArray *rooms = [context executeFetchRequest:request error:&error];
    
    return rooms[index];
}


+ (void)saveInContext {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    
    if (![context save:&error]) {
        NSLog(@"ERROR save context: %@", error.description);
    }
}

@end
