//
//  registerAndForgetViewController.h
//  YBEducation
//
//  Created by IOS1 on 2020/2/27.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^registerSucessBlock)(NSString *phone,NSString *code);
@interface registerAndForgetViewController : WYBaseViewController
@property (nonatomic,assign) BOOL isregister;
@property (nonatomic,copy) registerSucessBlock block;

@end

NS_ASSUME_NONNULL_END
