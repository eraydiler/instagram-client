//
//  PhotosViewController.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoTableViewCell.h"
#import "SearchBar.h"
#import "AFNetworking.h"
#import "PhotoModel.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoDetailViewController.h"
#import "HelperModel.h"
#import "SVPullToRefresh.h"

static int initialPage = 1; // paging start from 1, depends on your api

static NSString *CellIdentifier= @"CellIdentifier";

static NSString *const URL_BEGIN = @"https://api.instagram.com/v1/tags/";
static NSString *const URL_END = @"/media/recent?";
static NSString *const COUNT = @"&count=20";
static NSString *const ACCESS_TOKEN = @"&access_token=220265065.5c873e0.81643230ea8a479e9e1355d49529903a";

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL didSetupView;

@property (nonatomic, strong) UISearchBar *search;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property(nonatomic, strong) NSMutableArray *photoModels;

// to keep track of what is the next page to load
@property (nonatomic, assign) int currentPage;

@end

@implementation PhotosViewController

- (void)viewWillAppear:(BOOL)animated {
    self.didSetupConstraints = NO;
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                                green:206.0/255.0
                                                 blue:206.0/255.0
                                                alpha:1.0];
    
//    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)
                                                  style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.search = [[SearchBar alloc]
                   initWithFrame:(CGRectMake(0, 0, [HelperModel screenWidth], 40.0))];
    
    [self.view addSubview:self.search];
    self.search.delegate = self;
    
    [self.containerView addSubview:self.activityIndicator];
    [self.containerView addSubview:self.tableView];
    
    [self.view addSubview:self.containerView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)configureView {
    
    self.title = @"Instagram";
    
    [self.tableView registerClass:[PhotoTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView setAllowsMultipleSelection:NO];
    
    [self showActivityIndicator];
    [self loadFromInsagram];
    
    __weak typeof(self) weakSelf = self;
    // refresh new data when pull the table list
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf showActivityIndicator];
        weakSelf.currentPage = initialPage; // reset the page
        [weakSelf.photoModels removeAllObjects]; // remove all data
        [weakSelf.tableView reloadData]; // before load new content, clear the existing table list
        [weakSelf loadFromInsagram]; // load new data
        [weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
        
        // once refresh, allow the infinite scroll again
        weakSelf.tableView.showsInfiniteScrolling = YES;
    }];
    
    // load more content when scroll to the bottom most
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFromInsagram];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photoModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self screenHeight] - [self searchHeight] - [self navBarHeight] -20;
    return [HelperModel screenHeight] - [HelperModel viewHeight:self.search] - [HelperModel viewHeight:self.navigationController.navigationBar] -20;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%li", (long)indexPath.row);
    
    PhotoTableViewCell *selectedCell = (PhotoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImage *photo = selectedCell.photoView.image;
    
    PhotoDetailViewController *photoVC = [[PhotoDetailViewController alloc] init];
    photoVC.photo = photo;
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.search autoSetDimension:ALDimensionHeight toSize:50.0];
        [self.search autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navigationController.navigationBar];
        [self.search autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.search autoPinEdgeToSuperviewEdge:ALEdgeRight];

        [self.containerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.search];
        [self.containerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.activityIndicator autoCenterInSuperview];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self showActivityIndicator];
    [self loadFromInsagram];
    [searchBar resignFirstResponder];
}

#pragma mark - Lazy Instantiations

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView newAutoLayoutView];
        _containerView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return _containerView;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.color = [UIColor blackColor];
    }
    return _activityIndicator;
}

- (NSMutableArray *)photoModels {
    if (!_photoModels) {
        _photoModels = [[NSMutableArray alloc] init];
    }
    return _photoModels;
}

#pragma mark - Helper Methods

- (void)configureCell:(PhotoTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    
    // configure photo cell
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
    }
    
    PhotoModel *photoModel = self.photoModels[indexPath.row];
    
    // Get user name
    cell.namelabel.text = photoModel.userName;
    
    // Get date
    cell.dateLabel.text = [self stringFromDate:photoModel.date];

    // Get profile picture
    NSURLRequest *request = [NSURLRequest requestWithURL:photoModel.profilePictureURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    __weak PhotoTableViewCell *weakCell = cell;
    [cell.profilePicture setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakCell.profilePicture.image = image;
                                            [weakCell setNeedsLayout];
                                        } failure:nil];

    
    // Get photo
    request = [NSURLRequest requestWithURL:photoModel.photoURL];
    placeholderImage = [UIImage imageNamed:@"placeholder"];
    [cell.photoView setImageWithURLRequest:request
                      placeholderImage:placeholderImage
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   weakCell.photoView.image = image;
                                   [weakCell setNeedsLayout];
                               } failure:nil];
}

- (void)showActivityIndicator {
    self.tableView.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)loadFromInsagram {
    
    NSString *tag = ([self.search.text isEqualToString:@""]) ? (@"instagram") : self.search.text;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@%@%@%@", URL_BEGIN, tag, URL_END, COUNT, ACCESS_TOKEN ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *dic = (NSDictionary *)responseObject;
             NSArray *data = [dic objectForKey:@"data"];
             
             if (data.count == 0) {
                 [self showAlert:@"Warning"
                      forMessage:@"No result found please make another search please"];
                 self.activityIndicator.hidden = YES;
                 return;
             }
             
             for (NSDictionary *dic in data) {
                 [self.photoModels addObject:[PhotoModel getPhotoModels:dic]];
             }
             
             [self.tableView reloadData];
             [self hideActivityIndicator];
             
             // clear the pull to refresh & infinite scroll, this 2 lines very important
             [self.tableView.pullToRefreshView stopAnimating];
             [self.tableView.infiniteScrollingView stopAnimating];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Fetch() Error: %@", error);
         }];
}

- (void)showAlert:(NSString *)title forMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alert show];
}

- (NSString *)stringFromDate: (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy/MM/dd HH:mm";
    return [dateFormatter stringFromDate:date];
}

@end
