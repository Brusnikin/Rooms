//
//  HTTPClient.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

@import Foundation;

@interface HTTPClient : NSObject

- (void)getRoomListFromServer:(void(^)(BOOL result)) success
                    onFailure:(void(^)(NSError *error)) failure;

@end
