//
//  cartModel.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface cartModel : NSObject
@property (nonatomic,strong) NSString *cart_id;
@property (nonatomic,strong) NSString *cart_num;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *suk;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *stock;
@property (nonatomic,strong) NSString *unique;
@property (nonatomic,strong) NSString *is_reply;

@property (nonatomic,assign) BOOL isSelected;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
