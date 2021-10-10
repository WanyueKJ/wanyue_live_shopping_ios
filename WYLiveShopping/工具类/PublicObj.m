//
//  PublicObj.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "PublicObj.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation PublicObj

#pragma mark - 单行文本长度计算
+(CGSize)sizeWithString:(NSString *)string andFont:(UIFont *)font {
    CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    return size;
}
#pragma mark - 多行计算frame
+(CGRect)rectWithString:(NSString *)string andFont:(UIFont *)font maxWidth:(CGFloat)width {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect;
}
#pragma mark - 登录逾期
+(void)tokenExpired:(NSString *)msg {

    
    
}

#pragma mark - 返回游客信息
+(NSDictionary *)visitorDic{
    NSDictionary *dic = @{
                          @"age":@"18",
                          @"area":@"",
                          @"avatar" : @"http://livedemo.yunbaozhibo.com/default.jpg",
                          @"avatar_thumb" : @"http://livedemo.yunbaozhibo.com/default_thumb.jpg",
                          @"birthday" : @"",
                          @"city" : @"",
                          @"code" : @"",
                          @"hometown":@"",
                          @"id" : @"-9999",
                          @"isreg" : @"0",
                          @"province" : @"",
                          @"sex" : @"2",
                          @"signature" : @"",
                          @"token" : @"-9999",
                          @"user_nicename" : @"游客",
                          };
    return dic;
}

#pragma mark - 提醒游客请登录
+(void)warnLogin {
    //有弹窗--提示是否登录
    /*
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DspLoginVC *login =[[DspLoginVC alloc]init];
        login.youke = @"youke";
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        [currentVC presentViewController:navi animated:YES completion:nil];
    }];
    [alertContro addAction:sureAction];
    [currentVC presentViewController:alertContro animated:YES completion:nil];
    */
    //无弹窗--直接进入登录
    
   
}

#pragma mark - 根据色值获取图片
+(UIImage*)getImgWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 设置上图下文字
+(UIButton*)setUpImgDownText:(UIButton *)btn {
    /*
     多处使用，不要随意更改，
     */
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat spaceH = 5;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    
    return btn;
}
//自定义间距上图下文字
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space {
    
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat spaceH = space;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    
    return btn;
}

#pragma mark - 重设root
+(void)resetVC:(UIViewController*)vc{
   
}

#pragma mark - 根据图片名拼接文件路径
+(NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    return nil;
}
#pragma mark - 以当前时间合成视频名称
+(NSString *)getNameBaseCurrentTime:(NSString *)suf {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nameStr = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:suf];
    return [NSString stringWithFormat:@"%@_IOS_%@",[Config getOwnID],nameStr];
}

#pragma mark - 判断是不是本地视频
+ (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset {
    __block BOOL result = NO;
    if (@available(iOS 10.0, *)) {
        // https://stackoverflow.com/questions/31966571/check-given-phasset-is-icloud-asset
        // 这个api虽然是9.0出的，但是9.0会全部返回NO，未知原因，暂时先改为10.0
        NSArray *resourceArray = [PHAssetResource assetResourcesForAsset:asset];
        if (resourceArray.count) {
            result = [[resourceArray.firstObject valueForKey:@"locallyAvailable"] boolValue];
        }
    } else {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = NO;
        option.synchronous = YES;
        
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            result = imageData ? YES : NO;
        }];
    }
    return result;
}
#pragma mark - 权限相关
+ (BOOL)havePhotoLibraryAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

#pragma mark - 原图-小-恢复
+(CAAnimation*)bigToSmallRecovery {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}

#pragma mark - 原图-大-小
+(CAAnimation*)smallToBigToSmall {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    animation.values = values;
    return animation;
}

#pragma mark - 原图-小-保持
+(CAAnimation*)originToSmall {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
   
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    
    animation.values = values;
    return animation;
}
#pragma mark - 原图-大-小-恢复
+(CAAnimation*)originToBigToSmallRecovery {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}

#pragma mark - 观看页面上下切换，并且未关注的情况下的过渡动画
+(CAAnimation*)followShowTransition {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}



#pragma mark - 按钮按下执行动画(录音)
+(CAAnimation*)touchDownAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.7, 1.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}
#pragma mark - 旋转动画
+(CABasicAnimation*)rotationAnimation {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.toValue = @(2 * M_PI);
    rotate.duration = 5;
    rotate.repeatCount = MAXFLOAT;
    return rotate;
}

#pragma mark - 动画组
+(CAAnimationGroup*)caGroup{
    //路径
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = YES;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    //起点
    CGPathMoveToPoint(curvedPath, NULL, 45, 350);
    //辅助点和终点--- 父视图 85*350（唱片 50*50 ）
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 8, 340, 16, 290);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    //缩放
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.7, 1.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.8, 1.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.9, 1.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.1, 2.1, 1.0)]];
    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 0, 1)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.8, 0, 0, 1)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.7, 0, 0, 1)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.6, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.5, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.9, 0, 1, 0)]];
    
    animation.values = values;
    
    //透明
    CAKeyframeAnimation *opacityAnimaton = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimaton.values = @[@1,@1,@1,@1,@1,@0.9,@0.8,@0.7,@0.6,@0.5,@0.4,@0.3];
    
    group.animations = @[pathAnimation,animation,opacityAnimaton];
    group.duration = 3.0;
    group.repeatCount = MAXFLOAT;
    group.fillMode = kCAFillModeForwards;
    return group;
}
#pragma mark - MD5
+(NSString *)stringToMD5:(NSString *)str {
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
#pragma mark - 检查为空
+(BOOL)checkNull:(NSString *)str {
    if ([str isEqual:@"<null>"]||[str isEqual:@"(null)"]||[str isKindOfClass:[NSNull class]]||str.length==0) {
        return YES;
    }
    return NO;
}
#pragma mark - 获取App头像
+(UIImage *)getAppIcon {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *img= [UIImage imageNamed:icon];
    return img;
}


@end
