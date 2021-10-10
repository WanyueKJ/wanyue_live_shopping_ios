#import "common.h"
NSString *const  wy_site_name = @"site_name";
NSString *const  wy_app_url = @"app_url";
NSString *const  wy_routine_ver_rl = @"routine_ver_rl";
NSString *const  wy_shop_url = @"shop_url";
NSString *const  wy_coin = @"wy_coin";
NSString *const  wy_votes = @"wy_votes";
@implementation common
+ (void)saveProfile:(liveCommon *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.site_name forKey:wy_site_name];
    [userDefaults setObject:user.app_url forKey:wy_app_url];
    [userDefaults setObject:user.routine_ver_rl forKey:wy_routine_ver_rl];
    [userDefaults setObject:user.shop_url forKey:wy_shop_url];
    [userDefaults setObject:user.coin_name forKey:wy_coin];
    [userDefaults setObject:user.name_votes forKey:wy_votes];
    [userDefaults synchronize];
}
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:wy_site_name];
    [userDefaults setObject:nil forKey:wy_coin];
    [userDefaults setObject:nil forKey:wy_app_url];
    [userDefaults setObject:nil forKey:wy_routine_ver_rl];
    [userDefaults setObject:nil forKey:wy_shop_url];
    [userDefaults setObject:nil forKey:wy_votes];

    [userDefaults synchronize];
}
+ (liveCommon *)myProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    liveCommon *user = [[liveCommon alloc] init];
    
    user.site_name = [userDefaults objectForKey:wy_site_name];
    user.app_url = [userDefaults objectForKey:wy_app_url];
    user.routine_ver_rl = [userDefaults objectForKey:wy_routine_ver_rl];
    user.shop_url = [userDefaults objectForKey:wy_shop_url];
    user.coin_name = [userDefaults objectForKey:wy_coin];
    user.name_votes = [userDefaults objectForKey:wy_votes];
    return user;
}
+(NSString *)site_name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_site_name];
    return str;
}
+(NSString *)app_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_app_url];
    return str;
}
+(NSString *)routine_ver_rl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_routine_ver_rl];
    return str;
}
+(NSString *)shop_url{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_shop_url];
    return str;
}

+(NSString *)name_coin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_coin];
    return str;
}
+(NSString *)name_votes{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str = [userDefaults objectForKey: wy_votes];
    return str;
}

@end
