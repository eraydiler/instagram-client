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
        
//        [self.contentView addSubview:self.searchField];
        [self.contentView  addSubview:self.containerView];
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
        
//        [self.searchField autoSetDimension:ALDimensionHeight toSize:40.0];
//        [self.searchField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
//        [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
//        [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
        
        [self.containerView autoSetDimension:ALDimensionHeight toSize:50.0];
//        [self.containerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchField withOffset:10.0];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        [self.profilePicture autoSetDimension:ALDimensionWidth toSize:50.0];
        [self.profilePicture autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView];
        [self.profilePicture autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
        
        [self.dateLabel autoSetDimension:ALDimensionWidth toSize:100.0];
        [self.dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView];
        [self.dateLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
        [self.dateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];
        
        [NSLayoutConstraint constraintWithItem:self.profilePicture
                                     attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                        toItem:self.dateLabel attribute:NSLayoutAttributeLeft
                                    multiplier:1.0 constant:10.0];
        
        [self.namelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView];
        [self.namelabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
        [self.namelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.profilePicture];
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

//- (UITextField *)searchField {
//    if (!_searchField) {
//        _searchField = [UITextField newAutoLayoutView];
//        _searchField.placeholder = @"Search";
//        _searchField.font = [UIFont systemFontOfSize:20.0];
//        _searchField.textAlignment = NSTextAlignmentCenter;
//        _searchField.borderStyle = UITextBorderStyleRoundedRect;
//    }
//    return _searchField;
//}

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
        _namelabel.backgroundColor = [UIColor yellowColor];
    }
    return _namelabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel newAutoLayoutView];
        _dateLabel.backgroundColor = [UIColor blueColor];
    }
    return _dateLabel;
}

- (UIImageView *)photo {
    if (!_photo) {
        _photo = [UIImageView newAutoLayoutView];
        _photo.backgroundColor = [UIColor brownColor];
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

@end
