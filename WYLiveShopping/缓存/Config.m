//
//  Config.m
//  yunbaolive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "Config.h"

NSString * const WY_Uid = @"uid";
NSString * const WY_Avatar = @"avatar";
NSString * const WY_Nickname = @"nickname";
NSString * const WY_real_name = @"real_name";
NSString * const WY_Token = @"token";
NSString * const WY_birthday = @"birthday";
NSString * const WY_card_id = @"card_id";
NSString * const WY_partner_id = @"partner_id";
NSString * const WY_group_id = @"group_id";
NSString * const WY_phone = @"phone";
NSString * const WY_now_money = @"now_money";
NSString * const WY_integral = @"integral";
NSString * const WY_sign_num = @"sign_num";
NSString * const WY_level = @"level";
NSString * const WY_spread_uid = @"spread_uid";
NSString * const WY_spread_time = @"spread_time";
NSString * const WY_user_type = @"user_type";
NSString * const WY_is_promoter = @"is_promoter";
NSString * const WY_pay_count = @"pay_count";
NSString * const WY_spread_count = @"spread_count";
NSString * const WY_addres = @"addres";
NSString * const WY_isshop = @"isshop";
NSString * const WY_mycoin = @"mycoin";

@implementation Config

#pragma mark - user profile




+ (void)saveProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.uid forKey:WY_Uid];
    [userDefaults setObject:user.real_name forKey:WY_real_name];
    [userDefaults setObject:user.birthday forKey:WY_birthday];
    [userDefaults setObject:user.card_id forKey:WY_card_id];
    [userDefaults setObject:user.partner_id forKey:WY_partner_id];
    [userDefaults setObject:user.group_id forKey:WY_group_id];
    [userDefaults setObject:user.nickname forKey:WY_Nickname];
    [userDefaults setObject:user.avatar forKey:WY_Avatar];
    [userDefaults setObject:user.phone forKey:WY_phone];
    [userDefaults setObject:user.now_money forKey:WY_now_money];
    [userDefaults setObject:user.integral forKey:WY_integral];
    [userDefaults setObject:user.sign_num forKey:WY_sign_num];
    [userDefaults setObject:user.level forKey:WY_level];
    [userDefaults setObject:user.spread_uid forKey:WY_spread_uid];
    [userDefaults setObject:user.spread_time forKey:WY_spread_time];
    [userDefaults setObject:user.user_type forKey:WY_user_type];
    [userDefaults setObject:user.is_promoter forKey:WY_is_promoter];
    [userDefaults setObject:user.pay_count forKey:WY_pay_count];
    [userDefaults setObject:user.spread_count forKey:WY_spread_count];
    [userDefaults setObject:user.addres forKey:WY_addres];
    [userDefaults setObject:user.isshop forKey:WY_isshop];
    [userDefaults setObject:user.coin forKey:WY_mycoin];
    [userDefaults synchronize];
    
}
+ (void)updateProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(user.real_name != nil) [userDefaults setObject:user.real_name forKey:WY_real_name];
    if(user.birthday != nil) [userDefaults setObject:user.birthday forKey:WY_birthday];
    if(user.nickname!=nil) [userDefaults setObject:user.nickname forKey:WY_Nickname];
    if(user.avatar!=nil) [userDefaults setObject:user.avatar forKey:WY_Avatar];
    if(user.now_money!=nil) [userDefaults setObject:user.now_money forKey:WY_now_money];
    if(user.integral!=nil) [userDefaults setObject:user.integral forKey:WY_integral];
    if(user.addres!=nil) [userDefaults setObject:user.addres forKey:WY_addres];
    if(user.spread_count!=nil) [userDefaults setObject:user.spread_count forKey:WY_spread_count];
    if(user.group_id!=nil) [userDefaults setObject:user.group_id forKey:WY_group_id];
    if(user.level!=nil) [userDefaults setObject:user.level forKey:WY_level];
    if(user.partner_id!=nil) [userDefaults setObject:user.partner_id forKey:WY_partner_id];
    if(user.sign_num!=nil) [userDefaults setObject:user.sign_num forKey:WY_sign_num];
    if(user.spread_uid!=nil) [userDefaults setObject:user.spread_uid forKey:WY_spread_uid];
    if(user.spread_time!=nil) [userDefaults setObject:user.spread_time forKey:WY_spread_time];
    if(user.user_type!=nil) [userDefaults setObject:user.user_type forKey:WY_user_type];
    if(user.pay_count!=nil) [userDefaults setObject:user.pay_count forKey:WY_pay_count];
    if(user.is_promoter!=nil) [userDefaults setObject:user.is_promoter forKey:WY_is_promoter];
    if(user.isshop!=nil) [userDefaults setObject:user.isshop forKey:WY_isshop];
    if(user.coin!=nil) [userDefaults setObject:user.coin forKey:WY_mycoin];
    [userDefaults synchronize];
}

+ (void)clearProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:WY_Uid];
    [userDefaults setObject:nil forKey:WY_Avatar];
    [userDefaults setObject:nil forKey:WY_Nickname];
    [userDefaults setObject:nil forKey:WY_real_name];
    [userDefaults setObject:nil forKey:WY_Token];
    [userDefaults setObject:nil forKey:WY_birthday];
    [userDefaults setObject:nil forKey:WY_card_id];
    [userDefaults setObject:nil forKey:WY_partner_id];
    [userDefaults setObject:nil forKey:WY_group_id];
    [userDefaults setObject:nil forKey:WY_phone];
    [userDefaults setObject:nil forKey:WY_now_money];
    [userDefaults setObject:nil forKey:WY_integral];
    [userDefaults setObject:nil forKey:WY_sign_num];
    [userDefaults setObject:nil forKey:WY_level];
    [userDefaults setObject:nil forKey:WY_spread_uid];
    [userDefaults setObject:nil forKey:WY_spread_time];
    [userDefaults setObject:nil forKey:WY_user_type];
    [userDefaults setObject:nil forKey:WY_is_promoter];
    [userDefaults setObject:nil forKey:WY_pay_count];
    [userDefaults setObject:nil forKey:WY_addres];
    [userDefaults setObject:nil forKey:WY_isshop];
    [userDefaults setObject:nil forKey:WY_mycoin];

    [userDefaults synchronize];
}

+ (LiveUser *)myProfile
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LiveUser *user = [[LiveUser alloc] init];
    user.avatar = [userDefaults objectForKey: WY_Avatar];
    user.birthday = [userDefaults objectForKey: WY_birthday];
    user.coin = [userDefaults objectForKey: WY_mycoin];
    //user.level_anchor = [userDefaults objectForKey: Klevel_anchor];
    user.uid = [userDefaults objectForKey: WY_Uid];
    //user.sex = [userDefaults objectForKey: WY_se];
    user.token = [userDefaults objectForKey: WY_Token];
    user.nickname = [userDefaults objectForKey: WY_Nickname];
    user.addres = [userDefaults objectForKey: WY_addres];
    //user.isshop
   // user.signature = [userDefaults objectForKey:wy_si];
    user.level = [userDefaults objectForKey:WY_level];
    //user.city = [userDefaults objectForKey:Kcity];
    //user.avatar_thumb = [userDefaults objectForKey:kavatar_thumb];
    //user.login_type = [userDefaults objectForKey:Klogin_type];
    //user.usersig = [userDefaults objectForKey:Kusersig];
//    user.isauth = [userDefaults objectForKey:Kisauth];
//
//    user.isreg = [userDefaults objectForKey:Kisreg];

    return user;
}

+(NSString *)getOwnID{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_Uid]);
    return value;

}
+(NSString *)getOwnNicename{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_Nickname]);
    return value;

}
+(NSString *)getOwnToken{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_Token]);
    return value;
}
+(NSString *)getavatar{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_Avatar]);
    return value;

}
+(NSString *)getLevel{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_level]);
    return value;
}
+(NSString *)getcoin{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_now_money]);
    return value;
}
+(NSString *)getAddr{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_addres]);
    return value;

}
+(NSString *)getRealName{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_real_name]);
    return value;
}
+(NSString *)getBirthday{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_birthday]);
    return value;
}
+(NSString *)getCard_id{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_card_id]);
    return value;
}
+(NSString *)getPartner_id{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_partner_id]);
    return value;
}
+(NSString *)getGroup_id{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_group_id]);
    return value;
}
+(NSString *)getPhoneNum{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_phone]);
    return value;
}
+(NSString *)getIntegral{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_integral]);
    return value;
}
+(NSString *)getSign_num{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_sign_num]);
    return value;
}
+(NSString *)getSpread_uid{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_spread_uid]);
    return value;
}
+(NSString *)getSpread_time{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_spread_time]);
    return value;
}
+(NSString *)getUser_type{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_user_type]);
    return value;
}
+(NSString *)getPay_count{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_pay_count]);
    return value;
}
+(NSString *)getSpread_count{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_spread_count]);
    return value;
}
+(NSString *)getIsShop{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *value = minstr([userDefults objectForKey:WY_isshop]);
    return value;
}

+(void)saveOwnToken:(NSString *)token{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    [userDefults setObject:token forKey:WY_Token];
    [userDefults synchronize];
}
///保存是否是商铺
+(void)saveIsShop:(NSString *)isshop{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    [userDefults setObject:isshop forKey:WY_isshop];
    [userDefults synchronize];
}

+(void)saveIcon:(NSString *)coin{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    [userDefults setObject:coin forKey:WY_mycoin];
    [userDefults synchronize];
}
+(NSString *)getNowIcon{
    return [[NSUserDefaults standardUserDefaults] objectForKey:WY_mycoin];
}
@end
