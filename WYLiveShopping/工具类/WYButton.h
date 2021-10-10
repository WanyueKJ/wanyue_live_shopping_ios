//
//  YBButton.h
//  YBPlaying
//
//  Created by IOS1 on 2019/11/4.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYButton : UIButton
@property (nonatomic,strong) UIImageView *showImgView;
@property (nonatomic,strong) UILabel *showTitleLabel;
@property (nonatomic,strong) UIImage *showImage;
@property (nonatomic,strong) NSString *showText;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *textColoro;
@property (nonatomic,strong) UILabel *badgeLabel;

/**
 显示角标
 
 @param badgeNumber 角标数量
 */
- (void)showBadgeWithNumber:(NSInteger)badgeNumber;

@end

NS_ASSUME_NONNULL_END
