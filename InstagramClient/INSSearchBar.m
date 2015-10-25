//
//  SearchBar.m
//  InstagramClient
//
//  Created by Eray on 13/05/15.
//  Copyright (c) 2015 Eray. All rights reserved.
//

#import "INSSearchBar.h"

@implementation INSSearchBar

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"Search";
    }
    
    return self;
}

@end
