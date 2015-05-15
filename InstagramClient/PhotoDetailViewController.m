//
//  PhotoViewController.m
//  InstagramClient
//
//  Created by Eray on 15/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PureLayout.h"
#import "HelperModel.h"

@interface PhotoDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *photoView;
@end

@implementation PhotoDetailViewController

- (void)configureView {
    self.photoView.image = self.photo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                                green:206.0/255.0
                                                 blue:206.0/255.0
                                                alpha:1.0];
    [self.scrollView addSubview:self.photoView];
    self.scrollView.delegate = self;

    [self.view addSubview:self.scrollView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    
    if (!_didSetupConstraints) {

        [self.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view
                         withOffset:[HelperModel viewHeight:self.navigationController.navigationBar] +20];
        [self.scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [self.scrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [self.scrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        
        [self.photoView autoSetDimensionsToSize:CGSizeMake([HelperModel screenWidth], [HelperModel screenHeight] -[HelperModel viewHeight:self.navigationController.navigationBar] -20.0)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark - Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;
}

#pragma mark - Lazy Initializations

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [UIImageView newAutoLayoutView];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.userInteractionEnabled = YES;
    }
    return _photoView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView newAutoLayoutView];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.5;
    }
    return _scrollView;
}

@end
