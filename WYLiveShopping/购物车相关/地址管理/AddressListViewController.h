//
//  AddressListViewController.h
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^addressSelectedBlock)(NSDictionary *dic);
@interface AddressListViewController : WYBaseViewController
@property (nonatomic,copy) addressSelectedBlock block;
@property (nonatomic,strong) NSString *curAddrID;

@end

NS_ASSUME_NONNULL_END
