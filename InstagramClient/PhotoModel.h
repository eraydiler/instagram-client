//
//  PhotoModel.h
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic, strong) NSURL *profilePictureURL;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSURL *photoURL;

+ (PhotoModel *)getPhotoModels:(NSDictionary *)dic;

@end