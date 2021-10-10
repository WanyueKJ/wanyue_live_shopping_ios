//
//  LiveUser.h
//  yunbaolive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUser : NSObject
///头像
@property (nonatomic, strong)NSString *avatar;
///编号
@property (nonatomic, strong)NSString *uid;
///姓名
@property (nonatomic, strong)NSString *real_name;
///生日
@property (nonatomic, strong)NSString *birthday;
///身份证
@property (nonatomic, strong)NSString *card_id;
///合伙人id
@property (nonatomic, strong)NSString *partner_id;
///用户分组id
@property (nonatomic, strong)NSString *group_id;
///昵称
@property (nonatomic, strong)NSString *nickname;
///积分
@property (nonatomic, strong)NSString *integral;
///手机号
@property (nonatomic, strong)NSString *phone;
///余额
@property (nonatomic, strong)NSString *now_money;
///签到次数
@property (nonatomic, strong)NSString *sign_num;
///等级
@property (nonatomic, strong)NSString *level;
///推广员编号
@property (nonatomic, strong)NSString *spread_uid;
///推广时间
@property (nonatomic, strong)NSString *spread_time;
///用户类型
@property (nonatomic, strong)NSString *user_type;
///是否为推广员
@property (nonatomic, strong)NSString *is_promoter;
///支付次数
@property (nonatomic, strong)NSString *pay_count;
///推广人数
@property (nonatomic, strong)NSString *spread_count;
///地址
@property (nonatomic, strong)NSString *addres;
///token
@property (nonatomic, strong)NSString *token;
///
@property (nonatomic,strong) NSString *login_type;
///
@property (nonatomic,strong) NSString *broken_commission;
///
@property (nonatomic,strong) NSString *brokerage_price;
///
@property (nonatomic,strong) NSString *adminid;
///
@property (nonatomic,strong) NSString *commissionCount;
///
@property (nonatomic,strong) NSString *isshop;
///
@property (nonatomic,strong) NSString *votestotal;
@property (nonatomic,strong) NSString *coin;

-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
