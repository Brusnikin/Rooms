//
//  RoomDataSource.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "RoomDataSource.h"
#import "CDManager.h"
#import "Room.h"
#import "RoomCell.h"
#import "addCell.h"

@interface RoomDataSource ()

@property (weak, nonatomic) UICollectionView *collectionView;

@end

NSString * const roomCellID = @"roomCell";
NSString * const addCellID = @"addCell";

@implementation RoomDataSource


- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    
    self = [super init];
    if (self) {
        
        self.collectionView = collectionView;
        collectionView.dataSource = self;
        
        [collectionView registerNib:[UINib nibWithNibName:@"RoomCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:roomCellID];
        [collectionView registerNib:[UINib nibWithNibName:@"addCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:addCellID];
        
    }
    return self;
}


#pragma mark - UICollectionViewDataSource




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex {
    id <NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return !section.numberOfObjects ? 1 : section.numberOfObjects + 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[indexPath.section];
    
    RoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:roomCellID forIndexPath:indexPath];
    
    if (section.numberOfObjects > indexPath.row) {
        
        Room *room = self.fetchedResultsController.fetchedObjects[indexPath.row];
        cell.name.text = room.name;
        cell.numberOfDevices.text = [NSString stringWithFormat:@"%lu devices", room.devices.count];
        cell.extraMenuPosition.constant = -60.0;
    }
    
    if (section.numberOfObjects <= indexPath.row) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:addCellID forIndexPath:indexPath];
    }
    
    return cell;
}



#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [CDManager sharedManager].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Room"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.fetchBatchSize = 10;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}

@end
