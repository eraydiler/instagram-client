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
#import "PureLayout.h"
#import "AFNetworking.h"
#import "PhotoModel.h"
#import "UIImageView+AFNetworking.h"

static NSString *CellIdentifier= @"CellIdentifier";

static NSString *const URL_BEGIN = @"https://api.instagram.com/v1/tags/";
static NSString *const URL_END = @"/media/recent?";
static NSString *const COUNT = @"&count=20";
static NSString *const ACCESS_TOKEN = @"&access_token=220265065.5c873e0.81643230ea8a479e9e1355d49529903a";

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL didSetupView;

@property(nonatomic, strong) UISearchBar *search;
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic, strong) UIView *containerView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property(nonatomic, strong) NSMutableArray *model;

@end

@implementation PhotosViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.tableView.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [self fetch];
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
    
    [self.tableView reloadData];
    
    self.search = [[SearchBar alloc]
                   initWithFrame:(CGRectMake(0, 0, [self screenWidth], 40.0))];
    
    [self.view addSubview:self.search];
    self.search.delegate = self;
    
    ///////////////
    [self.containerView addSubview:self.activityIndicator];
    [self.containerView addSubview:self.tableView];
    
    [self.view addSubview:self.containerView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)configureView {
    
    self.title = @"Instagram";
    
    [self.tableView registerClass:[PhotoTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped:)];
    [self.tableView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self screenHeight] - [self searchHeight] - [self navBarHeight] -20;
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
    [self fetch];
    [searchBar resignFirstResponder];
}

#pragma mark - Selectors

- (void)tableViewTapped: (UITapGestureRecognizer *)recognizer {
    [self.search resignFirstResponder];
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

#pragma mark - Helper Methods

- (void)configureCell:(PhotoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // configure photo cell
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = [self.model objectAtIndex:indexPath.row];
    
    // Get user
    NSDictionary *user = [dic objectForKey:@"user"];
    NSString *profilePicture = [user objectForKey:@"profile_picture"];
    NSString *userName = [user objectForKey:@"full_name"];
    cell.namelabel.text = userName;
    
    // Get profile picture
    NSURL *url = [NSURL URLWithString:profilePicture];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    __weak PhotoTableViewCell *weakCell = cell;
    [cell.profilePicture setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.profilePicture.image = image;
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
    
    // Get photo
    NSDictionary *images = [dic objectForKey:@"images"];
    NSDictionary *lowRes = [images objectForKey:@"low_resolution"];
    NSString *lowImage = [lowRes objectForKey:@"url"];
    url = [NSURL URLWithString:lowImage];
    request = [NSURLRequest requestWithURL:url];
    placeholderImage = [UIImage imageNamed:@"placeholder"];
    [cell.photo setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakCell.photo.image = image;
                                            [weakCell setNeedsLayout];
                                        } failure:nil];

    // Get time
    NSString *createdTime = [dic objectForKey:@"created_time"];
    NSTimeInterval interval = [createdTime doubleValue];;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy/MM/dd HH:mm";
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
}

- (void)fetch {
    
    NSString *tag = ([self.search.text isEqualToString:@""]) ? (@"car") : self.search.text;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@%@%@%@", URL_BEGIN, tag, URL_END, COUNT, ACCESS_TOKEN ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //             NSLog(@"JSON: %@", responseObject);
             
             NSDictionary *dic = (NSDictionary *)responseObject;
             NSArray *data = [dic objectForKey:@"data"];
             self.model = [data mutableCopy];
             [self.tableView reloadData];
             
             [self.activityIndicator stopAnimating];
             self.activityIndicator.hidden = YES;
             self.tableView.hidden = NO;
             
             //             NSDictionary *object = [data objectAtIndex:0];
             //             NSDictionary *user = [object objectForKey:@"user"];
             //             NSString *profile_picture = [user objectForKey:@"profile_picture"];
             //             NSString *full_name = [user objectForKey:@"full_name"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)searchHeight {
    return CGRectGetHeight(self.search.frame);
}

- (CGFloat)navBarHeight {
    return CGRectGetHeight(self.navigationController.navigationBar.frame);
}

- (void)showAlert:(NSString *)title forMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alert show];
}

// For testing
- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

@end
