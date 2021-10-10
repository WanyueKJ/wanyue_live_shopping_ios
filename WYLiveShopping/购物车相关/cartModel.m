//
//  cartModel.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "cartModel.h"

@implementation cartModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.cart_id = minstr([dic valueForKey:@"id"]);
        NSDictionary *productInfo = [dic valueForKey:@"productInfo"];
        NSDictionary *attrInfo = [productInfo valueForKey:@"attrInfo"];
        if (attrInfo && [attrInfo count] > 0) {
            self.image = minstr([attrInfo valueForKey:@"image"]);
            self.price = minstr([attrInfo valueForKey:@"price"]);
            self.suk = minstr([attrInfo valueForKey:@"suk"]);
            self.stock = minstr([attrInfo valueForKey:@"stock"]);
        }else{
            self.image = minstr([productInfo valueForKey:@"image"]);
            self.price = minstr([productInfo valueForKey:@"price"]);
            self.stock = minstr([productInfo valueForKey:@"stock"]);
            self.suk = @"默认";
        }
        self.goods_id = minstr([productInfo valueForKey:@"id"]);
        self.store_name = minstr([productInfo valueForKey:@"store_name"]);
        self.cart_num = minstr([dic valueForKey:@"cart_num"]);
        self.unique = minstr([dic valueForKey:@"unique"]);
        self.is_reply = minstr([dic valueForKey:@"is_reply"]);

        self.isSelected = YES;
    }
    return self;
}

@end
