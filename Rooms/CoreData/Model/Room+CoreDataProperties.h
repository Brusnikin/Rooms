//
//  Room+CoreDataProperties.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@interface Room (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *roomID;
@property (nullable, nonatomic, retain) NSSet<Device *> *devices;

@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(Device *)value;
- (void)removeDevicesObject:(Device *)value;
- (void)addDevices:(NSSet<Device *> *)values;
- (void)removeDevices:(NSSet<Device *> *)values;

@end

NS_ASSUME_NONNULL_END
