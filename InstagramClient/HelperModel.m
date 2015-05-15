//
//  HelperModel.m
//  InstagramClient
//
//  Created by Eray on 15/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "HelperModel.h"

@implementation HelperModel

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)viewHeight:(UIView *)view {
    return CGRectGetHeight(view.frame);
}

+ (CGFloat)photoDetailHeight {
    return [HelperModel screenHeight] -20;
}

@end
