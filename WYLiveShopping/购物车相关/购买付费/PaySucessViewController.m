//
//  PaySucessViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/2.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "PaySucessViewController.h"
#import "OrderDetailsViewController.h"
#import "LivePlayerViewController.h"

@interface PaySucessViewController (){
    UILabel *rightLabel;
    UIImageView *payStateImgView;
    UILabel *tipsLabel;
    UILabel *leftLabel;
    UIButton *detailsBtn;
}

@end

@implementation PaySucessViewController
- (void)doReturn{
    NSArray *temArray = self.navigationController.viewControllers;
    LivePlayerViewController *playerVC;
    for(UIViewController *temVC in temArray)
        
    {
        
        if ([temVC isKindOfClass:[LivePlayerViewController class]])
            
        {
            playerVC = (LivePlayerViewController *)temVC;
            
        }
        
    }
    if (playerVC) {
        [self.navigationController popToViewController:playerVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = colorf0;
    [self creatUI];
    [self requestData];
}
- (void)creatUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, self.naviView.bottom + 60, _window_width-30, 420)];
    [self.view addSubview:view];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, view.width, view.height - 30)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10;
    [view addSubview:whiteView];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/2-30, 0, 60, 60)];
//    imgV.image = [UIImage imageNamed:@"支付成功"];
    [view addSubview:imgV];
    payStateImgView = imgV;
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, whiteView.width, 40)];
    tLabel.font =[UIFont boldSystemFontOfSize:15];
//    tLabel.text = @"订单支付成功";
    tLabel.textColor = color32;
    tLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:tLabel];
    tipsLabel = tLabel;
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, tLabel.bottom+5, whiteView.width-30, 1) andColor:colorf0 andView:whiteView];
    leftLabel = [[UILabel alloc]init];
    leftLabel.font = SYS_Font(14);
    leftLabel.textColor = color32;
    leftLabel.numberOfLines = 0;
    leftLabel.text = @"订单编号\n\n下单时间\n\n支付方式\n\n支付金额";
    [whiteView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(15);
        make.top.equalTo(tLabel.mas_bottom).offset(20);
    }];
    rightLabel = [[UILabel alloc]init];
    rightLabel.font = SYS_Font(14);
    rightLabel.textColor = RGB_COLOR(@"#656565", 1);
    rightLabel.numberOfLines = 0;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-15);
        make.top.equalTo(leftLabel);
    }];
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = colorf0;
    [whiteView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel);
        make.right.equalTo(rightLabel);
        make.top.equalTo(leftLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    NSArray *array;
    if (_liveUid && _liveUid.length > 0) {
        array = @[@"查看订单",@"返回直播间"];
    }else{
        array = @[@"查看订单",@"返回首页"];
    }
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        [btn setBorderColor:normalColors];
        [btn setBorderWidth:1];
        [btn setCornerRadius:21.5];
        btn.titleLabel.font = SYS_Font(15);
        if (i == 0) {
            [btn setBackgroundColor:normalColors];
            [btn addTarget:self action:@selector(doOrderDetails) forControlEvents:UIControlEventTouchUpInside];
            detailsBtn = btn;
        }else{
            [btn setTitleColor:normalColors forState:0];
            [btn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
        }
        [whiteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel);
            make.right.equalTo(rightLabel);
            make.top.equalTo(lineV.mas_bottom).offset(15+i*53);
            make.height.mas_equalTo(43);
        }];
    }
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@",_orderID] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSString *patStr = @"";;
            if ([minstr([info valueForKey:@"pay_type"]) isEqual:@"weixin"]) {
                patStr = @"微信支付";
            }else if ([minstr([info valueForKey:@"pay_type"]) isEqual:@"yue"]){
                patStr = @"余额支付";
            }else{
                patStr = @"线下付款";
            }

            if ([minstr([info valueForKey:@"paid"]) isEqual:@"1"]) {
                self.titleL.text = @"支付成功";
                tipsLabel.text = @"订单支付成功";
                payStateImgView.image = [UIImage imageNamed:@"支付成功"];
                leftLabel.text = @"订单编号\n\n下单时间\n\n支付方式\n\n支付金额";
                rightLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",minstr([info valueForKey:@"order_id"]),minstr([info valueForKey:@"_add_time"]),patStr,minstr([info valueForKey:@"pay_price"])];
            }else{
                self.titleL.text = @"支付失败";
                [detailsBtn setTitle:@"重新支付" forState:0];
                tipsLabel.text = @"订单支付失败";
                payStateImgView.image = [UIImage imageNamed:@"支付失败"];
                leftLabel.text = @"订单编号\n\n下单时间\n\n支付方式\n\n支付金额\n\n失败原因";
                rightLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@",minstr([info valueForKey:@"order_id"]),minstr([info valueForKey:@"_add_time"]),patStr,minstr([info valueForKey:@"pay_price"]),_failReason];
            }
        }
    } Fail:^{
        
    }];
}
- (void)doOrderDetails{
    [MBProgressHUD showMessage:@""];
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@?status=0",_orderID] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            OrderDetailsViewController *vc = [[OrderDetailsViewController alloc]init];
            vc.orderMessage = info;
            vc.isCart = YES;
            vc.orderType = 0;
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } Fail:^{
        
    }];

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
