//
//  liveCommon.h
//  
//
//  Created by 王敏欣 on 2017/1/18.
//
//

#import <Foundation/Foundation.h>

@interface liveCommon : NSObject

@property(nonatomic,  strong)NSString *app_url;//APP下载二维码
@property(nonatomic,  strong)NSString *routine_ver_rl;//小程序上架版本号
@property(nonatomic,  strong)NSString *site_name;//站点名称
@property(nonatomic,  strong)NSString *shop_url;//商铺后台地址
@property(nonatomic,  strong)NSString *coin_name;//钻石数
@property(nonatomic,  strong)NSString *name_votes;//映票数
-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
