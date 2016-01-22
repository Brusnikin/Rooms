//
//  RoomCell.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoomCellDelegate;
@interface RoomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDevices;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extraMenuPosition;

@property (weak, nonatomic) id <RoomCellDelegate> delegate;

@end


@protocol RoomCellDelegate <NSObject>

- (void)renameRoom:(UIButton *)sender fromCell:(RoomCell *)cell;
- (void)deleteRoom:(UIButton *)sender fromCell:(RoomCell *)cell;

@end