//
//  PaySucessViewController.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/2.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYBaseViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaySucessViewController : WYBaseViewController
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) NSString *failReason;
@property (nonatomic,strong) NSString *liveUid;

@end

NS_ASSUME_NONNULL_END
