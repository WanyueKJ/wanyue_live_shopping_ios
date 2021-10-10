//
//  RechargeViewController.h
//  live1v1
//
//  Created by IOS1 on 2019/4/4.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^rechargeSuccessBlock)(NSString *coin);
@interface RechargeViewController : WYBaseViewController
@property (nonatomic,copy) rechargeSuccessBlock block;

@end

NS_ASSUME_NONNULL_END
