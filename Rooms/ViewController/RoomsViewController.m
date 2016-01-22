 //
//  RoomsViewController.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "RoomsViewController.h"
#import "DevicesViewController.h"
#import "RoomDataSource.h"
#import "HTTPClient.h"
#import "Room.h"
#import "RoomCell.h"

#import "NSString+NSHash.h"

@interface RoomsViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, RoomCellDelegate>

{
    NSString *roomName;
}

@property (nonatomic) RoomDataSource *roomDataSource;
@property (nonatomic) UIAlertController *alertController;

@end

@implementation RoomsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showExtraActions:)];
    longPress.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:longPress];
    
    //init collectionView dataSource first
    if (!self.roomDataSource) {
        _roomDataSource = [[RoomDataSource alloc]initWithCollectionView:self.collectionView];
    }
    
    //check for exist rooms
    if (![Room currentRoom]) {
        [self getRoomList];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.collectionView reloadData];
}

- (void)getRoomList {
    
    HTTPClient *client = [HTTPClient new];
    
    [client getRoomListFromServer:^(BOOL result) {
        //
    } onFailure:^(NSError *error) {
        //
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect frame = collectionView.frame;
    CGFloat side = CGRectGetWidth(frame) / 2.0;
    
    return CGSizeMake(side - 0.5, side - 1);
}


#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[collectionView cellForItemAtIndexPath:indexPath].reuseIdentifier isEqualToString:roomCellID]) {
        
        Room *room = [Room roomAtIndex:indexPath.item];
        
        DevicesViewController *deviceController = [self.storyboard instantiateViewControllerWithIdentifier:@"DevicesViewController"];
        deviceController.title = room.name;
        deviceController.currentRoom = room;
        
        [self.navigationController pushViewController:deviceController animated:YES];
        
    } else {
        [self addNewRoom];
    }
}



#pragma mark - UILongPressGestureRecognizer

- (void)showExtraActions:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint p = [sender locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if ([[self.collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[RoomCell class]]) {
        RoomCell *cell = (RoomCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.delegate = self;
        
        [UIView animateWithDuration:0.35 animations:^{
            cell.extraMenuPosition.constant = 0.0;
            [cell layoutIfNeeded];
        }];
    }
}


#pragma mark - RoomCellDelegate

- (void)renameRoom:(UIButton *)sender fromCell:(RoomCell *)cell {
    
    //__weak typeof(self) weakSelf = self;
    
   [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
       cell.extraMenuPosition.constant = -60.0;
       [cell layoutIfNeeded];
   } completion:^(BOOL finished) {
       
   }];
}


- (void)deleteRoom:(UIButton *)sender fromCell:(RoomCell *)cell {
    
    [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.extraMenuPosition.constant = -60.0;
        [cell layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        NSUInteger index = [self.collectionView indexPathForCell:cell].item;
        [Room removeRoomAtIndex:index];
    }];
}



- (void)addNewRoom {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Room Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   [Room addNewRoomFromList:@{@"name" : roomName, @"id" : [roomName MD5]}];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    roomName = textField.text;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
