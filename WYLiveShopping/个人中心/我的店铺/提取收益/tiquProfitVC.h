//
//  myProfitVC.h
//  yunbaolive
//
//  Created by Boom on 2018/9/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface tiquProfitVC : WYBaseViewController
@property (nonatomic,strong) NSString *moneyStr;
/// 收益类型 0：分销收益 1:店铺收益 2:推广收益
@property (nonatomic,assign) int ptofitType;

@end

NS_ASSUME_NONNULL_END
