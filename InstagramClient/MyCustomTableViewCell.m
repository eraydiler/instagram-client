//
//  MyCustomTableViewCell.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "MyCustomTableViewCell.h"

@interface MyCustomTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MyCustomTableViewCell

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
        
        [self.contentView addSubview:self.searchField];
        [self.contentView addSubview:self.profilePicture];
        [self.contentView addSubview:self.namelabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.photo];
        
        self.contentView.backgroundColor = [UIColor grayColor];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.searchField autoSetDimension:ALDimensionHeight toSize:40.0];
        [self.searchField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
        [self.searchField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
        
        [self.profilePicture autoSetDimensionsToSize:CGSizeMake(40.0, 40.0)];
        [self.profilePicture autoCenterInSuperview];
        
        [self.namelabel autoSetDimensionsToSize:CGSizeMake(40.0, 40.0)];
        [self.namelabel autoCenterInSuperview];
        
        [self.dateLabel autoSetDimensionsToSize:CGSizeMake(40.0, 40.0)];
        [self.dateLabel autoCenterInSuperview];
        
        [self.photo autoSetDimensionsToSize:CGSizeMake(200.0, 200.0)];
        [self.photo autoCenterInSuperview];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - instantiations

- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [UITextField newAutoLayoutView];
//        _searchField.backgroundColor = [UIColor greenColor];
        _searchField.placeholder = @"Search";
        _searchField.font = [UIFont systemFontOfSize:20.0];
        _searchField.textAlignment = NSTextAlignmentCenter;
        _searchField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _searchField;
}

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

@end
