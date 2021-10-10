//
//  historyProfitViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface historyProfitViewController : WYBaseViewController
/// 收益类型 0：分销收益 1:店铺收益 2:推广收益
@property (nonatomic,assign) int ptofitType;

@end

NS_ASSUME_NONNULL_END
