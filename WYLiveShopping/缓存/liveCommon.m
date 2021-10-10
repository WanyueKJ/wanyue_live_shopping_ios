//
//  liveCommon.m
//  
//
//  Created by 王敏欣 on 2017/1/18.
//
//
#import "liveCommon.h"
@implementation liveCommon
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        
        self.site_name = minstr([dic valueForKey:@"site_name"]);
        self.app_url = minstr([dic valueForKey:@"app_url"]);
        self.routine_ver_rl = minstr([dic valueForKey:@"routine_ver_rl"]);
        self.shop_url = minstr([dic valueForKey:@"shop_url"]);

        self.coin_name = minstr(dic[@"coin_name"]);
        self.name_votes = minstr(dic[@"votes_name"]);
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
