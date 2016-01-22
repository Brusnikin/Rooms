//
//  Room.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Device;

NS_ASSUME_NONNULL_BEGIN

@interface Room : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (Room *)addNewRoomFromList:(NSDictionary *)list;
+ (void)currentRoom:(Room *)room addDeviceWithName:(NSString *)name;
+ (void)remove:(Room *)room;

@end

NS_ASSUME_NONNULL_END

#import "Room+CoreDataProperties.h"
