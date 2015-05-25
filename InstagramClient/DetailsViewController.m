//
//  DetailsViewController.m
//  InstagramClient
//
//  Created by Eray on 20/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "DetailsViewController.h"
#import "PhotoModel.h"
#import "PhotoDetailViewController.h"
#import "HelperModel.h"

@interface DetailsViewController ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *profilePicView;
@property (nonatomic, strong) UIImageView *heartView;
@property (nonatomic, strong) UILabel *fullName;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) UIButton *commentsButton;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic) int numberOfLikes;

@property (nonatomic) CGFloat navbarHeight;

@end

@implementation DetailsViewController

- (void)configureView {
    self.username.text = self.photoModel.userName;
    self.photoView.image = self.photo;
    self.profilePicView.image = self.profilePhoto;
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.photoModel.numbersOfLikes];
    
    // Add tap action to photo view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(photoTapped:)];
    [self.photoView addGestureRecognizer:tapRecognizer];
    [self.photoView setUserInteractionEnabled:YES];
    [tapRecognizer setCancelsTouchesInView:NO];
    
    // Add notifier
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    // Make profile pic circular
    [self makeProfileImageCircular];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                                green:206.0/255.0
                                                 blue:206.0/255.0
                                                alpha:1.0];
        
    [self.view addSubview:self.profilePicView];
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.heartView];
    [self.view addSubview:self.likesLabel];
    [self.view addSubview:self.commentsButton];
    [self.view addSubview:self.username];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    
    if (!_didSetupConstraints) {
        NSLog(@"%f %f", self.view.frame.size.width, self.view.frame.size.height);

        [self.profilePicView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navigationController.navigationBar];
        [self.profilePicView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.username autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.profilePicView];
        [self.username autoAlignAxisToSuperviewAxis:ALAxisVertical];

        [self.heartView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0];
        [self.heartView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
        
        [self.photoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.username];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        [self.likesLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.heartView];
        [self.likesLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.heartView withOffset:5.0];
        
        [self.commentsButton autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.likesLabel];
        [self.commentsButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark - Lazy Initializations

- (UIImageView *)profilePicView {
    if (!_profilePicView) {
        _profilePicView = [UIImageView newAutoLayoutView];
        _profilePicView.image = [UIImage imageNamed:@"placeholder.png"];
        [_profilePicView autoSetDimensionsToSize:CGSizeMake(100.0, 100.0)];

    }
    return _profilePicView;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [UIImageView newAutoLayoutView];
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    return _photoView;
}

- (UILabel *)fullName {
    if (!_fullName) {
        _fullName = [UILabel newAutoLayoutView];
    }
    return _fullName;
}

- (UILabel *)username {
    if (!_username) {
        _username = [UILabel newAutoLayoutView];
    }
    return _username;
}

- (UIImageView *)heartView {
    if (!_heartView) {
        _heartView = [UIImageView newAutoLayoutView];
        _heartView.image = [UIImage imageNamed:@"heart.png"];
        [_heartView autoSetDimensionsToSize:CGSizeMake(40.0, 40.0)];

    }
    return _heartView;
}

- (UILabel *)likesLabel {
    if (!_likesLabel) {
        _likesLabel = [UILabel newAutoLayoutView];
        _likesLabel.text = @"-";
        _likesLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
        _likesLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _likesLabel.layer.shadowOpacity = 1.0f;
        _likesLabel.layer.shadowRadius = 1.0f;
        _likesLabel.textColor  = [UIColor blackColor];
        
        //here is important!!!!
        _likesLabel.backgroundColor = [UIColor clearColor];
        _likesLabel.font = [UIFont systemFontOfSize:30];
    }
    return _likesLabel;
}

- (UIButton *)commentsButton {
    if (!_commentsButton) {
        _commentsButton = [UIButton new];
        [_commentsButton setTitle:@"Comments..." forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor colorWithRed:0.0 / 255.0
                                                       green:122.0 / 255.0
                                                        blue:255.0 / 255.0
                                                       alpha:1.0]
                              forState:UIControlStateNormal];
        [_commentsButton setTitleColor:[UIColor colorWithRed:0.0 / 255.0
                                                       green:122.0 / 255.0
                                                        blue:255.0 / 255.0
                                                       alpha:0.3]
                              forState:UIControlStateHighlighted];
        [_commentsButton addTarget:self
                            action:@selector(commentsTouched:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentsButton;
}

#pragma mark - selectors

- (void)commentsTouched:(UIButton *)sender {
    
}

- (void)photoTapped:(UITapGestureRecognizer *)recognizer {
    
    PhotoDetailViewController *photoDetailVC = [[PhotoDetailViewController alloc] init];
    photoDetailVC.photo = self.photo;
    
    // Go to details view controller
    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

#pragma Mark - Helper Methods

- (void)updateConstraints {
    self.didSetupConstraints = NO;
    [self.view setNeedsUpdateConstraints];
}

- (void) makeProfileImageCircular {
    self.profilePicView.layer.cornerRadius = 50 /*_view.frame.size.width / 2*/;
    self.profilePicView.clipsToBounds = YES;
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            //load the portrait view
            [self updateConstraints];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            //load the landscape view
            [self updateConstraints];
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

@end
