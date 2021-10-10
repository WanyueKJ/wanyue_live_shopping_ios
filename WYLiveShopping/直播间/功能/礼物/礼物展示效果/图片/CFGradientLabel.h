//
//  TestLabel.h
//  38-文字渐变色-C
//
//  Created by 于 传峰 on 15/7/27.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFGradientLabel : UILabel

@property(nonatomic, strong) NSArray* colors;
/** 描多粗的边*/

@property (nonatomic, assign) NSInteger outLineWidth;

/** 外轮颜色*/

@property (nonatomic, strong) UIColor *outLinetextColor;

/** 里面字体默认颜色*/

@property (nonatomic, strong) UIColor *labelTextColor;


@end
