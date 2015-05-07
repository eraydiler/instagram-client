//
//  SearchTableViewCell.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.searchField];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0];
        
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
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - instantiations

- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [UITextField newAutoLayoutView];
        _searchField.placeholder = @"Search";
        _searchField.font = [UIFont systemFontOfSize:20.0];
        _searchField.textAlignment = NSTextAlignmentCenter;
        _searchField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _searchField;
}

@end
