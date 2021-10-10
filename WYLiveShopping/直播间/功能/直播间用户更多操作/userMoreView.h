//
//  userMoreView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^menuButtonBlock)(NSString *name);

@interface userMoreView : UIView
@property (nonatomic,copy) menuButtonBlock block;

@end

NS_ASSUME_NONNULL_END
