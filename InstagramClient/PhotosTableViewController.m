//
//  PhotosTableViewController.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "MyCustomTableViewCell.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MyCustomTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%f", self.navigationController.navigationBar.bounds.size.height);
    return tableView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height;
}

#pragma mark - Helper Methods

- (void)configureCell:(MyCustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.namelabel.text = @"Mister Tester";
    cell.dateLabel.text = @"2 hours ago";
}

@end
