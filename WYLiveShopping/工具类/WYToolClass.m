//
//  YBToolClass.m
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "WYToolClass.h"
#import<CommonCrypto/CommonDigest.h>
#import "WYLoginViewController.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
//#import ""
@implementation WYToolClass{
    WYSuspensionPlayer *susPlayer;

}
static WYToolClass* kSingleObject = nil;
static AFHTTPSessionManager *httpManager = nil;
/** 单例类方法 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSingleObject = [[super allocWithZone:NULL] init];
    });
    
    return kSingleObject;
}
+ (AFHTTPSessionManager *)httpManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [AFHTTPSessionManager manager];
    });
    
    return httpManager;

}
// 重写创建对象空间的方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 直接调用单例的创建方法
    return [self sharedInstance];
}
+(void)getQCloudWithUrl:(NSString *)url Suc:(networkSuccessBlock)successBlock Fail:(networkFailBlock)failBlock {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",purl,url];
    NSLog(@"请求URL=：%@",requestUrl);
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [[WYToolClass httpManager] GET:requestUrl parameters:nil headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"返回数据：%@",responseObject);
        int code = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] intValue];
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *msg = minstr([responseObject valueForKey:@"msg"]);
        //回调
        successBlock(code,data,msg);
        if (code != 200) {
            [MBProgressHUD showError:msg];
        }
        if (code == 410000 || code == 410001 || code == 410002) {
            [[WYToolClass sharedInstance] quitLogin];
        }

        
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        failBlock();
        
    }];
}

/**
 网络请求
 
 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock{
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];

//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",purl,url];
//    NSString *requestUrl = [purl stringByAppendingFormat:@"/?service=%@&language=",url,[Config canshu]];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//本地的版本号
    NSString *package = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];//本地的版本号
    requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *pDic;
    if ([Config getOwnID].integerValue>0 && [Config getOwnToken]) {
        pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([Config getOwnID]),@"uid",[self getCurrentDeviceModel],@"model",build,@"version",phoneVersion,@"system",package,@"package",[Config getOwnToken],@"token", nil];
    }else{
        pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"uid",[self getCurrentDeviceModel],@"model",build,@"version",phoneVersion,@"system",package,@"package",@"0",@"token", nil];
    }
    [pDic addEntriesFromDictionary:parameter];
    NSLog(@"请求URL:%@",requestUrl);
    NSLog(@"请求参数：%@",pDic);
    [[WYToolClass httpManager] POST:requestUrl parameters:pDic headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"status"] ;
        NSLog(@"返回数据：%@",responseObject);
        NSArray *data = [responseObject valueForKey:@"data"];
        successBlock([number intValue], data,minstr([responseObject valueForKey:@"msg"]));

        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
        }else if ([number intValue] == 410000 || [number intValue] == 410001 || [number intValue] == 410002) {
            [MBProgressHUD hideHUD];
            [[WYToolClass sharedInstance] quitLogin];
            [MBProgressHUD showError:minstr([responseObject valueForKey:@"msg"])];
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:minstr([responseObject valueForKey:@"msg"])];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock();
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络请求失败"];

    }];
//    [session POST:requestUrl parameters:pDic
//         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//             NSNumber *number = [responseObject valueForKey:@"ret"] ;
//             NSLog(@"返回数据：%@",responseObject);
//
//             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
//             {
//                 NSArray *data = [responseObject valueForKey:@"data"];
//                 int code = [minstr([data valueForKey:@"code"]) intValue];
//                 id info = [data valueForKey:@"info"];
//                 successBlock(code, info,minstr([data valueForKey:@"msg"]));
//                 if (code == 700) {
//                     [[WYToolClass sharedInstance] quitLogin];
//                     [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
//                 }
//             }else{
//                 [MBProgressHUD hideHUD];
//                 [MBProgressHUD showError:minstr([responseObject valueForKey:@"msg"])];
//             }
//
//         }
//          failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         failBlock();
//         [MBProgressHUD hideHUD];
//         [MBProgressHUD showError:YZMsg(@"网络请求失败")];
//
//     }];
}

/**
 计算字符串宽度
 
 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
/**
 计算字符串的高度
 
 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    return [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
}
/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width andString:(NSString *)str{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/**
 画一条线

 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view{
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
/**
 MD5加密
 
 @param input 要加密的字符串
 @return 加密好的字符串
 */

- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr,strlen(cStr),digest); // This is the md5 call
    
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
    [output appendFormat:@"%02x", digest[i]];
    
    
    return output;
    
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    
    int ci;

    NSDateFormatter *df = [[NSDateFormatter alloc]init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *dt1 = [[NSDate alloc]init];

    NSDate *dt2 = [[NSDate alloc]init];

    dt1 = [df dateFromString:date01];

    dt2 = [df dateFromString:date02];

    NSComparisonResult result = [dt1 compare:dt2];

    switch (result)

    {

        //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
        //date02比date01小
        case NSOrderedDescending:
            ci = -1;
            break;
        //date02=date01
        case NSOrderedSame:
            ci = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
     }

    return ci;

}

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str
{
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error)
    {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}


/**
 设置视图左上圆角
 
 @param leftC 左上半径
 @param rightC 又上半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftTop:(CGFloat)leftC andRightTop:(CGFloat)rightC andView:(UIView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(leftC, rightC)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}
/**
 设置视图底部圆角
 
 @param leftC 左下半径
 @param rightC 又下半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftBottom:(CGFloat)leftC andRightBottom:(CGFloat)rightC andView:(UIView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(leftC, rightC)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

//自定义间距上图下文字
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space {
    
    CGFloat textW = [self widthOfString:btn.titleLabel.text andFont:btn.titleLabel.font andHeight:20];
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat totalW = btn.imageView.frame.size.width + textW;
    CGFloat allowanceW = (totalW - btn.frame.size.width) > 0 ? (totalW - btn.frame.size.width)/2.0 : 0;
    CGFloat spaceH = space;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width-allowanceW)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width-allowanceW, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    return btn;
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
#pragma mark - 获取App头像
+(UIImage *)getAppIcon {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *img= [UIImage imageNamed:icon];
    return img;
}
+ (NSString *)sortString:(NSDictionary *)dic{
    
    //  2. 非数字型字符串（注意用compare比较要剔除空数据（nil））
    NSString *returnStr = @"";
    NSArray *charArray = [dic allKeys];
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0,obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
        
    };
    
    NSArray *resultArray2 = [charArray sortedArrayUsingComparator:sort];
    
    for (int i = 0; i < resultArray2.count; i++) {
        NSString *str = resultArray2[i];
        if (i != resultArray2.count - 1) {
            returnStr = [NSString stringWithFormat:@"%@%@=%@&",returnStr,str,minstr([dic valueForKey:str])];
        }else{
            returnStr = [NSString stringWithFormat:@"%@%@=%@&123456",returnStr,str,minstr([dic valueForKey:str])];
        }
    }
    return [[self sharedInstance] md5:returnStr];
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
#pragma mark - 以当前时间合成视频名称
+(NSString *)getNameBaseCurrentTime:(NSString *)suf {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nameStr = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:suf];
    return [NSString stringWithFormat:@"IOS_%@",nameStr];
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
/**
 检查麦克风授权
 */
+(int)checkAudioAuthorization
{
    return [self checkAuthorizationStatus:AVMediaTypeAudio];
}


/**
 检测摄像头授权
 */
+(int)checkVideoAuthorization
{
    return [self checkAuthorizationStatus:AVMediaTypeVideo];
}

+ (int)checkAuthorizationStatus:(AVMediaType)mediaType
{
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied)  {
        //拒绝
        return 0;
    }
    if (authorStatus == AVAuthorizationStatusNotDetermined) {
        //未获取
        return 2;
    }
    //同意
    return 1;
}
//判断邮箱格式是否正确的代码：
//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (NSString *)decrypt:(NSString *)code{
    NSString* str = @"1ecxXyLRB.COdrAi:q09Z62ash-QGn8VFNIlb=fM/D74WjS_EUzYuw?HmTPvkJ3otK5gp";
    NSInteger strl = str.length;
    
    NSInteger len = code.length;
    
    NSString* newCode = @"";
    for(int i = 0;i < len; i++){
        NSString *codeIteam = [code substringWithRange:NSMakeRange(i, 1)];
        
        for(int j = 0; j < strl; j++){
            NSString *strIteam = [str substringWithRange:NSMakeRange(j, 1)];
            if([strIteam isEqual:codeIteam]){
                if(j == 0){
                    newCode = [NSString stringWithFormat:@"%@%@",newCode,[str substringWithRange:NSMakeRange(strl - 1, 1)]];
                }else{
                    newCode = [NSString stringWithFormat:@"%@%@",newCode,[str substringWithRange:NSMakeRange(j-1, 1)]];
                }
            }
        }
    }
    return newCode;
}

+ (void)changeAVAudioSessionState{
    BOOL iscall = [[NSUserDefaults standardUserDefaults] boolForKey:@"isStartCall"];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (iscall) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }

}
#pragma mark - 创建emoji正则表达式
+(NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str {
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}

//退出登录函数
-(void)quitLogin
{
//    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
//    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [Config clearProfile];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    WYLoginViewController *login = [[WYLoginViewController alloc]init];
    login.isquitLogin = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    app2.window.rootViewController = nav;
}
- (void)showLoginView{
    WYLoginViewController *login = [[WYLoginViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:login animated:YES];
}

+ (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}
+ (NSString *)getNetworkType
{
    NSString *network = @"";
    if ([[UIDevice currentDevice].systemVersion floatValue]>=13) {
        return network;
    }else
    if (iPhoneX) {
        UIApplication *app = [UIApplication sharedApplication];
        id statusBar = [app valueForKeyPath:@"statusBar"];

        //        iPhone X
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                network = @"WIFI";
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                network = [subview valueForKeyPath:@"originalText"];
            }
        }
    }else {
        UIApplication *app = [UIApplication sharedApplication];
        id statusBar = [app valueForKeyPath:@"statusBar"];

        //        非 iPhone X
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}


- (void)showSusPlayer:(NSDictionary *)dic andVideoSize:(CGSize)size{
    if (susPlayer) {
        [susPlayer removeFromSuperview];
        susPlayer = nil;
    }
    CGFloat hhhhhh;
    if (size.width > 0) {
        hhhhhh = _window_width * 0.3 * (size.height/size.width);
    }else{
        hhhhhh = _window_width * 0.6;
    }
    susPlayer = [[WYSuspensionPlayer alloc]initWithFrame:CGRectMake(0, 0, _window_width*0.3, hhhhhh) andRoomMessage:dic];
    [[[UIApplication sharedApplication].delegate window] addSubview:susPlayer];
    [UIView animateWithDuration:0.3 animations:^{
        susPlayer.bottom = _window_height-ShowDiff-50;
        susPlayer.right = _window_width;
    }];
}
- (void)removeSusPlayer{
    if (susPlayer) {
        [susPlayer stopPlay];
        [susPlayer removeFromSuperview];
        susPlayer = nil;
    }

}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
     NSRange range2 = {0,mutStr.length};

     //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
