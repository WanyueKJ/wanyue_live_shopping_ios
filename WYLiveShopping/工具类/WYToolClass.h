//
//  YBToolClass.h
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "WYSuspensionPlayer.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^networkSuccessBlock)(int code,id info,NSString *msg);
typedef void (^networkFailBlock)(void);
@interface WYToolClass : NSObject
/**
 单例类方法
 
 @return 返回一个共享对象
 */
+ (instancetype)sharedInstance;
+ (AFHTTPSessionManager *)httpManager;
/**
 网络请求成功的回调
 */
@property(nonatomic,copy)networkSuccessBlock successB;
/**
 网络请求失败的回调
 */
@property(nonatomic,copy)networkFailBlock failB;
+(void)getQCloudWithUrl:(NSString *)url Suc:(networkSuccessBlock)successBlock Fail:(networkFailBlock)failBlock;
/**
 网络请求

 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(nullable id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock;

/**
 计算字符串宽度

 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;
+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;

/**
 计算字符串的高度

 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width;
/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width andString:(NSString *)str;
/**
 画一条线
 
 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view;

/**
 MD5加密

 @param input 要加密的字符串
 @return 加密好的字符串
 */
- (NSString *) md5:(NSString *) input;

/**
 比较两个时间的大小

 @param date01 老的时间
 @param date02 新的时间
 @return 返回 1 -1 0
 */
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

/**
 创建emoji正则表达式

 @param pattern 正则规则
 @param str 字符串
 @return 数组
 */
- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str;


/**
 设置视图左上圆角

 @param leftC 左上半径
 @param rightC 又上半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftTop:(CGFloat)leftC andRightTop:(CGFloat)rightC andView:(UIView *)view;
/**
 设置视图底部圆角
 
 @param leftC 左下半径
 @param rightC 又下半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftBottom:(CGFloat)leftC andRightBottom:(CGFloat)rightC andView:(UIView *)view;

/** 自定义间距上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space;

/** 根据色值获取图片 */
+(UIImage*)getImgWithColor:(UIColor *)color;

/**
 获取icon
 
 @return    icon
 */
+(UIImage *)getAppIcon;
/** 根据色值获取图片 */

/**
 字典字符串加密排序

 @param dic 参数
 @return 加密好的字符串
 */
+ (NSString *)sortString:(NSDictionary *)dic;
/** 权限相关 */
+(BOOL)havePhotoLibraryAuthority;

/** 判断是不是本地视频 */
+(BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset;


/** 设置上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn;

#pragma mark - 以当前时间合成视频名称
+(NSString *)getNameBaseCurrentTime:(NSString *)suf;

/** 原图-小-恢复 */
+(CAAnimation*)bigToSmallRecovery;

/** 原图-大-小*/
+(CAAnimation*)smallToBigToSmall;

/** 原图-小-保持 */
+(CAAnimation*)originToSmall;

/** 原图-大-小-恢复 */
+(CAAnimation*)originToBigToSmallRecovery;

/**
 检查麦克风授权
 */
+(int)checkAudioAuthorization;
/**
 检测摄像头授权
 */
+(int)checkVideoAuthorization;

/**
 邮箱验证

 @param email 邮箱地址
 @return 是否为正确格式邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 解密字符串

 @param code 待解密的字符串
 @return 解密完成的字符串
 */
+ (NSString *)decrypt:(NSString *)code;

+ (void)changeAVAudioSessionState;
+(NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str;
-(void)quitLogin;
- (void)showLoginView;
+ (NSString *)getCurrentDeviceModel;
+ (NSString *)getNetworkType;
- (void)showSusPlayer:(NSDictionary *)dic andVideoSize:(CGSize)size;
- (void)removeSusPlayer;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
-(NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
