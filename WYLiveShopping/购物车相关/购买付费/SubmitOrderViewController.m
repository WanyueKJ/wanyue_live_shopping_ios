//
//  SubmitOrderViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/30.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "submitGoodsCell.h"
#import "addressView.h"
#import "addressModel.h"
#import "MyTextView.h"
#import <WXApi.h>
#import "PaySucessViewController.h"

@interface SubmitOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    NSMutableArray *dataArray;
    addressView *addressV;
    NSMutableArray *addressArray;
    UILabel *allTotalL;
    UIButton *jifenBtn;
    NSMutableArray *payBtnArray;
    NSMutableArray *payImageBtnArray;
    NSString *payTypeStr;
    NSString *orderID;
}
@property (nonatomic,strong) UITableView *submitTableView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation SubmitOrderViewController
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-60-ShowDiff, _window_width, 60+ShowDiff)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;;
}
- (void)creatBottomViewContent{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"合计：";
    label.font = SYS_Font(13);
    label.textColor = color32;
    [_bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(23);
        make.centerY.equalTo(_bottomView.mas_top).offset(30.5);
    }];
    allTotalL = [[UILabel alloc]init];
    allTotalL.font = [UIFont boldSystemFontOfSize:17];
    allTotalL.textColor = normalColors;
    allTotalL.text = [NSString stringWithFormat:@"¥%@",minstr([_orderMessage valueForKey:@"pay_price"])];
    [_bottomView addSubview:allTotalL];
    [allTotalL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5);
        make.centerY.equalTo(label);
    }];
    UIButton *subMitBtn = [UIButton buttonWithType:0];
    [subMitBtn setBackgroundColor:normalColors];
    [subMitBtn setTitle:@"立即结算" forState:0];
    subMitBtn.titleLabel.font = SYS_Font(14);
    subMitBtn.layer.cornerRadius = 15;
    subMitBtn.layer.masksToBounds = YES;
    [subMitBtn addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:subMitBtn];
    [subMitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView).offset(-15);
        make.centerY.equalTo(label);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
}
- (void)doSubmit{
    if ([payTypeStr isEqual:@"yue"]) {
        CGFloat now_money = [minstr([[_orderMessage valueForKey:@"userInfo"] valueForKey:@"now_money"]) floatValue];
        CGFloat pay_price = [minstr([_orderMessage valueForKey:@"pay_price"]) floatValue];

        if (now_money < pay_price) {
            [MBProgressHUD showError:@"余额不足"];
            return;
        }
    }
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if ([addressV.adressDic count] > 0) {
        [muDic setObject:minstr([addressV.adressDic valueForKey:@"id"]) forKey:@"addressId"];
    }else{
        [MBProgressHUD showError:@"请填写收货地址"];
        return;

    }
    [MBProgressHUD showMessage:@"订单支付中"];

    NSMutableDictionary *idDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *markDic = [NSMutableDictionary dictionary];

    for (NSMutableDictionary *dic in dataArray) {
        id usableCoupon = [dic valueForKey:@"usableCoupon"];
        if ([usableCoupon isKindOfClass:[NSDictionary class]] && [usableCoupon count] > 0) {
            [idDic setObject:minstr([usableCoupon valueForKey:@"id"]) forKey:minstr([dic valueForKey:@"mer_id"])];
        }else{
            [idDic setObject:@"" forKey:minstr([dic valueForKey:@"mer_id"])];
        }
        [markDic setObject:minstr([dic valueForKey:@"beizhu"]) forKey:minstr([dic valueForKey:@"mer_id"])];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:idDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [muDic setObject:jsonStr forKey:@"couponId"];
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:markDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    [muDic setObject:jsonStr2 forKey:@"mark"];

    [muDic setObject:payTypeStr forKey:@"payType"];
    [muDic setObject:@"ios" forKey:@"from"];
    if (_liveUid && _liveUid.length > 0) {
        [muDic setObject:_liveUid forKey:@"liveuid"];
    }
    [muDic setObject:[NSString stringWithFormat:@"%d",jifenBtn.selected] forKey:@"useIntegral"];
    [WYToolClass postNetworkWithUrl:[NSString stringWithFormat:@"order/create/%@",minstr([_orderMessage valueForKey:@"orderKey"])] andParameter:muDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WYCarNumChange object:nil];
            NSDictionary *result = [info valueForKey:@"result"];
            orderID = minstr([result valueForKey:@"orderId"]);
            if ([minstr([info valueForKey:@"status"]) isEqual:@"PAY_ERROR"]) {
                [MBProgressHUD hideHUD];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                PaySucessViewController*vc = [[PaySucessViewController alloc]init];
                vc.orderID = orderID;
                vc.failReason = @"支付失败";
                vc.liveUid = _liveUid;
                [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
                
            }else{
                if ([payTypeStr isEqual:@"weixin"]) {
//                    [MBProgressHUD hideHUD];
//                    [[NSNotificationCenter defaultCenter] removeObserver:self];
//                    PaySucessViewController*vc = [[PaySucessViewController alloc]init];
//                    vc.orderID = orderID;
//                    vc.failReason = @"微信支付未接入";
//                    vc.liveUid = _liveUid;
//                    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

                    NSDictionary *jsConfig = [result valueForKey:@"jsConfig"];
                    [WXApi registerApp:minstr([jsConfig valueForKey:@"appid"]) universalLink:WechatUniversalLink];
                    //调起微信支付
                    NSString *times = [jsConfig objectForKey:@"timestamp"];
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [jsConfig objectForKey:@"partnerid"];
                    NSString *pid = [NSString stringWithFormat:@"%@",[jsConfig objectForKey:@"prepayid"]];
                    if ([pid isEqual:[NSNull null]] || pid == NULL || [pid isEqual:@"null"]) {
                        pid = @"123";
                    }
                    req.prepayId            = pid;
                    req.nonceStr            = [jsConfig objectForKey:@"noncestr"];
                    req.timeStamp           = times.intValue;
                    req.package             = [jsConfig objectForKey:@"package"];
                    req.sign                = [jsConfig objectForKey:@"sign"];
                    [WXApi sendReq:req completion:^(BOOL success) {
                        
                    }];

                }else{
                    [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                    PaySucessViewController*vc = [[PaySucessViewController alloc]init];
                    vc.orderID = orderID;
                    vc.liveUid = _liveUid;
                    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
                }
            }

        }
    } fail:^{
        
    }];

}
- (void)wxPayResult:(NSNotification *)not{
    [MBProgressHUD hideHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    PayResp *response = not.object;
    PaySucessViewController*vc = [[PaySucessViewController alloc]init];
    vc.orderID = orderID;
    vc.liveUid = _liveUid;

    switch (response.errCode)
    {
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");
            break;
        case WXErrCodeUserCancel:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            //交易取消
            [MBProgressHUD showError:@"已取消支付"];
            vc.failReason = @"取消支付";
            break;
        default:
            [MBProgressHUD showError:@"支付失败"];
            vc.failReason = @"支付失败";
            break;
    }
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
- (void)addTableFootView{
    payBtnArray = [NSMutableArray array];
    payImageBtnArray = [NSMutableArray array];
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-20, 220)];
    footV.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-20, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.layer.cornerRadius = 5;
    [footV addSubview:aView];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"积分抵扣";
    label.font = SYS_Font(13);
    label.textColor = color32;
    [aView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aView).offset(14);
        make.centerY.equalTo(aView);
    }];
    jifenBtn = [UIButton buttonWithType:0];
    [jifenBtn setImage:[UIImage imageNamed:@"jubao_nor"] forState:0];
    [jifenBtn setImage:[UIImage imageNamed:@"cart_sel"] forState:UIControlStateSelected];
    [jifenBtn addTarget:self action:@selector(doSelectJifen) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:jifenBtn];
    [jifenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aView).offset(-10);
        make.centerY.equalTo(label);
        make.width.height.mas_equalTo(25);
    }];

    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.font = SYS_Font(13);
    rightLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
    rightLabel.attributedText = [self getJifen:minstr([[_orderMessage valueForKey:@"userInfo"] valueForKey:@"integral"])];
    [aView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jifenBtn.mas_left).offset(-5);
        make.centerY.equalTo(aView);
    }];
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, _window_width-20, 150)];
    bView.backgroundColor = [UIColor whiteColor];
    bView.layer.cornerRadius = 5;
    [footV addSubview:bView];
    UILabel *payLabel = [[UILabel alloc]init];
    payLabel.text = @"支付方式";
    payLabel.font = SYS_Font(13);
    payLabel.textColor = color32;
    [bView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bView).offset(14);
        make.centerY.equalTo(bView.mas_top).offset(25.5);
    }];
    NSArray *array = @[@"微信支付",@"余额支付"];
    NSArray *array2 = @[@"微信快捷支付",[NSString stringWithFormat:@"可用余额:%@",minstr([[_orderMessage valueForKey:@"userInfo"] valueForKey:@"now_money"])]];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(15, 43+i*(53), _window_width-50, 43);
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [btn setBorderWidth:1];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(payTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:btn];
        UIButton *imgBtn = [UIButton buttonWithType:0];
        [imgBtn setImage:[UIImage imageNamed:array[i]] forState:0];
        [imgBtn setTitle:[NSString stringWithFormat:@" %@",array[i]] forState:0];
        [imgBtn setTitleColor:color32 forState:0];
        [imgBtn setTitleColor:normalColors forState:UIControlStateSelected];
        imgBtn.titleLabel.font = SYS_Font(14);
        imgBtn.userInteractionEnabled = NO;
        imgBtn.tag = btn.tag + 1000;
        [btn addSubview:imgBtn];
        [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.centerX.equalTo(btn).multipliedBy(0.5);
        }];
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGB_COLOR(@"#EEEEEE", 1);
        [btn addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(btn);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(22);
        }];
        UILabel *tipsL = [[UILabel alloc]init];
        tipsL.text = array2[i];
        tipsL.font = SYS_Font(13);
        tipsL.textAlignment = NSTextAlignmentCenter;
        tipsL.textColor = RGB_COLOR(@"#aaaaaa", 1);
        [btn addSubview:tipsL];
        [tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.centerX.equalTo(btn).multipliedBy(1.5);
            make.width.equalTo(btn).multipliedBy(0.5).offset(-5);
        }];
        if (i==0) {
            [btn setBorderColor:normalColors];
            imgBtn.selected = YES;
        }else{
            [btn setBorderColor:RGB_COLOR(@"#EEEEEE", 1)];
            imgBtn.selected = NO;
        }
        [payBtnArray addObject:btn];
        [payImageBtnArray addObject:imgBtn];
    }
    
    _submitTableView.tableFooterView = footV;
}
- (NSAttributedString *)getJifen:(NSString *)nums{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前积分 %@",nums]];
    [mustr setAttributes:@{NSForegroundColorAttributeName:normalColors} range:NSMakeRange(5, nums.length)];
    return mustr;
}
- (void)doSelectJifen{
    NSString *integral = minstr([[_orderMessage valueForKey:@"userInfo"] valueForKey:@"integral"]);
    if ([integral floatValue] == 0) {
        [MBProgressHUD showError:@"暂无可用积分"];
    }else{
        jifenBtn.selected = !jifenBtn.selected;
        [self computedOrderPrice];

    }
}
- (void)payTypeClick:(UIButton *)sender{
    for (int i = 0; i < payBtnArray.count; i ++) {
        UIButton *btn = payBtnArray[i];
        UIButton *imgBtn = payImageBtnArray[i];
        if (sender == btn) {
            [btn setBorderColor:normalColors];
            imgBtn.selected = YES;
            if (i == 0) {
                payTypeStr = @"weixin";
            }else{
                payTypeStr = @"yue";
            }
        }else{
            [btn setBorderColor:RGB_COLOR(@"#EEEEEE", 1)];
            imgBtn.selected = NO;
        }
    }
}


- (UITableView *)submitTableView{
    if (!_submitTableView) {
        _submitTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, self.naviView.bottom, _window_width-20, _window_height-(self.naviView.bottom + 60+ShowDiff)) style:1];
        _submitTableView.delegate = self;
        _submitTableView.dataSource =self;
        _submitTableView.separatorStyle = 0;
        _submitTableView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
        _submitTableView.showsVerticalScrollIndicator = NO;
        _submitTableView.estimatedSectionFooterHeight = 0;
        _submitTableView.estimatedSectionHeaderHeight = 0;

    }
    return _submitTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.backgroundColor = normalColors;
    self.lineView.hidden = YES;
    self.titleL.text = @"提交订单";
    self.titleL.textColor = [UIColor whiteColor];
    [self.returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:0];
    self.view.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    dataArray = [NSMutableArray array];
    addressArray = [NSMutableArray array];
    payTypeStr = @"weixin";
    for (NSDictionary *dic in [_orderMessage valueForKey:@"cartInfo"]) {
        NSMutableDictionary *mudic = [dic mutableCopy];
        NSArray *list = [dic valueForKey:@"list"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dicc in list) {
            cartModel *model = [[cartModel alloc] initWithDic:dicc];
            [array addObject:model];
        }
        [mudic setObject:array forKey:@"model"];
        [mudic setObject:@"" forKey:@"beizhu"];
        [dataArray addObject:mudic];
    }
    [self.view addSubview:self.submitTableView];
    [self.view addSubview:self.bottomView];
    [self creatBottomViewContent];
    [self creatAddressView];
    [self addTableFootView];
    [self computedOrderPrice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:WYWXApiPaySuccess object:nil];
}
- (void)creatAddressView{

    addressV = [[[NSBundle mainBundle] loadNibNamed:@"addressView" owner:nil options:nil] lastObject];
    addressV.frame = CGRectMake(0, 0, _submitTableView.width, 110);
    id addressInfo = [_orderMessage valueForKey:@"addressInfo"];
    if ([addressInfo isKindOfClass:[NSDictionary class]] && [addressInfo count] > 0) {
        addressV.adressDic = addressInfo;
    }else{
        addressV.adressDic = @{};
    }
    WeakSelf;
    addressV.block = ^{
        [weakSelf computedOrderPrice];
    };
    _submitTableView.tableHeaderView = addressV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [dataArray[section] valueForKey:@"model"];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    submitGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"submitGoodsCell" owner:nil options:nil] lastObject];
    }
    NSArray *array = [dataArray[indexPath.section] valueForKey:@"model"];
    cell.model = array[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-20, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"小店"];
    [view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(14);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(16);
    }];
    NSDictionary *dic = dataArray[section];
    UILabel *label = [[UILabel alloc]init];
    label.text = minstr([dic valueForKey:@"name"]);
    label.font = SYS_Font(14);
    label.textColor = color32;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(8);
        make.centerY.equalTo(view);
    }];
    view.layer.mask = [[WYToolClass sharedInstance] setViewLeftTop:5 andRightTop:5 andView:view];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 39, _window_width-20, 1) andColor:RGB_COLOR(@"#eeeeee", 1) andView:view];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 260;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-20, 260)];
    view.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width-20, 250)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    [view addSubview:contentView];
    contentView.layer.mask = [[WYToolClass sharedInstance] setViewLeftBottom:5 andRightBottom:5 andView:contentView];
    NSDictionary *priceGroup = [dataArray[section] valueForKey:@"priceGroup"];
    id usableCoupon = [dataArray[section] valueForKey:@"usableCoupon"];
    NSArray *array = @[@"优惠券",@"快递费用"];
    for (int i = 0; i < array.count; i ++) {
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, i*51, _window_width-20, 50)];
        [contentView addSubview:aView];
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.font = SYS_Font(13);
        label.textColor = color32;
        [aView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(aView).offset(14);
            make.centerY.equalTo(aView);
        }];
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = SYS_Font(13);
        rightLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
        [aView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(aView).offset(-15);
            make.centerY.equalTo(aView);
        }];

        if (i == 0) {
            UIImageView *rightImgV = [[UIImageView alloc]init];
            rightImgV.image = [UIImage imageNamed:@"profit_right"];
            [aView addSubview:rightImgV];
            [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(aView).offset(-10);
                make.centerY.equalTo(label);
                make.width.height.mas_equalTo(15);
            }];
            [rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(rightImgV.mas_left).offset(-5);
                make.centerY.equalTo(aView);

            }];
            if ([usableCoupon isKindOfClass:[NSDictionary class]] && [usableCoupon count] > 0) {
                rightLabel.text = minstr([usableCoupon valueForKey:@"coupon_title"]);
            }else{
                rightLabel.text = @"请选择";
            }
            UIButton *btn = [UIButton buttonWithType:0];
            btn.tag = 10000 + section;
            [btn addTarget:self action:@selector(showCoupon:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.width.height.equalTo(aView);
            }];
        }else{
            if ([minstr([priceGroup valueForKey:@"storePostage"]) intValue] == 0) {
                rightLabel.text = @"免运费";
            }else{
                rightLabel.text = [NSString stringWithFormat:@"运费：%@",minstr([priceGroup valueForKey:@"storePostage"])];
            }
        }
        UIView *llView = [[UIView alloc]init];
        llView.backgroundColor = colorf0;
        [contentView addSubview:llView];
        [llView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.right.equalTo(contentView).offset(-15);
            make.top.equalTo(aView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    UILabel *label = [[UILabel alloc]init];
    label.text = @"备注信息";
    label.font = SYS_Font(13);
    label.textColor = color32;
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(14);
        make.top.equalTo(contentView).offset(112);
        make.height.mas_equalTo(31);
    }];
    MyTextView *textV = [[MyTextView alloc]initWithFrame:CGRectMake(15, 143, _window_width-50, 60)];
    textV.placeholder = @"请添加备注（150字以内）";
    textV.font = SYS_Font(13);
    textV.textColor = color32;
    textV.placeholderColor = RGB_COLOR(@"#C8C8C8", 1);
    textV.backgroundColor = colorf0;
    textV.delegate = self;
    textV.tag = 20000 + section;
    [contentView addSubview:textV];
    if (minstr([dataArray[section] valueForKey:@"beizhu"]).length > 0) {
        textV.text = minstr([dataArray[section] valueForKey:@"beizhu"]);
    }else{
        textV.text = @"";
    }
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.font = SYS_Font(13);
    totalLabel.textColor = normalColors;
    [contentView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textV);
        make.centerY.equalTo(textV.mas_bottom).offset(24);
    }];
    NSArray *arr = [dataArray[section] valueForKey:@"model"];
    int nums = 0;
    for (cartModel *model in arr) {
        nums += [model.cart_num intValue];
    }
    totalLabel.attributedText = [self getAttStrWithNums:[NSString stringWithFormat:@"%d",nums] andTotalMoney:minstr([[dataArray[section] valueForKey:@"priceGroup"] valueForKey:@"totalPrice"])];
    return view;
}
- (NSAttributedString *)getAttStrWithNums:(NSString *)nums andTotalMoney:(NSString *)money{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%@件 小计：¥%@",nums,money]];
    [mustr setAttributes:@{NSForegroundColorAttributeName:RGB_COLOR(@"#C8C8C8", 1)} range:NSMakeRange(0, nums.length+2)];
    [mustr setAttributes:@{NSForegroundColorAttributeName:color32} range:NSMakeRange(nums.length+3, 3)];
    return mustr;
}
- (void)showCoupon:(UIButton *)sender{

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary *mudic = dataArray[textView.tag - 20000];
    [mudic setObject:minstr(textView.text) forKey:@"beizhu"];
}
- (void)computedOrderPrice{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if ([addressV.adressDic count] > 0) {
        [muDic setObject:minstr([addressV.adressDic valueForKey:@"id"]) forKey:@"addressId"];
    }else{
        [muDic setObject:@"" forKey:@"addressId"];

    }
    NSMutableDictionary *idDic = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *dic in dataArray) {
        id usableCoupon = [dic valueForKey:@"usableCoupon"];
        if ([usableCoupon isKindOfClass:[NSDictionary class]] && [usableCoupon count] > 0) {
            [idDic setObject:minstr([usableCoupon valueForKey:@"id"]) forKey:minstr([dic valueForKey:@"mer_id"])];
        }else{
            [idDic setObject:@"" forKey:minstr([dic valueForKey:@"mer_id"])];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:idDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [muDic setObject:jsonStr forKey:@"couponId"];
    [muDic setObject:payTypeStr forKey:@"payType"];
    [muDic setObject:[NSString stringWithFormat:@"%d",jifenBtn.selected] forKey:@"useIntegral"];
    [WYToolClass postNetworkWithUrl:[NSString stringWithFormat:@"order/computed/%@",minstr([_orderMessage valueForKey:@"orderKey"])] andParameter:muDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSDictionary *result = [info valueForKey:@"result"];
            [_orderMessage setObject:minstr([result valueForKey:@"pay_price"]) forKey:@"pay_price"];
            allTotalL.text = [NSString stringWithFormat:@"¥%@",minstr([_orderMessage valueForKey:@"pay_price"])];
            NSArray *array = [result valueForKey:@"priceGroup"];
            for (NSDictionary *dic in array) {
                for (NSMutableDictionary *mer_Dic in dataArray) {
                    if ([minstr([dic valueForKey:@"mer_id"]) isEqual:minstr([mer_Dic valueForKey:@"mer_id"])]) {
                        [mer_Dic setObject:dic forKey:@"priceGroup"];
                    }
                }
            }
            [_submitTableView reloadData];
        }
    } fail:^{
        
    }];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
