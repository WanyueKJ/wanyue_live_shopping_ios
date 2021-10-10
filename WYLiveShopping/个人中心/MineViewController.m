//
//  MineViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MineViewController.h"
#import "WYButton.h"
#import "MineOrderPageViewController.h"
#import "MineShopViewController.h"
#import "ApplyShopViewController.h"
#import "MineBalanceViewController.h"
#import "GoodsAdminViewController.h"
#import "mineProfitViewController.h"
#import "AddressListViewController.h"
#import "ReturnOrderListViewController.h"
#import "bindingPhoneViewController.h"
#import "StoreOrderListViewController.h"
#import "MyCollectedGoodsViewController.h"
#import "MineSettingViewController.h"
#import "EditMsgViewController.h"
#import "RechargeViewController.h"
#import "WYProfitViewController.h"
#import "LivebroadViewController.h"
@interface MineViewController (){
    UIButton *iconButton;
    UILabel *userNickNameL;
    NSMutableArray *listArray;
    UIButton *bindingPhoneBtn;
    NSMutableArray *orderBtnArray;
    NSMutableArray *tuiguangLabelArray;

    NSDictionary *orderStatusNum;
    NSDictionary *userInfo;
    
    UIView *storeView;
    
    UIView *bottomView;
}
@property (nonatomic,strong) UIScrollView *backScrollView;

@end

@implementation MineViewController
///用户头像点击
- (void)doUserCenter{
    EditMsgViewController *vc = [[EditMsgViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
///全部订单
- (void)doAllOrder{
    MineOrderPageViewController *vc = [[MineOrderPageViewController alloc]init];
    vc.orderStatusNum = orderStatusNum;
    vc.showIndex = 0;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
///订单按钮点击
- (void)orderButtonClick:(UIButton *)sender{
    NSLog(@"订单%ld",sender.tag - 1000);
    if (sender.tag == 1004) {
        ReturnOrderListViewController *vc = [[ReturnOrderListViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else{
        MineOrderPageViewController *vc = [[MineOrderPageViewController alloc]init];
        vc.orderStatusNum = orderStatusNum;
        vc.showIndex = (int)sender.tag - 1000;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }

}
///我的店铺
- (void)doMineShop{
    MineShopViewController *vc = [[MineShopViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)storeButtonClick:(UIButton *)sender{
    NSLog(@"商店%ld",sender.tag - 1000);
    if (sender.tag == 1000) {
        StoreOrderListViewController *vc = [[StoreOrderListViewController alloc]init];
        vc.statusType = @"2";
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }else if(sender.tag == 1000){
        mineProfitViewController *vc = [[mineProfitViewController alloc]init];
        vc.ptofitType = 1;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }else{
        if ([[Config getIsShop] isEqualToString:@"1"]) {
            [[WYToolClass sharedInstance] removeSusPlayer];
            LivebroadViewController *vc = [[LivebroadViewController alloc]init];
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }else{
            UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:@"你未认证开通店铺，无法进行直播" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [cancleAction setValue:color96 forKey:@"_titleTextColor"];
            [alertContro addAction:cancleAction];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ApplyShopViewController *vc = [[ApplyShopViewController alloc]init];
                [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
            }];
            [sureAction setValue:normalColors forKey:@"_titleTextColor"];
            [alertContro addAction:sureAction];
            [self presentViewController:alertContro animated:YES completion:nil];

        }

    }

}
///绑定手机号
- (void)dobindingPhone{
    bindingPhoneViewController *vc = [[bindingPhoneViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)addheaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 210)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:headerView];
    UIImageView *colorImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 126)];
    colorImgView.backgroundColor = normalColors;
    colorImgView.userInteractionEnabled = YES;
    [headerView addSubview:colorImgView];
    colorImgView.layer.mask = [[WYToolClass sharedInstance] setViewLeftBottom:25 andRightBottom:25 andView:colorImgView];
    
    iconButton = [UIButton buttonWithType:0];
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    iconButton.layer.masksToBounds = YES;
    iconButton.layer.cornerRadius = 32;
    iconButton.layer.borderColor = [UIColor whiteColor].CGColor;
    iconButton.layer.borderWidth = 1;
    [iconButton addTarget:self action:@selector(doUserCenter) forControlEvents:UIControlEventTouchUpInside];
    [iconButton sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]] forState:0];
    [colorImgView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorImgView).offset(15);
        make.bottom.equalTo(colorImgView).offset(-50);
        make.width.height.mas_equalTo(64);
    }];
    userNickNameL = [[UILabel alloc]init];
    userNickNameL.font = SYS_Font(15);
    userNickNameL.textColor = [UIColor whiteColor];
    userNickNameL.text = [Config getOwnNicename];
    [colorImgView addSubview:userNickNameL];
    [userNickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconButton.mas_right).offset(15);
        make.bottom.equalTo(iconButton.mas_centerY).offset(-2);
    }];
    
    bindingPhoneBtn = [UIButton buttonWithType:0];
    bindingPhoneBtn.layer.masksToBounds = YES;
    bindingPhoneBtn.layer.cornerRadius = 8;
    [bindingPhoneBtn addTarget:self action:@selector(dobindingPhone) forControlEvents:UIControlEventTouchUpInside];
    [bindingPhoneBtn setTitle:@"绑定手机号" forState:0];
    bindingPhoneBtn.titleLabel.font = SYS_Font(9);
    [bindingPhoneBtn setBorderColor:[UIColor whiteColor]];
    [bindingPhoneBtn setBorderWidth:0.5];
    [bindingPhoneBtn setBackgroundColor:RGB_COLOR(@"#511909", 0.4)];
    bindingPhoneBtn.hidden = YES;
    [colorImgView addSubview:bindingPhoneBtn];
    [bindingPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNickNameL.mas_right).offset(10);
        make.centerY.equalTo(userNickNameL);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
        make.right.lessThanOrEqualTo(colorImgView).offset(-15);
    }];
    UILabel *idLable = [[UILabel alloc]init];
    idLable.font = SYS_Font(11);
    idLable.textColor = [UIColor whiteColor];
    idLable.text = [NSString stringWithFormat:@"ID:%@",[Config getOwnID]];
    [colorImgView addSubview:idLable];
    [idLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNickNameL);
        make.top.equalTo(userNickNameL.mas_bottom).offset(13);
    }];

    
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-30, 110)];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.layer.cornerRadius = 5;
    menuView.layer.masksToBounds = YES;
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(15, headerView.height-110, _window_width-30, 110)];
    CALayer *subLayer=subView.layer;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 2.5);
    subLayer.shadowOpacity = 0.05;
    subLayer.shadowRadius = 2.5;
    [headerView addSubview:subView];
    [subView addSubview:menuView];
    
    UIButton *allOrderBtn = [UIButton buttonWithType:0];
    [allOrderBtn addTarget:self action:@selector(doAllOrder) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:allOrderBtn];
    [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menuView).offset(-5);
        make.top.equalTo(menuView).offset(13);
        make.height.mas_equalTo(16);
    }];
    UIImageView *rightImgV = [[UIImageView alloc]init];
    rightImgV.image = [UIImage imageNamed:@"mine_right"];
    [allOrderBtn addSubview:rightImgV];
    [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.centerY.equalTo(allOrderBtn);
        make.width.equalTo(rightImgV.mas_width);
    }];
    UILabel *orderLabel = [[UILabel alloc]init];
    orderLabel.font = SYS_Font(12);
    orderLabel.textColor = RGB_COLOR(@"#dcdcdc", 1);
    orderLabel.text = @"查看全部订单";
    [allOrderBtn addSubview:orderLabel];
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allOrderBtn);
        make.right.equalTo(rightImgV.mas_left).offset(-2);
        make.centerY.equalTo(allOrderBtn);
    }];

    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = color32;
    label.text = @"我的订单";
    [menuView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(menuView).offset(13);
        make.centerY.equalTo(allOrderBtn);
    }];
    NSArray *array = @[@"待付款",@"待发货",@"待收货",@"待评价",@"退款"];
    orderBtnArray = [NSMutableArray array];
    CGFloat btnWidth = menuView.width/5;
    for (int i = 0; i < array.count; i ++) {
        WYButton *btn = [WYButton buttonWithType:0];
        btn.frame = CGRectMake(i * btnWidth, 46, btnWidth, 50);
        [btn setShowImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_%@",array[i]]]];
        [btn setShowText:array[i]];
        btn.showTitleLabel.font = SYS_Font(12);
        btn.showTitleLabel.textColor = color32;
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
        [orderBtnArray addObject:btn];
    }

}
- (void)addStoreView{
    
    
    
    
    
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-30, 115)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    storeView = [[UIView alloc] initWithFrame:CGRectMake(15, 210 + 10, _window_width-30, 115)];

    CALayer * subLayer = storeView.layer;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 2.5);
    subLayer.shadowOpacity = 0.05;
    subLayer.shadowRadius = 2.5;
    [_backScrollView addSubview:storeView];
    [storeView addSubview:subView];
    CGFloat btnWidth = subView.width/4;

    UIButton *storeBtn = [UIButton buttonWithType:0];
    [storeBtn addTarget:self action:@selector(doMineShop) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:storeBtn];
    [storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(subView).offset(-5);
        make.top.equalTo(subView).offset(13);
        make.height.mas_equalTo(16);
    }];
    UIImageView *rightImgV2 = [[UIImageView alloc]init];
    rightImgV2.image = [UIImage imageNamed:@"mine_right"];
    [storeBtn addSubview:rightImgV2];
    [rightImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.centerY.equalTo(storeBtn);
        make.width.equalTo(rightImgV2.mas_width);
    }];
    UILabel *tuiguangLabel = [[UILabel alloc]init];
    tuiguangLabel.font = SYS_Font(12);
    tuiguangLabel.textColor = RGB_COLOR(@"#dcdcdc", 1);
    tuiguangLabel.text = @"店铺主页";
    [storeBtn addSubview:tuiguangLabel];
    [tuiguangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeBtn);
        make.right.equalTo(rightImgV2.mas_left).offset(-2);
        make.centerY.equalTo(storeBtn);
    }];

    UILabel *label2 = [[UILabel alloc]init];
    label2.font = [UIFont boldSystemFontOfSize:14];
    label2.textColor = color32;
    label2.text = @"我的店铺";
    [subView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subView).offset(13);
        make.centerY.equalTo(storeBtn);
    }];
    NSArray *array2 = @[@"店铺订单",@"店铺收益",@"我要开播"];
    for (int i = 0; i < array2.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake((i%4) * btnWidth, 45, btnWidth, 55);
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(storeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:btn];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = [UIImage imageNamed:array2[i]];
        [btn addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.width.height.mas_equalTo(30);
            make.top.equalTo(btn).offset(7);
        }];
        UILabel *btnL = [[UILabel alloc]init];
        btnL.text = array2[i];
        btnL.font = SYS_Font(12);
        btnL.textColor = color64;
        [btn addSubview:btnL];
        [btnL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(btn);
            make.width.lessThanOrEqualTo(btn);
        }];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.returnBtn.hidden = YES;
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = normalColors;
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = @"个人中心";
    [self.view addSubview:self.backScrollView];
    [self addheaderView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUser];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"menu/user" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSArray *routine_my_menus = [info valueForKey:@"routine_my_menus"];
            if (listArray.count != routine_my_menus.count) {
                listArray = routine_my_menus.mutableCopy;
                [listArray addObject:@{@"id":@"联系客服",@"name":@"联系客服"}];
                [listArray addObject:@{@"id":@"个性设置",@"name":@"个性设置"}];
                if (bottomView) {
                    [bottomView removeFromSuperview];
                    bottomView = nil;
                }
                [self creatBottomView];
            }
        }
    } Fail:^{
        
    }];
}
- (void)getUser{
    [WYToolClass getQCloudWithUrl:@"user" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            userInfo = info;
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
            [Config saveProfile:userInfo];

//            [Config saveIsShop:minstr([info valueForKey:@"isshop"])];
            if (minstr([info valueForKey:@"phone"]).length > 6) {
                bindingPhoneBtn.hidden = YES;
            }else{
                bindingPhoneBtn.hidden = NO;
            }
            if ([minstr([info valueForKey:@"isshop"]) isEqual:@"1"]) {
                if (!storeView) {
                    [self addStoreView];
                }
            }
            [iconButton sd_setImageWithURL:[NSURL URLWithString:minstr([info valueForKey:@"avatar"])] forState:0];
            userNickNameL.text = minstr([info valueForKey:@"nickname"]);
//            NSArray *array = @[@"待付款",@"待发货",@"待收货",@"待评价",@"退款"];
            orderStatusNum = [info valueForKey:@"orderStatusNum"];
            for (int i = 0; i < orderBtnArray.count; i ++) {
                WYButton *btn = orderBtnArray[i];
                if (i == 0) {
                    [btn showBadgeWithNumber:[minstr([orderStatusNum valueForKey:@"unpaid_count"]) integerValue]];
                }else if (i == 1) {
                    [btn showBadgeWithNumber:[minstr([orderStatusNum valueForKey:@"unshipped_count"]) integerValue]];
                }else if (i == 2) {
                    [btn showBadgeWithNumber:[minstr([orderStatusNum valueForKey:@"received_count"]) integerValue]];
                }else if (i == 3) {
                    [btn showBadgeWithNumber:[minstr([orderStatusNum valueForKey:@"evaluated_count"]) integerValue]];
                }else {
                    [btn showBadgeWithNumber:[minstr([orderStatusNum valueForKey:@"refund_count"]) integerValue]];
                }
            }
            for (int i = 0; i < tuiguangLabelArray.count; i ++) {
                UILabel *label = tuiguangLabelArray[i];
                if (i == 0) {
                    label.text = minstr([info valueForKey:@"brokerage_price"]);
                }else if (i == 1) {
                    label.text = minstr([info valueForKey:@"yesterDay"]);
                }else if (i == 2) {
                    //spread_count一级人数
                    label.attributedText = [self getAttStrWithNums:minstr([info valueForKey:@"spread_total"]) andCompany:@"人"];
                }else {
                    //一级订单数spread_order_count
                    label.attributedText = [self getAttStrWithNums:minstr([info valueForKey:@"order_count"]) andCompany:@"单"];
                }
            }
            [self requestData];
        }
    } Fail:^{
        
    }];
}
- (NSAttributedString *)getAttStrWithNums:(NSString *)nums andCompany:(NSString *)company{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",nums,company]];
    [mustr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} range:NSMakeRange(nums.length, 1)];
    return mustr;
}

- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height- (64+statusbarHeight +ShowDiff+48))];
        _backScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _backScrollView;
}
- (void)creatBottomView{
    
    int count ;
    if (listArray.count % 4 == 0) {
        count = (int)listArray.count/4;
    }else{
        count = ((int)listArray.count/4 + 1);
    }
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-30, 46 + 69 * count)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;

    bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, storeView ? storeView.bottom + 10 : 210 + 10, _window_width-30, 46 + 69 * count)];
    CALayer *subLayer = bottomView.layer;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 2.5);
    subLayer.shadowOpacity = 0.05;
    subLayer.shadowRadius = 2.5;
    [_backScrollView addSubview:bottomView];
    [bottomView addSubview:subView];
    _backScrollView.contentSize = CGSizeMake(0, bottomView.bottom + 40);
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = color32;
    label.text = @"我的服务";
    [subView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subView).offset(13);
        make.centerY.equalTo(subView.mas_top).offset(21);
    }];
    CGFloat btnWidth = subView.width/4;
    for (int i = 0; i < listArray.count; i ++) {
        NSDictionary *dic = listArray[i];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake((i%4) * btnWidth, 46+(i/4*69), btnWidth, 55);
        btn.tag = 2000 + i;
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:btn];
        UIImageView *imgV = [[UIImageView alloc]init];
        if ([minstr([dic valueForKey:@"id"]) isEqual:@"个性设置"]) {
            imgV.image = [UIImage imageNamed:@"mine_设置"];
        }else if ([minstr([dic valueForKey:@"id"]) isEqual:@"联系客服"]) {
            imgV.image = [UIImage imageNamed:@"mine_联系客服"];
        }else{
            [imgV sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"pic"])]];
        }
        [btn addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.width.height.mas_equalTo(30);
            make.top.equalTo(btn).offset(7);
        }];
        UILabel *btnL = [[UILabel alloc]init];
        btnL.text = minstr([dic valueForKey:@"name"]);
        btnL.font = SYS_Font(12);
        btnL.textColor = color64;
        [btn addSubview:btnL];
        [btnL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(btn);
            make.width.lessThanOrEqualTo(btn);
        }];
    }

}
//底部按钮点击
- (void)bottomButtonClick:(UIButton *)sender{
    NSLog(@"底部菜单%ld",sender.tag - 2000);
    NSString *menuID = minstr([listArray[sender.tag - 2000] valueForKey:@"id"]);
    if ([menuID isEqual:@"138"]) {
        //我的余额
        MineBalanceViewController *vc = [[MineBalanceViewController alloc]init];
        vc.userMsgDic = userInfo;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }else if ([menuID isEqual:@"139"]) {
        //地址信息
        AddressListViewController *vc = [[AddressListViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if ([menuID isEqual:@"140"]) {
        //我的收藏
        MyCollectedGoodsViewController *vc = [[MyCollectedGoodsViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if ([menuID isEqual:@"联系客服"]) {
        //客服信息
//        [MBProgressHUD showError:@"敬请期待"];
        if (minstr([userInfo valueForKey:@"service_url"]).length > 6) {
            WYWebViewController *web = [[WYWebViewController alloc] init];
            web.urls = minstr([userInfo valueForKey:@"service_url"]);
            [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
        }else{
            [MBProgressHUD showError:@"客服暂未上线"];
        }

        
    }else if ([menuID isEqual:@"183"]) {
        //申请开通店铺
        ApplyShopViewController *vc = [[ApplyShopViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if ([menuID isEqual:@"137"]) {

    }else if ([menuID isEqual:@"182"]){
        //我的钻石
        RechargeViewController *rechargeVC = [RechargeViewController new];
        [[MXBADelegate sharedAppDelegate] pushViewController:rechargeVC animated:YES];
    }else if ([menuID isEqual:@"186"]){
        //礼物收益
        WYProfitViewController *profitVC = [WYProfitViewController new];
        [[MXBADelegate sharedAppDelegate] pushViewController:profitVC animated:YES];
    }
    else {
        //个性设置
        MineSettingViewController *vc = [[MineSettingViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
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
