//
//  WYManagerModel.h
//  iphoneLive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYManagerModel : NSObject


@property(nonatomic,strong)NSString *time;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *level;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *signature;

@property(nonatomic,copy)NSString *icon;

@property(nonatomic,copy)NSString *level_anchor;

@property(nonatomic,copy)NSString *level_icon;//用户等级图标
@property(nonatomic,copy)NSString *level_anchor_icon;//主播等级图标
@property(nonatomic,copy)NSString *living;//直播状态
@property(nonatomic,copy)NSString *stream;
@property(nonatomic,copy)NSString *isVip;
@property(nonatomic,copy)NSString *btn;

@property(nonatomic,copy)NSString *isattention;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,strong)NSString *fansNum;

-(instancetype)initWithDic:(NSDictionary *)dic;


+(instancetype)modelWithDic:(NSDictionary *)dic;


@end
