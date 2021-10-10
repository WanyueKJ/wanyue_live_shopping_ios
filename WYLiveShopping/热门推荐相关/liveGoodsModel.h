//
//  liveGoodsModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface liveGoodsModel : NSObject
@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *goodsID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *is_sale;
@property (nonatomic,strong) NSString *salenums;
@property (nonatomic,strong) NSString *sales;
@property (nonatomic,strong) NSString *bring_price;
@property (nonatomic,strong) NSString *vip_price;

@property (nonatomic,assign) BOOL isAdmin;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
