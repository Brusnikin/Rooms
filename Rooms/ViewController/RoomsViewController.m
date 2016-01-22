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
@property (nonatomic) NSArray *rooms;

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
    if (!self.rooms.count) {
        
        HTTPClient *client = [HTTPClient new];
        [client getRoomListFromServer:^(BOOL result) {
            //
        } onFailure:^(NSError *error) {
            //
        }];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        Room *room = self.rooms[indexPath.item];
        
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
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self renameRoom:indexPath];
}

- (void)deleteRoom:(UIButton *)sender fromCell:(RoomCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self deleteRoom:indexPath];
}




#pragma mark - UIAlertController



- (void)renameRoom:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename room" message:@"Enter new name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    UIAlertAction *rename = [UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       Room *room = self.rooms[indexPath.item];
                                                       [Room addNewRoomFromList:@{@"name" : roomName, @"id" : room.roomID}];
                                                   }];
    
    [alert addAction:cancel];
    [alert addAction:rename];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)deleteRoom:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete room" message:@"Do you really want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       [Room remove:self.rooms[indexPath.item]];
                                                   }];
    
    [alert addAction:cancel];
    [alert addAction:delete];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)addNewRoom {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Room Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   if (roomName.length) {
                                                       [Room addNewRoomFromList:@{@"name" : roomName, @"id" : [roomName MD5]}];
                                                   }
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
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


#pragma mark - Setters & Getters

- (NSArray *)rooms {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return _rooms = [self.roomDataSource.fetchedResultsController.fetchedObjects sortedArrayUsingDescriptors:sortDescriptors];
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
