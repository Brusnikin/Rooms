//
//  DevicesViewController.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "DevicesViewController.h"
#import "Device.h"

@interface DevicesViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

{
    NSString *deviceName;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentRoom.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    NSArray *unSorted = self.currentRoom.devices.allObjects;
    NSArray *sorted = [unSorted sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    Device *device = sorted[indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), 44.0);
    [button setTitle:@"Add New Device" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:button];
    
    return footerView;
}


#pragma mark - Actions

- (void)addNewDevice:(UIButton *)sender {
    [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Device Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   
                                                   if (deviceName.length) {
                                                       [Room currentRoom:self.currentRoom addDeviceWithName:deviceName];
                                                       [self.tableView reloadData];
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
    deviceName = textField.text;
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
