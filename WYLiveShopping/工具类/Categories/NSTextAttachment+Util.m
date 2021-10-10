//
//  NSTextAttachment+Util.m
//  iosapp
//
//  Created by ChanAetern on 4/10/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y
{
    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
