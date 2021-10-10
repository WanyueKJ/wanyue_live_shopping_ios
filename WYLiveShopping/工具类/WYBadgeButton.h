//
//  CQBadgeButton.h
//  BadgeButton
//
//  Created by caiqiang on 2019/3/11.
//  Copyright © 2019 Caiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYBadgeButton : UIButton

/**
 显示角标
 
 @param badgeNumber 角标数量
 */
- (void)showBadgeWithNumber:(NSInteger)badgeNumber;

/** 隐藏角标 */
- (void)hideBadge;

@end

NS_ASSUME_NONNULL_END
