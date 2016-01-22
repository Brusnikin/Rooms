//
//  RoomDataSource.h
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

@import Foundation;
@import CoreData;
@import UIKit;

extern NSString * const roomCellID;
extern NSString * const addCellID;

@interface RoomDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
