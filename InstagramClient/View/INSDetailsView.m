//
//  INSDetailsView.m
//  InstagramClient
//
//  Created by Eray on 25/10/15.
//  Copyright © 2015 Eray. All rights reserved.
//

#import "INSDetailsView.h"

@interface INSDetailsView()
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation INSDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                               green:206.0/255.0
                                                blue:206.0/255.0
                                               alpha:1.0];
        
        [self addSubview:self.profilePicView];
        [self addSubview:self.photoView];
        [self addSubview:self.heartView];
        [self addSubview:self.likesLabel];
        [self addSubview:self.commentsButton];
        [self addSubview:self.username];
        
        [self setDidSetupConstraints:NO];
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)updateConstraints {
    
    if (!_didSetupConstraints) {
        NSLog(@"%f %f", self.frame.size.width, self.frame.size.height);
        
        [_profilePicView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [_profilePicView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [_username autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.profilePicView];
        [_username autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [_heartView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0];
        [_heartView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
        
        [_photoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.username withOffset:10.0];
        [_photoView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_photoView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_photoView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50.0];
        
        [_likesLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.heartView];
        [_likesLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.heartView withOffset:5.0];
        
        [_commentsButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.likesLabel];
        [_commentsButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Lazy Initializations

- (UIImageView *)profilePicView {
    if (!_profilePicView) {
        _profilePicView = [[UIImageView alloc] initForAutoLayout];
        
        [_profilePicView setImage:[UIImage imageNamed:@"placeholder.png"]];
        [_profilePicView autoSetDimensionsToSize:CGSizeMake(100.0, 100.0)];
        
        [self makeProfileImageCircular];
    }
    
    return _profilePicView;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] initForAutoLayout];
        
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                         action:@selector(photoTapped:)];
        [_photoView addGestureRecognizer:tapRecognizer];
        [_photoView setUserInteractionEnabled:YES];
        [tapRecognizer setCancelsTouchesInView:NO];
    }
    
    return _photoView;
}

- (UILabel *)fullName {
    if (!_fullName) {
        _fullName = [[UILabel alloc] initForAutoLayout];
    }
    
    return _fullName;
}

- (UILabel *)username {
    if (!_username) {
        _username = [[UILabel alloc] initForAutoLayout];
    }
    
    return _username;
}

- (UIImageView *)heartView {
    if (!_heartView) {
        _heartView = [[UIImageView alloc] initForAutoLayout];
        
        _heartView.image = [UIImage imageNamed:@"heart.png"];
        
        [_heartView autoSetDimensionsToSize:CGSizeMake(40.0, 40.0)];

    }
    
    return _heartView;
}

- (UILabel *)likesLabel {
    if (!_likesLabel) {
        _likesLabel = [[UILabel alloc] initForAutoLayout];
        
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
        _commentsButton = [[UIButton alloc] initForAutoLayout];
        
        [_commentsButton setTitle:@"Comments" forState:UIControlStateNormal];
        
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
                            action:@selector(didTapCommentsButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentsButton;
}

#pragma mark - selectors

- (void)didTapCommentsButton:(UIButton *)sender {
}

#pragma Mark - Helper Methods

- (void)makeProfileImageCircular {
    _profilePicView.layer.cornerRadius = 50.0 /*_view.frame.size.width / 2*/;
    _profilePicView.clipsToBounds = YES;
}

- (void)photoTapped:(UITapGestureRecognizer *)recognizer {
    [self.delegate detailView:self didTapPhotoView:_photoView];
}

@end
