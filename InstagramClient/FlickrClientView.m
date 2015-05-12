//
//  FlickrClientView.m
//  InstagramClient
//
//  Created by Eray on 12/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "FlickrClientView.h"


@implementation FlickrClientView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    CGContextSetLineWidth(context, _lineWidth);
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
}



@end
