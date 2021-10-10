//
//  addressModel.h
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface addressModel : NSObject
@property (nonatomic,strong) NSString *aID;//ID
@property (nonatomic,strong) NSString *name;//收货人
@property (nonatomic,strong) NSString *mobile;//电话
@property (nonatomic,strong) NSString *isdef;//是否默认地址，0否1是
@property (nonatomic,strong) NSString *province;//省
@property (nonatomic,strong) NSString *city;//市
@property (nonatomic,strong) NSString *area;//区
@property (nonatomic,strong) NSString *detail;//详细地址

-(instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
