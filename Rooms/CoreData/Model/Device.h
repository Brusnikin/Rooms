//
//  Device.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface Device : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (Device *)withName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#import "Device+CoreDataProperties.h"
