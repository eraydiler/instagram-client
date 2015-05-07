//
//  MyCustomTableViewCell.h
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIImageView *profilePicture;
@property(nonatomic, strong) UILabel *namelabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *photo;

@end
