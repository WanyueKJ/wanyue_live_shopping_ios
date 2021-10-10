//
//  YBAlertView.h
//  live1v1
//
//  Created by IOS1 on 2019/5/9.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^buttonClick)(int type);
@interface WYAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message andButtonArrays:(NSArray *)array andButtonClick:(buttonClick)block;
@property (nonatomic,copy) buttonClick block;

@end

NS_ASSUME_NONNULL_END
