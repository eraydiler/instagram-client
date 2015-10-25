//
//  PhotoModel.h
//  InstagramClient
//
//  Created by Eray on 07/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INSPhoto : NSObject

@property(nonatomic, strong) NSURL *profilePictureURL;
@property(nonatomic, strong) NSString *fullName;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSURL *photoURL;

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) NSArray *comments;
@property(nonatomic) int numbersOfLikes;

+ (INSPhoto *)getPhotoModel:(NSDictionary *)dic;

@end