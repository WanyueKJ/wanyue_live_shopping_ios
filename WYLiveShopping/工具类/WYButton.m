//
//  YBButton.m
//  YBPlaying
//
//  Created by IOS1 on 2019/11/4.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import "WYButton.h"

@implementation WYButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSubview:self.showImgView];
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.height.equalTo(self).multipliedBy(0.5);
        make.width.equalTo(_showImgView.mas_height);
    }];
    [self addSubview:self.showTitleLabel];
    [_showTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
    [self addSubview:self.badgeLabel];
    // 调整角标label的大小和位置
    [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_showImgView.mas_top).offset(1);
        make.centerX.equalTo(_showImgView.mas_right).offset(2);
        make.height.mas_equalTo(14);
        make.width.mas_greaterThanOrEqualTo(14);
    }];

}
- (UIImageView *)showImgView{
    if (!_showImgView) {
        _showImgView = [[UIImageView alloc]init];
        _showImgView.contentMode = UIViewContentModeScaleAspectFill;
        _showImgView.clipsToBounds = YES;
        _showImgView.image = _showImage;
    }
    return _showImgView;
}
- (UILabel *)showTitleLabel{
    if (!_showTitleLabel) {
        _showTitleLabel = [[UILabel alloc]init];
        _showTitleLabel.font = _textFont ? _textFont : SYS_Font(13);
        _showTitleLabel.textColor = _textColoro ? _textColoro : color96;
        _showTitleLabel.text = _showText;
    }
    return _showTitleLabel;
}
-(UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = normalColors;
        _badgeLabel.font = [UIFont systemFontOfSize:9];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.layer.cornerRadius = 7;
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        // 默认隐藏
        _badgeLabel.hidden = YES;
    }
    return _badgeLabel;
}
- (void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    _showImgView.image = _showImage;
}
-(void)setShowText:(NSString *)showText{
    _showText = showText;
    _showTitleLabel.text = _showText;
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
        // 注意数字前后各留一个空格，不然太紧凑
        _badgeLabel.text = [NSString stringWithFormat:@"%ld",badgeNumber];
    }
}

@end
