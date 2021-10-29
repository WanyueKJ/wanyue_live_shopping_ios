//
//  ZYTabBar.m
//  自定义tabbarDemo
//
//  Created by tarena on 16/7/1.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ZYTabBar.h"
#import "UIView+LBExtension.h"
#import <objc/runtime.h>

#define ZYMagin 30
@interface ZYTabBar ()<MXtabbarDelegate>
@end
@implementation ZYTabBar
//对按钮的一些基本设置
- (void)setUpPathButton:(MXtabbar *)pathButton {
    pathButton.delegate = self;
}
- (void)drawRect:(CGRect)rect {
    if (!self.plusBtn) {
        self.plusBtn = [[MXtabbar alloc]initWithCenterImage:[UIImage imageNamed:@"tab_start_live"]highlightedImage:[UIImage imageNamed:@"tab_start_live"]];
        self.plusBtn.delegate = self;
        [self setUpPathButton:self.plusBtn];
        //必须加到父视图上
        [self.superview addSubview:self.plusBtn];
//        UILabel *label = [[UILabel alloc]init];
//        label.text = @"发布";
//        label.font = [UIFont systemFontOfSize:13];
//        //[label sizeToFit];
//        label.textColor = [UIColor grayColor];
//        label.centerX = _plusBtn.centerX;
//        label.centerY = CGRectGetMaxY(_plusBtn.frame) + ZYMagin;
//        [self.superview addSubview:label];
    }
}
//重新绘制按钮
- (void)layoutSubviews {
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton,找出这些类型的按钮,然后重新排布位置 ,空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
           //每一个按钮的宽度 == tabbar的五分之一
            btn.width = self.width/5;
            btn.x = btn.width * btnIndex;
            btn.y = 5;
            btnIndex ++;
            //如果是索引是1(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
                
            }
        }
    }
}
- (void)pathButton:(MXtabbar *)MXtabbar clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    
    if ([self.delegate respondsToSelector:@selector(pathButton:clickItemButtonAtIndex:)]) {
        [self.delegate pathButton:self clickItemButtonAtIndex:itemButtonIndex];
    }
    
}
@end















