//
//  PublicView.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "PublicView.h"

@implementation PublicView
/*****************************   指示器视图(start)   **********************************/

/*****************************   指示器   **********************************/
#pragma mark - 指示器显示
+(void)indictorShow {
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    PublicView *pubV = [[[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil]objectAtIndex:0];
    pubV.frame = CGRectMake(0, statusbarHeight+64, _window_width, _window_height-statusbarHeight-64-ShowDiff);
    BOOL have = NO;
    for (UIView *view in currentVC.view.subviews) {
        if ([view isKindOfClass:[PublicView class]]) {
            have = YES;
            break;
        }
    }
    if (have==NO) {
        [currentVC.view addSubview:pubV];
    }
    pubV.hidden = NO;
    //开始旋转
    [pubV.indictorV startAnimating];
    
}
#pragma mark - 指示器消失
+(void)indictorHide {
    
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    for (UIView *view in currentVC.view.subviews) {
        if ([view isKindOfClass:[PublicView class]]) {
            PublicView *pubV = (PublicView *)view;
            [pubV.indictorV stopAnimating];
            [pubV.indictorV setHidesWhenStopped:YES];
            pubV.hidden = YES;
        }
    }
    
}
/*****************************     指示器视图(end)     **********************************/
#pragma mark =====================================================================
/*****************************   数据图形视图(start)   **********************************/
/*****************************       无数据(带图)      **********************************/

+(void)publicHide:(UIView *)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    for (UIView *subv in superView.subviews) {
        if ([subv isKindOfClass:[PublicView class]]) {
            [subv removeFromSuperview];
        }
    }
}

#pragma mark - 无数据提示
+(void)hiddenImgNoData:(UIView *)superView {
    [self publicHide:superView];
}

+(void)showImgNoData:(UIView *)superView name:(NSString *)imgName text:(NSString *)text{
    for (UIView *subv in superView.subviews) {
        if ([subv isKindOfClass:[PublicView class]]) {
            [subv removeFromSuperview];
        }
    }
    /**
     *  公用类尺寸谨慎修改
     */
    PublicView *_noData = [[[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil]objectAtIndex:1];
    _noData.frame = CGRectMake(0, 0, superView.width, superView.height);
    _noData.noDataIV.image = [UIImage imageNamed:imgName];
    _noData.noDataTextL.text = text;
    [superView addSubview:_noData];
}

/*****************************   无数据(文字)   **********************************/

+(void)showTextNoData:(UIView *)superView text1:(NSString *)str1 text2:(NSString *)str2 {
    for (UIView *subv in superView.subviews) {
        if ([subv isKindOfClass:[PublicView class]]) {
            [subv removeFromSuperview];
        }
    }
    /**
     *  公用类尺寸谨慎修改
     */
    PublicView *_noData = [[[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil]objectAtIndex:2];
    _noData.frame = CGRectMake(0, 0, superView.width, superView.height);
    _noData.noDataText1.text = str1;
    _noData.noDataText2.text = str2;
    [superView addSubview:_noData];
}
+(void)hiddenTextNoData:(UIView *)superView {
    [self publicHide:superView];
}

/*****************************   评论加载中   **********************************/
+(void)showCommenting:(UIView *)superView {
    for (UIView *subv in superView.subviews) {
        if ([subv isKindOfClass:[PublicView class]]) {
            [subv removeFromSuperview];
        }
    }
    PublicView *_comment = [[[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil]objectAtIndex:3];
    _comment.frame = CGRectMake(0, 0, superView.width, superView.height);
    [superView addSubview:_comment];
}
+(void)hideCommenting:(UIView *)superView {
    [self publicHide:superView];
}

/*****************************   个人中心动图   **********************************/

+(void)showCenterGif:(UIView *)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    for (UIView *subv in superView.subviews) {
        if ([subv isKindOfClass:[PublicView class]]) {
            [subv removeFromSuperview];
        }
    }
    PublicView *_comment = [[[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil]objectAtIndex:4];
    _comment.frame = CGRectMake(0, _window_height-100-49-ShowDiff, _window_width, 100);
//    UIImage *gifImg = [UIImage sd_animatedGIFNamed:@"center_gif"];
//    [_comment.gifIV setImage:gifImg];
    //上下浮动
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat duration = 1.f;
    CGFloat height = 7.f;
    CGFloat currentY = _comment.gifIV.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [_comment.gifIV.layer addAnimation:animation forKey:nil];
    
    [superView addSubview:_comment];
}
+(void)hideCenterGif:(UIView *)superView {
    [self publicHide:superView];
}

/*****************************   数据图形视图(end)   **********************************/



@end
