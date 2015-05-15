//
//  MyCustomTableViewCell.h
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PhotoTableViewCell : UITableViewCell

@property(nonatomic) IBInspectable UIView *containerView;
@property(nonatomic) IBInspectable UIImageView *profilePicture;
@property(nonatomic) IBInspectable UILabel *namelabel;
@property(nonatomic) IBInspectable UILabel *dateLabel;
@property(nonatomic) IBInspectable UIImageView *photoView;

@end