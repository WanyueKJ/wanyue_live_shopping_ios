

#import <Foundation/Foundation.h>
#import "LiveUser.h"

@interface Config : NSObject
+ (void)saveProfile:(LiveUser *)user;
+ (void)updateProfile:(LiveUser *)user;
+ (void)clearProfile;
+ (LiveUser *)myProfile;
+(NSString *)getOwnID;
+(NSString *)getOwnNicename;
+(NSString *)getOwnToken;
+(NSString *)getavatar;
+(NSString *)getLevel;
+(NSString *)getcoin;
+(NSString *)getAddr;
+(NSString *)getRealName;
+(NSString *)getBirthday;
+(NSString *)getCard_id;
+(NSString *)getPartner_id;
+(NSString *)getGroup_id;
+(NSString *)getPhoneNum;
+(NSString *)getIntegral;
+(NSString *)getSign_num;
+(NSString *)getSpread_uid;
+(NSString *)getSpread_time;
+(NSString *)getUser_type;
+(NSString *)getPay_count;
+(NSString *)getSpread_count;
+(NSString *)getIsShop;
///保存token
+(void)saveOwnToken:(NSString *)token;
///保存是否是商铺
+(void)saveIsShop:(NSString *)isshop;
//更新金币
+(void)saveIcon:(NSString *)coin;
+(NSString *)getNowIcon;
@end
