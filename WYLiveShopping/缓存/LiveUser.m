//
//  LiveUser.m
//  yunbaolive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveUser.h"

@implementation LiveUser


-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        self.avatar = minstr([dic valueForKey:@"avatar"]);
        self.uid = minstr([dic valueForKey:@"uid"]);
        self.real_name = minstr([dic valueForKey:@"real_name"]);
        self.birthday = minstr([dic valueForKey:@"birthday"]);
        self.card_id = minstr([dic valueForKey:@"card_id"]);
        self.partner_id = minstr([dic valueForKey:@"partner_id"]);
        self.group_id = minstr([dic valueForKey:@"group_id"]);
        self.nickname = minstr([dic valueForKey:@"nickname"]);
        self.integral = minstr([dic valueForKey:@"integral"]);
        self.phone = minstr([dic valueForKey:@"phone"]);
        self.now_money = minstr([dic valueForKey:@"now_money"]);
        self.sign_num = minstr([dic valueForKey:@"sign_num"]);
        self.level = minstr([dic valueForKey:@"level"]);
        self.spread_uid = minstr([dic valueForKey:@"spread_uid"]);
        self.spread_time = minstr([dic valueForKey:@"spread_time"]);
        self.user_type = minstr([dic valueForKey:@"user_type"]);
        self.is_promoter = minstr([dic valueForKey:@"is_promoter"]);
        self.pay_count = minstr([dic valueForKey:@"pay_count"]);
        self.spread_count = minstr([dic valueForKey:@"spread_count"]);
        self.addres = minstr([dic valueForKey:@"addres"]);
        self.token = minstr([dic valueForKey:@"token"]);
        self.login_type = minstr([dic valueForKey:@"login_type"]);
        self.broken_commission = minstr([dic valueForKey:@"broken_commission"]);
        self.brokerage_price = minstr([dic valueForKey:@"brokerage_price"]);
        self.adminid = minstr([dic valueForKey:@"adminid"]);
        self.commissionCount = minstr([dic valueForKey:@"commissionCount"]);
        self.isshop = minstr([dic valueForKey:@"isshop"]);
        self.votestotal = minstr([dic valueForKey:@"votestotal"]);

        self.coin = minstr(dic[@"coin"]);

    }
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
