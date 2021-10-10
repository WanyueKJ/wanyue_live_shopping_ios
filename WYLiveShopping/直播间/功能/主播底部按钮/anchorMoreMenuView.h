//
//  anchorMoreMenuView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^menuButtonBlock)(NSString *name);
@interface anchorMoreMenuView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,copy) menuButtonBlock block;
@property (nonatomic,assign) BOOL isTorch;

@end

NS_ASSUME_NONNULL_END
