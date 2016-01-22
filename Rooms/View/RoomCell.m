//
//  RoomCell.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "RoomCell.h"

@implementation RoomCell


- (IBAction)renameRoom:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(renameRoom:fromCell:)]) {
        [self.delegate renameRoom:sender fromCell:self];
    }
}

- (IBAction)deleteRoom:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteRoom:fromCell:)]) {
        [self.delegate deleteRoom:sender fromCell:self];
    }
}



@end
