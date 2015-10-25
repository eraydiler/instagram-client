//
//  DetailsViewController.m
//  InstagramClient
//
//  Created by Eray on 20/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "DetailsViewController.h"
#import "INSPhoto.h"
#import "PhotoDetailViewController.h"
#import "HelperModel.h"
#import "INSDetailsView.h"

@interface DetailsViewController () < INSDetailsViewDelegate >

@property (nonatomic, strong) INSDetailsView *detailsView;

@end

@implementation DetailsViewController

- (void)configureView {
    _detailsView = [[INSDetailsView alloc] initForAutoLayout];
    
    _detailsView.username.text = self.photoObject.userName;
    _detailsView.photoView.image = self.image;
    _detailsView.profilePicView.image = self.profilePhoto;
    _detailsView.likesLabel.text = [NSString stringWithFormat:@"%d", self.photoObject.numbersOfLikes];
    
    [_detailsView setDelegate:self];
    
    [self.view addSubview:_detailsView];
    
    [_detailsView autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTop];
    [_detailsView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self updateConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)commentsTouched:(UIButton *)sender {
}

#pragma mark - Detail view delegate

- (void)detailView:(INSDetailsView *)detailView didTapPhotoView:(UIImageView *)photoView {
    PhotoDetailViewController *photoDetailVC = [[PhotoDetailViewController alloc] init];
    photoDetailVC.photoImage = self.image;
    
    // Go to details view controller
    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

@end
