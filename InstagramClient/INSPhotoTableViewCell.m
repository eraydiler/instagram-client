//
//  MyCustomTableViewCell.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "INSPhotoTableViewCell.h"

@interface INSPhotoTableViewCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation INSPhotoTableViewCell

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
        [self.contentView addSubview:self.photoView];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/255.0
                                                           green:206.0/255.0
                                                            blue:206.0/255.0
                                                           alpha:1.0];
        [self setDidSetupConstraints:NO];
        
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
        [self.namelabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.dateLabel];

        [self.photoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.containerView];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.photoView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)prepareForReuse {
    [_profilePicture setImage:nil];
    [_namelabel setText:nil];
    [_dateLabel setText:nil];
    [_photoView setImage:nil];
}

#pragma mark - instantiations

- (UIImageView *)profilePicture {
    if (!_profilePicture) {
        _profilePicture = [[UIImageView alloc] initForAutoLayout];
        
        _profilePicture.backgroundColor = [UIColor redColor];
        _profilePicture.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    return _profilePicture;
}

- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [[UILabel alloc] initForAutoLayout];
        
        _namelabel.backgroundColor = [UIColor clearColor];
        _namelabel.text = @"Mister Tester";
    }
    
    return _namelabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initForAutoLayout];
        
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        _dateLabel.text = @"2 hours ago";
    }
    
    return _dateLabel;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] initForAutoLayout];
        
        _photoView.backgroundColor = [UIColor grayColor];
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    return _photoView;
}

-(UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initForAutoLayout];
        
        _containerView.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                         green:237.0/255.0
                                                          blue:237.0/255.0
                                                         alpha:1.0];
    }
    
    return _containerView;
}

#pragma mark - Helper Methods

- (void) makeProfileImageCircular {
    _profilePicture.layer.cornerRadius = 20 /*_profilePicture.frame.size.width / 2*/;
    _profilePicture.clipsToBounds = YES;
}

@end
