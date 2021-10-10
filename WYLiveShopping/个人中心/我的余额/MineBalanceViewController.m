//
//  MineBalanceViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MineBalanceViewController.h"
#import "recommendView.h"
#import "WYButton.h"
#import "homeViewController.h"
#import "BilldetailsViewController.h"

@interface MineBalanceViewController ()
@property (nonatomic,strong) HoverPageScrollView *backScrollView;
@property (nonatomic,strong) recommendView *recommendV;

@end

@implementation MineBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"我的账户";
    [self.view addSubview:self.backScrollView];
    [self addSubViews];
}
-(HoverPageScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[HoverPageScrollView alloc]init];
        _backScrollView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight);
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.bounces = NO;
        _backScrollView.contentSize = CGSizeMake(0, (_window_width-30) * 0.48 + 112 + _backScrollView.height);
        if (@available(iOS 11.0, *)){
            _backScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

    }
    return _backScrollView;
}
- (void)addSubViews{
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, _window_width-30, (_window_width-30) * 0.48)];
    backImgView.image = [UIImage imageNamed:@"我的余额背景"];
    [_backScrollView addSubview:backImgView];
    NSArray *array = @[@"总资产(元)",@"累计消费(元)"];
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = SYS_Font(12);
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        label.text = array[i];
        [backImgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backImgView).offset(25);
            if (i == 0) {
                make.top.equalTo(backImgView).offset(20);
            }else{
                make.top.equalTo(backImgView.mas_centerY).offset(20);
            }
        }];
        UILabel *label2 = [[UILabel alloc]init];
        if (i == 0) {
            label2.font = [UIFont boldSystemFontOfSize:35];
            label2.text = minstr([_userMsgDic valueForKey:@"now_money"]);
        }else{
            label2.font = SYS_Font(19);
            label2.text = minstr([_userMsgDic valueForKey:@"orderStatusSum"]);
        }
        label2.textColor = [UIColor whiteColor];
        [backImgView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(11);
        }];
    }
    NSArray * array2 = @[@"账单记录",@"消费记录"];
    for (int i = 0; i < array2.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(25 + i * (60+50), backImgView.bottom+17, 60, 60);
        [btn setImage:[UIImage imageNamed:array2[i]] forState:0];
        [btn setTitle:array2[i] forState:0];
        [btn setTitleColor:RGB_COLOR(@"#999999", 1) forState:0];
        btn.titleLabel.font = SYS_Font(13);
//        [btn setShowImage:[UIImage imageNamed:array2[i]]];
//        [btn setShowText:array2[i]];
//        btn.showTitleLabel.font = SYS_Font(13);
//        btn.showTitleLabel.textColor = RGB_COLOR(@"#999999", 1);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backScrollView addSubview:btn];
        btn = [WYToolClass setUpImgDownText:btn space:14];
    }
    [_backScrollView addSubview:self.recommendV];

}
-(recommendView *)recommendV{
    if (!_recommendV) {
        _recommendV = [[recommendView alloc]initWithFrame:CGRectMake(0, (_window_width-30) * 0.48 + 112, _window_width, _backScrollView.height) andNothingImage:nil];
    }
    return _recommendV;
}
- (void)buttonClick:(UIButton *)sender{
    BilldetailsViewController *vc = [[BilldetailsViewController alloc]init];
    vc.showIndex = (int)sender.tag -1000;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
