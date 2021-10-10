//
//  orderModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/20.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface orderModel : NSObject
@property (nonatomic,strong) NSString *orderID;//订单编号
@property (nonatomic,strong) NSString *orderNums;//订单号
@property (nonatomic,strong) NSString *pay_type;
@property (nonatomic,strong) NSString *status;//订单状态|0=待发货,1=待收货,2=待评价,3=已完成
@property (nonatomic,strong) NSString *total_price;
@property (nonatomic,strong) NSString *pay_price;
@property (nonatomic,strong) NSString *paid;//支付状态|1=已支付,0=未支付
@property (nonatomic,strong) NSString *status_name;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *total_num;
@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *bring_price;
@property (nonatomic,strong) NSString *refund_status;//退款状态|0=未退款,1=申请中,2=已退款
@property (nonatomic,strong) NSMutableArray *goodsArray;
@property (nonatomic,assign) CGFloat rowH;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
