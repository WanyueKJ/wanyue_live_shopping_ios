//
//  common.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/18.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "liveCommon.h"
@interface common : NSObject
+ (void)saveProfile:(liveCommon *)common;
+ (void)clearProfile;
+(liveCommon *)myProfile;
+(NSString *)site_name;
+(NSString *)app_url;
+(NSString *)routine_ver_rl;
+(NSString *)shop_url;
+(NSString *)name_coin;
+(NSString *)name_votes;
@end
