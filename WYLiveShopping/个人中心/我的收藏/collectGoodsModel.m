//
//  collectGoodsModel.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "collectGoodsModel.h"

@implementation collectGoodsModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = minstr([dic valueForKey:@"image"]);
        self.store_name = minstr([dic valueForKey:@"store_name"]);
        self.pid = minstr([dic valueForKey:@"pid"]);
        self.price = minstr([dic valueForKey:@"price"]);
        self.ot_price = minstr([dic valueForKey:@"ot_price"]);
        self.sales = minstr([dic valueForKey:@"sales"]);
        self.sales = minstr([dic valueForKey:@"sales"]);
        self.category = minstr([dic valueForKey:@"category"]);
        if ([dic valueForKey:@"vip_price"]) {
            self.vip_price = minstr([dic valueForKey:@"vip_price"]);
        }else{
            self.vip_price = @"";
        }
    }
    return self;
}

@end
