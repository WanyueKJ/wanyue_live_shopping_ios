//
//  orderModel.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/20.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.orderID = minstr([dic valueForKey:@"id"]);
        self.orderNums = minstr([dic valueForKey:@"order_id"]);
        self.pay_type = minstr([dic valueForKey:@"pay_type"]);
        self.status = minstr([dic valueForKey:@"status"]);
        self.total_price = minstr([dic valueForKey:@"total_price"]);
        self.pay_price = minstr([dic valueForKey:@"pay_price"]);
        self.paid = minstr([dic valueForKey:@"paid"]);
        self.status_name = minstr([dic valueForKey:@"status_name"]);
        self.store_name = minstr([dic valueForKey:@"shop_name"]);
        self.total_num = minstr([dic valueForKey:@"total_num"]);
        self.add_time = minstr([dic valueForKey:@"_add_time"]);
        self.bring_price = minstr([dic valueForKey:@"bring_total"]);
        self.refund_status = minstr([dic valueForKey:@"refund_status"]);
        self.goodsArray = [NSMutableArray array];
        NSArray *cart_info = [dic valueForKey:@"cartInfo"];
        for (NSDictionary *gdic in cart_info) {
            cartModel *model = [[cartModel alloc]initWithDic:gdic];
            [_goodsArray addObject:model];
        }
        _rowH = _goodsArray.count * 80 + 145;
    }
    return self;
}
@end
