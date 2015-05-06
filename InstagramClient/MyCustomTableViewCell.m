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
        
        [self.contentView addSubview:self.photo];
        self.contentView.backgroundColor = [UIColor grayColor];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.photo autoSetDimensionsToSize:CGSizeMake(100.0, 50.0)];
        [self.photo autoCenterInSuperview];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - instantiations

- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [UITextField newAutoLayoutView];
        _searchField.backgroundColor = [UIColor greenColor];
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
