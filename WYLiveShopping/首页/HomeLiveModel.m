//
//  HomeLiveModel.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "HomeLiveModel.h"

@implementation HomeLiveModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _originDic = dic;
        self.thumb = minstr([dic valueForKey:@"thumb"]);
        self.uid = minstr([dic valueForKey:@"uid"]);
        self.titleStr = minstr([dic valueForKey:@"title"]);
        self.classid = minstr([dic valueForKey:@"classid"]);
        self.province = minstr([dic valueForKey:@"province"]);
        self.city = minstr([dic valueForKey:@"city"]);
        self.showid = minstr([dic valueForKey:@"showid"]);
        self.goodsnum = minstr([dic valueForKey:@"goodsnum"]);
        self.likes = minstr([dic valueForKey:@"likes"]);
        self.nums = minstr([dic valueForKey:@"nums"]);
        self.pull = minstr([dic valueForKey:@"pull"]);
        self.nickname = minstr([dic valueForKey:@"nickname"]);
        self.avatar = minstr([dic valueForKey:@"avatar"]);
        self.goods_img = minstr([dic valueForKey:@"goods_img"]);
        self.stream = minstr([dic valueForKey:@"stream"]);
    }
    return self;
}

@end
