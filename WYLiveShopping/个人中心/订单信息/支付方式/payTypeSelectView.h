//
//  payTypeSelectView.h
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^payTypeBlock)(NSString *type);
@interface payTypeSelectView : UIView
- (void)show;
@property (nonatomic,copy) payTypeBlock block;

@end

NS_ASSUME_NONNULL_END
