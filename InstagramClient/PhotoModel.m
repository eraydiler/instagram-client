//
//  PhotoModel.m
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "PhotoModel.h"
#import "UIImageView+AFNetworking.h"

@implementation PhotoModel

+ (PhotoModel *)getPhotoModels:(NSDictionary *)dic {
    
    PhotoModel *photoModel = [[PhotoModel alloc] init];
    
    // Get user
    NSDictionary *user = [dic objectForKey:@"user"];
    NSString *profilePicture = [user objectForKey:@"profile_picture"];
    photoModel.userName = [user objectForKey:@"full_name"];
    
    // Get profile picture
    photoModel.profilePictureURL = [NSURL URLWithString:profilePicture];
    
    // Get photo
    NSDictionary *images = [dic objectForKey:@"images"];
    NSDictionary *lowRes = [images objectForKey:@"low_resolution"];
    NSString *lowImage = [lowRes objectForKey:@"url"];
    photoModel.photoURL = [NSURL URLWithString:lowImage];
    
    // Get time
    NSString *createdTime = [dic objectForKey:@"created_time"];
    NSTimeInterval interval = [createdTime doubleValue];;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: interval];
    photoModel.date = date;
    
    return photoModel;
}

@end
