//
//  PhotoModel.h
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic, strong) UIImageView *profilePicture;
@property(nonatomic, strong) UILabel *userName;
@property(nonatomic, strong) UILabel *date;


@end
