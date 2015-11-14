//
//  PhotosViewController.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotosViewController.h"
#import "INSPhotoTableViewCell.h"
#import "INSSearchBar.h"
#import "AFNetworking.h"
#import "INSPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "HelperModel.h"
#import "SVPullToRefresh.h"

static int initialPage = 1; // paging start from 1

static NSString *CellIdentifier= @"CellIdentifier";

static NSString *const URL_BEGIN = @"https://api.instagram.com/v1/tags/";
static NSString *const URL_END = @"/media/recent?";
static NSString *const COUNT = @"&count=20";
static NSString *const ACCESS_TOKEN = @"&access_token=220265065.5c873e0.81643230ea8a479e9e1355d49529903a";

@interface PhotosViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) BOOL didSetupView;
@property (nonatomic) BOOL didNewSearch;

@property (nonatomic, strong) UISearchBar              * search;
@property (nonatomic, strong) UITableView              * tableView;
@property (nonatomic, strong) UIView                   * containerView;
@property (nonatomic, strong) UIActivityIndicatorView  * activityIndicator;

// auto-complete
@property (nonatomic, strong) NSMutableArray           * autocompleteTags;
@property (nonatomic, strong) UITableView              * autocompleteTableView;
@property (nonatomic, strong) NSMutableArray           * pastTags;
@property (nonatomic, strong) NSString                 * searchText;

@property(nonatomic, strong) NSMutableArray            * photoModels;

// to keep track of what is the next page to load
@property (nonatomic, assign) int currentPage;

@end

@implementation PhotosViewController

- (void)viewWillAppear:(BOOL)animated {
    self.didSetupConstraints = NO;
    [self.view setNeedsUpdateConstraints];
}

- (void)configureView {
    
    self.title = @"Instagram";
    
    [self showActivityIndicator];
    [self loadFromInstagram: @""];
    
    // Pull to refresh
    __weak typeof(self) weakSelf = self;
    // refresh new data when pull the table list
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf showActivityIndicator];
        weakSelf.currentPage = initialPage; // reset the page
        [weakSelf.photoModels removeAllObjects]; // remove all data
        [weakSelf.tableView reloadData]; // before load new content, clear the existing table list
        [weakSelf loadFromInstagram: weakSelf.search.text]; // load new data
        [weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
        
        // once refresh, allow the infinite scroll again
        weakSelf.tableView.showsInfiniteScrolling = YES;
    }];
    
    // load more content when scroll to the bottom most
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSArray *tags = [weakSelf splitTags:weakSelf.search.text];
        for (NSString *tag in tags) {
            [weakSelf loadFromInstagram:tag];
        }
    }];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(addTapGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:tapRecognizer];
    
    // This prevents navigation bar from clicking issues.
    [tapRecognizer setCancelsTouchesInView:NO];
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
    // Main view
    self.view = [[UIView alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                                green:206.0/255.0
                                                 blue:206.0/255.0
                                                alpha:1.0];
    
    // Adding search bar to main view
    [self.view addSubview:self.search];
    
    // Adding indicator and table views to container view
    [self.containerView addSubview:self.activityIndicator];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.autocompleteTableView];
    
    // Adding container view to main view
    [self.view addSubview:self.containerView];
    
    // update constraints
    [self.view setNeedsUpdateConstraints];
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
        
        [self.autocompleteTableView autoSetDimension:ALDimensionHeight toSize:150.0];
        [self.autocompleteTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-10];
        [self.autocompleteTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
        [self.autocompleteTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
        
        [self.activityIndicator autoCenterInSuperview];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.autocompleteTableView) {
        return [self.autocompleteTags count];
    }
    
    return [self.photoModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.autocompleteTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        
        cell.textLabel.text = [self.autocompleteTags objectAtIndex:indexPath.row];
        cell.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        
        return cell;
    }
    
    INSPhotoTableViewCell *cell = (INSPhotoTableViewCell *)[tableView
                                                            dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.autocompleteTableView) {
        return 50.0;
    }
    
    NSLog(@"%f, %f, %f", [HelperModel screenHeight],
                         [HelperModel viewHeight:self.search],
                         [HelperModel viewHeight:self.navigationController.navigationBar]);
    
    return [HelperModel screenHeight] - [HelperModel viewHeight:self.search] - [HelperModel viewHeight:self.navigationController.navigationBar] -20;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INSPhotoTableViewCell *selectedCell = (INSPhotoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *profilePhoto = selectedCell.profilePicture.image;
    UIImage *photo = selectedCell.photoView.image;
    
    
    DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
    
    detailsVC.profilePhoto = profilePhoto;
    detailsVC.image = photo;
    
    INSPhoto *selectedObject = self.photoModels[indexPath.row];
    detailsVC.photoObject = selectedObject;
    
    // Go to details view controller
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.didNewSearch = YES;
    self.autocompleteTableView.hidden = YES;
    [self showActivityIndicator];
    
    // Add tags to the list of entered tags if they are not already there
    if (![self.pastUrls containsObject:searchBar.text]) {
        [self.pastUrls addObject:searchBar.text];
    }
    
    // Searching each tag
    NSArray *tags = [self splitTags:self.search.text];
    for (NSString *tag in tags) {
        [self loadFromInstagram:tag];
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.autocompleteTableView.hidden = YES;
    }
}

#pragma mark - UITextField delegate

// Handling search bar clear button
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.autocompleteTableView.hidden = YES;
    
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.autocompleteTags.count > 0) {
        self.autocompleteTableView.hidden = NO;
    }
    
    NSString *substring = [NSString stringWithString:searchBar.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:text];
    
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    return YES;
}

#pragma mark - Lazy Instantiations

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initForAutoLayout];
        _containerView.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                         green:237.0/255.0
                                                          blue:237.0/255.0
                                                         alpha:1.0];
    }
    
    return _containerView;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
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

- (UISearchBar *)search {
    if (!_search) {
        _search = [INSSearchBar newAutoLayoutView];
        _search.delegate = self;
    }
    
    return _search;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initForAutoLayout];
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[INSPhotoTableViewCell class]
               forCellReuseIdentifier:CellIdentifier];
    }
    
    return _tableView;
}

- (UITableView *)autocompleteTableView {
    if (!_autocompleteTableView) {
        _autocompleteTableView = [[UITableView alloc] initForAutoLayout];
        
        _autocompleteTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _autocompleteTableView.hidden = YES;
        _autocompleteTableView.allowsSelection = NO;
        _autocompleteTableView.delegate = self;
        _autocompleteTableView.dataSource = self;
        _autocompleteTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight
                                                  |UIViewAutoresizingFlexibleWidth;
        _autocompleteTableView.scrollEnabled = YES;
        _autocompleteTableView.layer.cornerRadius = 10;
        _autocompleteTableView.layer.masksToBounds = YES;
        
        [_autocompleteTableView registerClass:[UITableViewCell class]
                       forCellReuseIdentifier:CellIdentifier];
    }
    
    return _autocompleteTableView;
}

- (NSMutableArray *)autocompleteTags {
    if (!_autocompleteTags) {
        _autocompleteTags = [[NSMutableArray alloc] init];
    }
    
    return _autocompleteTags;
}

- (NSMutableArray *)pastUrls {
    if (!_pastTags) {
        _pastTags = [[NSMutableArray alloc] init];
    }
    
    return _pastTags;
}

- (NSString *)searchText {
    if (!_searchText) {
        _searchText = [[NSString alloc] init];
    }
    
    return _searchText;
}

#pragma mark - Helper Methods

- (void)configureCell:(INSPhotoTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    
    // configure photo cell
    if (cell == nil) {
        cell = [[INSPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    INSPhoto *photoModel = self.photoModels[indexPath.row];
    
    // Get user name
    if ([photoModel.fullName isEqualToString:@""]) {
        cell.namelabel.text = photoModel.userName;
    } else cell.namelabel.text = photoModel.fullName;
    
    // Get date
    cell.dateLabel.text = [self stringFromDate:photoModel.date];

    // Get profile picture
    NSURLRequest *request = [NSURLRequest requestWithURL:photoModel.profilePictureURL];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak INSPhotoTableViewCell *weakCell = cell;
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
                                   }
                                   failure:nil];
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

- (void)loadFromInstagram:(NSString *)tag {
    if ([tag isEqualToString:@""]) {
        tag = @"instagram";
    }
    
    
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
             
             // if seach is made from seach bar
             if (self.didNewSearch) {
                 [self.photoModels removeAllObjects];
                 self.didNewSearch = NO;
                 [self.tableView setContentOffset:CGPointMake(0.0f, -self.tableView.contentInset.top)
                                         animated:NO];
             }
             
             for (NSDictionary *dic in data) {
                 [self.photoModels addObject:[INSPhoto getPhotoModel:dic]];
             }
             
             // Shuffle photo models array
             [self shufflePhotoModels];
             
             [self.tableView reloadData];
             [self hideActivityIndicator];
             
             // clear the pull to refresh & infinite scroll, this 2 lines very important
             [self.tableView.pullToRefreshView stopAnimating];
             [self.tableView.infiniteScrollingView stopAnimating];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Fetch() Error: %@", error);
             
             id responseObject = operation.responseObject;
             NSDictionary *dic = (NSDictionary *)responseObject;
             NSArray *meta = [dic objectForKey:@"meta"];
             
             [self showAlert:[NSString stringWithFormat:@"Error with tag: %@", tag]
                  forMessage:[NSString stringWithFormat:@"%@ try to search different tags.",
                                                        [(NSDictionary *)meta objectForKey:@"error_message"]]];
             [self hideActivityIndicator];
         }];
}

- (void)showAlert:(NSString *)title
       forMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yy/MM/dd HH:mm";
    
    return [dateFormatter stringFromDate:date];
}

- (NSArray *)splitTags:(NSString *)tags {
    return [self.search.text componentsSeparatedByString:@" "];
}

- (void)shufflePhotoModels {
    NSUInteger count = [self.photoModels count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = (int)(count - i);
        int n = (int)((arc4random() % nElements) + i);
        [self.photoModels exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [self.autocompleteTags removeAllObjects];
    
    for(NSString *curString in self.pastUrls) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [self.autocompleteTags addObject:curString];
        }
    }
    
    [self.autocompleteTableView reloadData];
}

- (void)addTapGesture:(UITapGestureRecognizer *)recognizer {
    [self.search resignFirstResponder];
}

@end
