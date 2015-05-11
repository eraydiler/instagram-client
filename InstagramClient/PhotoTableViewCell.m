//
//  MyCustomTableViewCell.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotoTableViewCell.h"

@interface PhotoTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation PhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.containerView];
        [self.contentView addSubview:self.profilePicture];
        [self.contentView addSubview:self.namelabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.photo];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.containerView autoSetDimension:ALDimensionHeight toSize:50.0];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeRight];

        [self.profilePicture autoSetDimension:ALDimensionWidth toSize:40.0];
        [self.profilePicture autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containerView withOffset:5.0];
        [self.profilePicture autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView withOffset:5.0];
        [self.profilePicture autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView withOffset:-5.0];
        [self makeProfileImageCircular];

        [self.dateLabel autoSetDimension:ALDimensionWidth toSize:100.0];
        [self.dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView];
        [self.dateLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
        [self.dateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];

        [self.namelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView];
        [self.namelabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
        [self.namelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.profilePicture withOffset:5.0];
        [self.namelabel autoSetDimension:ALDimensionWidth toSize:CGRectGetWidth(self.bounds)];

        [self.photo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.containerView];
        [self.photo autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.photo autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.photo autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - instantiations

- (UIImageView *)profilePicture {
    if (!_profilePicture) {
        _profilePicture = [UIImageView newAutoLayoutView];
        _profilePicture.backgroundColor = [UIColor redColor];
    }
    return _profilePicture;
}

- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [UILabel newAutoLayoutView];
        _namelabel.backgroundColor = [UIColor clearColor];
    }
    return _namelabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel newAutoLayoutView];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _dateLabel;
}

- (UIImageView *)photo {
    if (!_photo) {
        _photo = [UIImageView newAutoLayoutView];
        _photo.backgroundColor = [UIColor darkGrayColor];
    }
    return _photo;
}

-(UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView newAutoLayoutView];
        _containerView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return _containerView;
}

#pragma mark - Helper Methods

- (void) makeProfileImageCircular {
    _profilePicture.layer.cornerRadius = 20 /*_profilePicture.frame.size.width / 2*/;
    _profilePicture.clipsToBounds = YES;
}

@end
