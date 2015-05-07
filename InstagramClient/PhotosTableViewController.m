//
//  PhotosTableViewController.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoTableViewCell.h"
#import "SearchTableViewCell.h"

static NSString *CellIdentifierSearch = @"SearchCellIdentifier";
static NSString *CellIdentifierPhoto = @"PhotoCellIdentifier";

@interface PhotosTableViewController ()
@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Instagram";
    
    [self.tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:CellIdentifierSearch];
    [self.tableView registerClass:[PhotoTableViewCell class] forCellReuseIdentifier:CellIdentifierPhoto];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ?  1 :  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
   
    if (indexPath.section == 0) {
        cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierSearch forIndexPath:indexPath];
    } else {
    cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierPhoto forIndexPath:indexPath];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%f", self.navigationController.navigationBar.bounds.size.height);
    return tableView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height;
}

#pragma mark - Helper Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // configure search cell
        if (cell == nil) {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSearch];
        }
    } else { // configure photo cell
        if (cell == nil) {
            cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPhoto];
            
        }
        PhotoTableViewCell *photoCell = (PhotoTableViewCell *)cell;
        photoCell.namelabel.text = @"Mister Tester";
        photoCell.dateLabel.text = @"2 hours ago";
    }
}

/*
 if (cell == nil) {
 
 cell = [[[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 } else {
 
 cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 cell.namelabel.text = @"Mister Tester";
 cell.dateLabel.text = @"2 hours ago";
 }

 */

@end
