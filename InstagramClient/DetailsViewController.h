//
//  DetailsViewController.h
//  InstagramClient
//
//  Created by Eray on 20/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoModel;
@interface DetailsViewController : UIViewController

@property (nonatomic, strong) PhotoModel *photoModel;
@property (nonatomic, strong) UIImage *profilePhoto;
@property (nonatomic, strong) UIImage *photo;

@end
