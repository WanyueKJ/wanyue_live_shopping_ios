//
//  cityDefault.m
//  yunbaolive
//
//  Created by 王敏欣 on 2016/12/13.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "cityDefault.h"
NSString *const  mycity = @"city";
NSString *const  mylng = @"lng";
NSString *const  mylat = @"lat";
NSString *const  addr = @"addr";

NSString *const  isreg = @"isreg";


@implementation cityDefault

+(void) updateProfile:(liveCity *)city
{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(city.lng!=nil) [userDefaults setObject:city.lng forKey:mylng];
        if(city.lat!=nil) [userDefaults setObject:city.lat forKey:mylat];
        if(city.city!=nil) [userDefaults setObject:city.city forKey:mycity];
        if(city.addr!=nil) [userDefaults setObject:city.addr forKey:addr];
        [userDefaults synchronize];
}
+ (void)saveProfile:(liveCity *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.city forKey:mycity];
    [userDefaults setObject:user.lng forKey:mylng];
    [userDefaults setObject:user.lat forKey:mylat];
    [userDefaults setObject:user.addr forKey:addr];
    [userDefaults synchronize];
}
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:mycity];
    [userDefaults setObject:nil forKey:mylat];
    [userDefaults setObject:nil forKey:mylat];
    [userDefaults setObject:nil forKey:addr];
    [userDefaults synchronize];
}
+ (liveCity *)myProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    liveCity *user = [[liveCity alloc] init];
    user.city = [userDefaults objectForKey:mycity];
    user.lng = [userDefaults objectForKey:mylng];
    user.lat = [userDefaults objectForKey:mylat];
    user.addr = [userDefaults objectForKey:addr];
    return user;
}
+(NSString *)getMyCity{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* citys = [userDefaults objectForKey: mycity];
    return citys;    
}
+(NSString *)getMylng{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* lng = [userDefaults objectForKey: mylng];
    return lng;
}
+(NSString *)getMylat{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* lat = [userDefaults objectForKey: mylat];
    return lat;
}
+(NSString *)getaddr{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* lat = [userDefaults objectForKey: addr];
    return lat;    
}
+(void)saveisreg:(NSString *)isregs{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isregs forKey:isreg];
    [userDefaults synchronize];
}
+(NSString *)getreg{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *gameStates = [userDefults objectForKey:isreg];
    return gameStates;
}
@end
