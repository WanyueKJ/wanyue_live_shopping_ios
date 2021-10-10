//
//  YBAlertView.m
//  live1v1
//
//  Created by IOS1 on 2019/5/9.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import "WYAlertView.h"

@implementation WYAlertView{
    
    UIView *whiteView;
}
- (void)whiteViewClick{
    
}
- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message andButtonArrays:(NSArray *)array andButtonClick:(buttonClick)block{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        self.block = block;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideButtonClick)];
        [self addGestureRecognizer:tap];
        [self creatUIWithTitle:title andMessage:message andButtonArrays:array];
    }
    return self;
}
- (void)creatUIWithTitle:(NSString *)title andMessage:(NSString *)message andButtonArrays:(NSArray *)array{
    whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.72);
        make.centerY.equalTo(self).multipliedBy(3);
        make.centerX.equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteViewClick)];
    [whiteView addGestureRecognizer:tap];

    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = title;
    titleL.textColor = color32;
    titleL.font = SYS_Font(13);
    [whiteView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(whiteView).offset(10);
    }];
    
    UILabel *mssageL = [[UILabel alloc]init];
    mssageL.text = message;
    mssageL.textColor = color64;
    mssageL.font = SYS_Font(13);
    mssageL.numberOfLines = 0;
    mssageL.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:mssageL];
    [mssageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(titleL.mas_bottom).offset(15);
        make.width.lessThanOrEqualTo(whiteView).multipliedBy(0.72);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB_COLOR(@"#e5e5e5", 1);
    [whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(mssageL.mas_bottom).offset(20);
        make.width.equalTo(whiteView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(whiteView).offset(-40);
    }];
    CGFloat btnWidth = _window_width*0.72/array.count;
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        btn.titleLabel.font = SYS_Font(13);
        btn.tag = 600+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        if (i == 0) {
            [btn setTitleColor:color96 forState:0];
        }else{
            [btn setTitleColor:normalColors forState:0];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).offset(i*btnWidth);
            make.top.equalTo(lineView.mas_bottom);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(40);
        }];
        if (i != array.count -1) {
            UIView *lineV = [[UIView alloc]init];
            lineV.backgroundColor = RGB_COLOR(@"#e5e5e5", 1);
            [whiteView addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_right);
                make.top.equalTo(btn);
                make.width.mas_equalTo(1);
                make.height.equalTo(btn);
            }];
        }
    }
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];
    }];

}
- (void)btnClick:(UIButton *)sender{
    self.block((int)sender.tag-599);
}
- (void)hideButtonClick{
    self.block(0);
}

@end
