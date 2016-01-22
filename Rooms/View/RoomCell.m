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
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.extraMenuPosition.constant = -60.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(renameRoom:fromCell:)]) {
            [weakSelf.delegate renameRoom:sender fromCell:weakSelf];
        }
    }];
    
    
}

- (IBAction)deleteRoom:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.extraMenuPosition.constant = -60.0;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(deleteRoom:fromCell:)]) {
            [weakSelf.delegate deleteRoom:sender fromCell:weakSelf];
        }
    }];
}



@end
