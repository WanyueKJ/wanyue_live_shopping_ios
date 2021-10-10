//
//  UIView+WPFExtension.h
//  02-网易彩票
//
//  Created by 王鹏飞 on 16/1/13.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WPFExtension)


// 分类可以增加属性！！！！！但是不会自动生成set 和 get 方法，需要手动写

// 可以快速的改变或获取x、y、width、heigh 值
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
