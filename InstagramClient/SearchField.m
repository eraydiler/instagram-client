//
//  SearchField.m
//  InstagramClient
//
//  Created by Eray on 13/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "SearchField.h"
#import "PureLayout.h"

@implementation SearchField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIColor *borderColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.layer.borderColor = [borderColor CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        self.placeholder = @"Search";
        self.font = [UIFont systemFontOfSize:20.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

@end
