//
//  payTypeSelectView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "payTypeSelectView.h"

@implementation payTypeSelectView{
    UIView *showView;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    UIButton *hideBtn = [UIButton buttonWithType:0];
    hideBtn.frame = CGRectMake(0, 0, _window_width, _window_height-190-ShowDiff);
    [hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideBtn];
    showView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, 190+ShowDiff)];
    showView.backgroundColor = [UIColor whiteColor];
    [self addSubview:showView];
    showView.layer.mask = [[WYToolClass sharedInstance] setViewLeftTop:10 andRightTop:10 andView:showView];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, 49, _window_width-30, 1) andColor:RGB_COLOR(@"#f5f5f5", 1) andView:showView];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"选择付款方式";
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = color32;
    [showView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showView);
        make.centerY.equalTo(showView.mas_top).offset(25);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:0];
    [closeBtn setImage:[UIImage imageNamed:@"userMsg_close"] forState:0];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.equalTo(showView).offset(-10);
        make.centerY.equalTo(label);
    }];

    NSArray *array = @[@"微信支付",@"余额支付"];
    NSArray *array2 = @[@"微信快捷支付",[NSString stringWithFormat:@"可用余额：¥%@",[Config getcoin]]];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 50+i*60, _window_width, 60);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(payTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btn];
        UIImageView *imgV = [[UIImageView alloc]init];
        [imgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_small",array[i]]]];
        [btn addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(15);
            make.width.height.mas_equalTo(20);
        }];
        UILabel *titleL = [[UILabel alloc]init];
        titleL.text = array[i];
        titleL.font = SYS_Font(14);
        titleL.textColor = color32;
        [btn addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_centerY);
            make.left.equalTo(imgV.mas_right).offset(10);
        }];

        UILabel *tipsL = [[UILabel alloc]init];
        tipsL.font = SYS_Font(12);
        tipsL.textColor = color96;
        [btn addSubview:tipsL];
        [tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleL);
            make.top.equalTo(titleL.mas_bottom).offset(3);
        }];
        if (i == 0) {
            tipsL.text = array2[i];
        }else{
            tipsL.attributedText = [self getAtt:array2[i]];
        }
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
        [btn addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn);
            make.left.equalTo(imgV);
            make.right.equalTo(btn).offset(-15);
            make.height.mas_equalTo(1);
        }];
    }
    [self show];
}
- (NSAttributedString *)getAtt:(NSString *)str{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#fc9827", 1) range:NSMakeRange(5, str.length-5)];
    return attStr;
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        showView.bottom = _window_height;
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        showView.y = _window_height;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];

}
- (void)payTypeClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        self.block(@"weixin");
    }else{
        self.block(@"yue");
    }
    [self hide];
}
@end
