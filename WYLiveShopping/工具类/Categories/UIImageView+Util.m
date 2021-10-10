//
//  UIImageView+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 11/11/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "UIImageView+Util.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] options:0];
}

@end
