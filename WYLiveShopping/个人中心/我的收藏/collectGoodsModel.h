//
//  collectGoodsModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface collectGoodsModel : NSObject
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *ot_price;
@property (nonatomic,strong) NSString *is_show;
@property (nonatomic,strong) NSString *sales;
@property (nonatomic,strong) NSString *vip_price;
@property (nonatomic,strong) NSString *category;


-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
