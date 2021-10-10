//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

#pragma mark - Hex

+(UIColor *)titleColor{
    
    return [UIColor whiteColor];

}
+(UIColor *)borderColor{
    
    return [UIColor whiteColor];
}

+ (UIColor *)themeColor{
    
    return [UIColor whiteColor];
}

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


#pragma mark - theme colors


@end
