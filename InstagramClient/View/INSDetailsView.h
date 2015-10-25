//
//  INSDetailsView.h
//  InstagramClient
//
//  Created by Eray on 25/10/15.
//  Copyright © 2015 Eray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INSDetailsView;

@protocol INSDetailsViewDelegate <NSObject>

- (void)detailView:(INSDetailsView *)detailView
   didTapPhotoView:(UIImageView *)photoView;

@end

@interface INSDetailsView : UIView

@property (nonatomic, weak) id <INSDetailsViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *profilePicView;
@property (nonatomic, strong) UIImageView *heartView;
@property (nonatomic, strong) UILabel *fullName;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UIButton *commentsButton;
@property (nonatomic, strong) UILabel *likesLabel;

@end
