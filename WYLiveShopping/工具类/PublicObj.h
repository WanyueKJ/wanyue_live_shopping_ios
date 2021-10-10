//
//  PublicObj.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>
@interface PublicObj : NSObject

/** 单行文本长度计算 */
+(CGSize)sizeWithString:(NSString *)string andFont:(UIFont *)font;

/** 多行计算frame */
+(CGRect)rectWithString:(NSString *)string andFont:(UIFont *)font maxWidth:(CGFloat)width;

/** token过期 */
+(void)tokenExpired:(NSString *)msg;

/** 返回游客信息 */
+(NSDictionary *)visitorDic;

/** 提醒游客请登录 */
+(void)warnLogin;

/** 根据色值获取图片 */
+(UIImage*)getImgWithColor:(UIColor *)color;

/** 设置上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn;

/** 自定义间距上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space;

/** 重设root */
+(void)resetVC:(UIViewController*)vc;

/** 根据图片名拼接文件路径 */
+(NSString *)getFilePathWithImageName:(NSString *)imageName;

/** 以当前时间合成视频名称 */
+(NSString *)getNameBaseCurrentTime:(NSString *)suf;

/** 判断是不是本地视频 */
+(BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset;

/** 权限相关 */
+(BOOL)havePhotoLibraryAuthority;

/** 原图-小-恢复 */
+(CAAnimation*)bigToSmallRecovery;

/** 原图-大-小*/
+(CAAnimation*)smallToBigToSmall;

/** 原图-小-保持 */
+(CAAnimation*)originToSmall;

/** 原图-大-小-恢复 */
+(CAAnimation*)originToBigToSmallRecovery;

/* 观看页面上下切换，并且未关注的情况下的过渡动画 */
+(CAAnimation*)followShowTransition;

/** 按钮按下执行动画(录音) */
+(CAAnimation*)touchDownAnimation;

/** 旋转动画 */
+(CABasicAnimation*)rotationAnimation;

/** 动画组 */
+(CAAnimationGroup*)caGroup;

/** MD5 */
+(NSString *)stringToMD5:(NSString *)str;

/** 检查为空 */
+(BOOL)checkNull:(NSString *)str;

/**
 获取icon

 @return    icon
 */
+(UIImage *)getAppIcon;

// 根据色值获取图片
+(UIImage*)getImgWithColor:(UIColor *)color;
@end
