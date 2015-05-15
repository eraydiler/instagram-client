//
//  HelperModel.h
//  InstagramClient
//
//  Created by Eray on 15/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperModel : NSObject

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)viewHeight:(UIView *)view;
+ (CGFloat)photoDetailHeight;

@end
