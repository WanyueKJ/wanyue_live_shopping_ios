//
//  CQBadgeButton.m
//  BadgeButton
//
//  Created by caiqiang on 2019/3/11.
//  Copyright © 2019 Caiqiang. All rights reserved.
//

#import "WYBadgeButton.h"

@interface WYBadgeButton ()

/** 显示按钮角标的label */
@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation WYBadgeButton

#pragma mark - 构造方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize {
    // button属性设置
    self.clipsToBounds = NO;
    //------- 角标label -------//
    self.badgeLabel = [[UILabel alloc] init];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.badgeLabel];
    self.badgeLabel.backgroundColor = normalColors;
    self.badgeLabel.font = [UIFont systemFontOfSize:9];
    self.badgeLabel.textColor = [UIColor whiteColor];
    self.badgeLabel.layer.cornerRadius = 7;
    self.badgeLabel.clipsToBounds = YES;
    // 默认隐藏
    self.badgeLabel.hidden = YES;
}

#pragma mark - 布局变化时调整UI

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refresh];
}

- (void)refresh {
    [self layoutIfNeeded];
    // 调整角标label的大小和位置
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageView.mas_top).offset(1);
        make.centerX.equalTo(self.imageView.mas_right).offset(2);
        make.height.mas_equalTo(14);
        make.width.mas_greaterThanOrEqualTo(14);
    }];
}

#pragma mark - 显示角标

/**
 显示角标
 
 @param badgeNumber 角标数量
 */
- (void)showBadgeWithNumber:(NSInteger)badgeNumber {
    if (badgeNumber == 0) {
        _badgeLabel.hidden = YES;
    }else{
        _badgeLabel.hidden = NO;
    }
    // 注意数字前后各留一个空格，不然太紧凑
    if (badgeNumber > 99) {
        badgeNumber = 99;
    }
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld",badgeNumber];
    // 赋值后调整UI
    [self refresh];
}

#pragma mark - 隐藏角标

/** 隐藏角标 */
- (void)hideBadge {
    self.badgeLabel.hidden = YES;
}

@end
