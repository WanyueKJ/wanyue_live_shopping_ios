//
//  PublicView.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicView : UIView

/*****************************   指示器   **********************************/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indictorV;

/** 指示器显示 */
+(void)indictorShow;
/** 指示器消失 */
+(void)indictorHide;


/*****************************   无数据（有图）   **********************************/
@property (weak, nonatomic) IBOutlet UIImageView *noDataIV;
@property (weak, nonatomic) IBOutlet UILabel *noDataTextL;

/** 显示无数据/无网络 */
+(void)showImgNoData:(UIView *)superView name:(NSString *)imgName text:(NSString *)text;
/** 隐藏无数据/无网络 */
+(void)hiddenImgNoData:(UIView *)superView;

/*****************************   无数据（文字）   **********************************/

@property (weak, nonatomic) IBOutlet UILabel *noDataText1;
@property (weak, nonatomic) IBOutlet UILabel *noDataText2;

+(void)showTextNoData:(UIView *)superView text1:(NSString *)str1 text2:(NSString *)str2;
+(void)hiddenTextNoData:(UIView *)superView;

/*****************************   评论加载中   **********************************/
+(void)showCommenting:(UIView *)superView;
+(void)hideCommenting:(UIView *)superView;

/*****************************   个人中心动图   **********************************/

@property (weak, nonatomic) IBOutlet UIImageView *gifIV;

+(void)showCenterGif:(UIView *)superView;
+(void)hideCenterGif:(UIView *)superView;
@end
