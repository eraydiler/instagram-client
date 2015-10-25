//
//  DetailsViewController.h
//  InstagramClient
//
//  Created by Eray on 20/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INSPhoto;
@interface DetailsViewController : UIViewController

@property (nonatomic, strong) INSPhoto *photoModel;
@property (nonatomic, strong) UIImage *profilePhoto;
@property (nonatomic, strong) UIImage *photo;

@end
