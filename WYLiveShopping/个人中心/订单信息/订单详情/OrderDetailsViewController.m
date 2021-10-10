//
//  OrderDetailsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/6.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import <YYWebImage/YYWebImage.h>
#import <WXApi.h>
#import "payTypeSelectView.h"
#import "SubmitOrderViewController.h"
#import "evaluateWriteViewController.h"
#import "ApplyReturnMoneyViewController.h"
#import "LogisticsMsgViewController.h"

@interface OrderDetailsViewController ()<UITextViewDelegate>{
    payTypeSelectView *payTypeView;
    UIView *sendGiftView;
}
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *goodsArray;

@end

@implementation OrderDetailsViewController
- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height-(self.naviView.bottom + ShowDiff + 50))];
        _backScrollView.backgroundColor = colorf0;
    }
    return _backScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:0];
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = RGB_COLOR(@"#e6352d", 1);
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = @"订单详情";
    _goodsArray = [NSMutableArray array];
    for (NSDictionary *dic in [_orderMessage valueForKey:@"cartInfo"]) {
        cartModel *model = [[cartModel alloc]initWithDic:dic];
        [_goodsArray addObject:model];
    }
    [self creatUI];
    if (_orderType == 0) {
        [self.view addSubview:self.bottomView];
    }else{
        _backScrollView.height = _window_height -(self.naviView.bottom);
    }
}
- (void)creatUI{
    [self.view addSubview:self.backScrollView];
    ///订单状态视图
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 80)];
    statusView.backgroundColor = RGB_COLOR(@"#e6352d", 1);;
    [_backScrollView addSubview:statusView];
    YYAnimatedImageView *imgV = [YYAnimatedImageView new];
    imgV.yy_imageURL = [NSURL URLWithString:minstr([_orderMessage valueForKey:@"status_pic"])];
    [statusView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusView);
        make.left.equalTo(statusView).offset(15);
        make.width.height.mas_equalTo(50);
    }];
    UILabel *statusTitleL = [[UILabel alloc]init];
    statusTitleL.text = minstr([[_orderMessage valueForKey:@"_status"] valueForKey:@"_msg"]);
    statusTitleL.font = SYS_Font(14);
    statusTitleL.textColor = [UIColor whiteColor];
    [statusView addSubview:statusTitleL];
    [statusTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(15);
        make.bottom.equalTo(statusView.mas_centerY);
    }];
    UILabel *statusTimeL = [[UILabel alloc]init];
    statusTimeL.text = minstr([_orderMessage valueForKey:@"_add_time"]);
    statusTimeL.font = SYS_Font(11);
    statusTimeL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [statusView addSubview:statusTimeL];
    [statusTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(15);
        make.top.equalTo(statusTitleL.mas_bottom).offset(10);
    }];
    
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom + 5, _window_width, 60)];
    progressView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:progressView];
    UIView *aginLineV;
    NSArray *array;
    if (_orderType == 0) {

        array = @[@"待付款",@"待发货",@"待收货",@"待评价",@"已完成"];
    }else{
        array = @[@"待付款",@"待发货",@"已发货",@"已收货",@"已完成"];
    }
    for (int i = 0; i < array.count; i ++) {
        UIButton *topBtn = [UIButton buttonWithType:0];
        [topBtn setTitle:array[i] forState:0];
        [topBtn setTitleColor:color32 forState:0];
        [topBtn setTitleColor:normalColors forState:UIControlStateSelected];
        topBtn.titleLabel.font = SYS_Font(13);
        [progressView addSubview:topBtn];
        [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(progressView.mas_centerY);
            make.centerX.equalTo(progressView).multipliedBy(0.25 + i * 0.375);
            make.height.mas_equalTo(14);
        }];
        
        UIButton *botBtn = [UIButton buttonWithType:0];
        [botBtn setImage:[UIImage imageNamed:@"progress_灰点"] forState:0];
        [botBtn setImage:[UIImage imageNamed:@"progress_红点"] forState:UIControlStateSelected];
        [progressView addSubview:botBtn];

        [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBtn.mas_bottom).offset(8);
            make.centerX.equalTo(topBtn);
            make.height.width.mas_equalTo(10);
        }];
        if (aginLineV) {
            [aginLineV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(botBtn.mas_left).offset(-10);
            }];
        }

        if (i < array.count-1) {
            UIView *lineV = [[UIView alloc]init];
            lineV.backgroundColor = RGB_COLOR(@"#93938F", 1);
            [progressView addSubview:lineV];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(botBtn.mas_right).offset(10);
                make.centerY.equalTo(botBtn);
                make.height.mas_equalTo(1);
            }];
            aginLineV = lineV;
        }
        if ([minstr([_orderMessage valueForKey:@"paid"]) isEqual:@"1"]) {
            if (i == [minstr([_orderMessage valueForKey:@"status"]) intValue] + 1) {
                topBtn.selected = YES;
                botBtn.selected = YES;
            }
        }else{
            if (i == 0) {
                topBtn.selected = YES;
                botBtn.selected = YES;
            }
        }

    }
    
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, progressView.bottom + 10, _window_width, 70)];
    addressView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:addressView];
    UILabel *adsNameL = [[UILabel alloc]init];
    adsNameL.text = [NSString stringWithFormat:@"%@ %@",minstr([_orderMessage valueForKey:@"real_name"]),minstr([_orderMessage valueForKey:@"user_phone"])];
    adsNameL.font = SYS_Font(15);
    adsNameL.textColor = color32;
    [addressView addSubview:adsNameL];
    [adsNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressView).offset(15);
        make.bottom.equalTo(addressView.mas_centerY).offset(-3);
    }];
    UILabel *adsContL = [[UILabel alloc]init];
    adsContL.text = minstr([_orderMessage valueForKey:@"user_address"]);
    adsContL.font = SYS_Font(13);
    adsContL.textColor = color96;
    [addressView addSubview:adsContL];
    [adsContL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adsNameL);
        make.top.equalTo(adsNameL.mas_bottom).offset(8);
    }];
    UIImageView *lineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, addressView.height-1, _window_width, 1)];
    lineImgV.image = [UIImage imageNamed:@"地址线"];
    lineImgV.contentMode = UIViewContentModeScaleAspectFill;
    [addressView addSubview:lineImgV];
    
    UIView *shopView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.bottom + 10, _window_width, 80 + _goodsArray.count * 80)];
    shopView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:shopView];
    UILabel *goodsNumsL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _window_width-30, 40)];
    goodsNumsL.font = [UIFont boldSystemFontOfSize:15];
    goodsNumsL.textColor = color32;
    goodsNumsL.text = [NSString stringWithFormat:@"共%@件商品",minstr([_orderMessage valueForKey:@"total_num"])];
    [shopView addSubview:goodsNumsL];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, 39, _window_width-30, 1) andColor:colorf0 andView:shopView];
    for (int i = 0; i < _goodsArray.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 40 +i * 80, _window_width-30, 80)];
        [shopView addSubview:view];
        cartModel *model = _goodsArray[i];
        UIImageView *thumbImgV = [[UIImageView alloc]init];
        thumbImgV.contentMode = UIViewContentModeScaleAspectFill;
        [thumbImgV sd_setImageWithURL:[NSURL URLWithString:model.image]];
        thumbImgV.layer.cornerRadius = 5;
        thumbImgV.layer.masksToBounds = YES;
        [view addSubview:thumbImgV];
        [thumbImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(view);
            make.width.height.mas_equalTo(60);
        }];

        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.text = model.store_name;
        namelabel.font = SYS_Font(15);
        namelabel.textColor = color32;
        [view addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbImgV.mas_right).offset(8);
            make.top.equalTo(thumbImgV).offset(2);
        }];
        UILabel *numsLabel = [[UILabel alloc]init];
        numsLabel.text = [NSString stringWithFormat:@"x %@",model.cart_num];
        numsLabel.font = SYS_Font(14);
        numsLabel.textColor = color96;
        [view addSubview:numsLabel];
        [numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
            make.centerY.equalTo(namelabel);
            make.left.greaterThanOrEqualTo(namelabel.mas_right).offset(5);
        }];

        UILabel *sukLabel = [[UILabel alloc]init];
        sukLabel.text = model.suk;
        sukLabel.font = SYS_Font(11);
        sukLabel.textColor = color96;
        [view addSubview:sukLabel];
        [sukLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(namelabel);
            make.centerY.equalTo(thumbImgV);
        }];
        UILabel *pricelabel = [[UILabel alloc]init];
        pricelabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        pricelabel.font = SYS_Font(15);
        pricelabel.textColor = normalColors;
        [view addSubview:pricelabel];
        [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(namelabel);
            make.bottom.equalTo(thumbImgV).offset(-2);
        }];
        if ([minstr([_orderMessage valueForKey:@"status"]) intValue] == 2 && _orderType == 0){
            UIButton *pingjiaBtn = [UIButton buttonWithType:0];
            if ([model.is_reply isEqual:@"0"]) {
                [pingjiaBtn setTitle:@"评价" forState:0];
                [pingjiaBtn setTitleColor:normalColors forState:0];
                [pingjiaBtn setBorderColor:normalColors];
            }else{
                [pingjiaBtn setTitle:@"已评价" forState:0];
                [pingjiaBtn setTitleColor:color32 forState:0];
                [pingjiaBtn setBorderColor:color96];
                pingjiaBtn.userInteractionEnabled = NO;
            }
            [pingjiaBtn setBorderWidth:0.5];
            pingjiaBtn.titleLabel.font = SYS_Font(13);
            [pingjiaBtn setCornerRadius:2.5];
            pingjiaBtn.layer.masksToBounds = YES;
            pingjiaBtn.tag = i + 1000;
            [pingjiaBtn addTarget:self action:@selector(doPingjiaGoosd:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:pingjiaBtn];
            [pingjiaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(numsLabel);
                make.centerY.equalTo(pricelabel);
                make.width.mas_equalTo(58);
                make.height.mas_equalTo(24);
            }];
        }
    }
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, shopView.height-40, _window_width-30, 1) andColor:colorf0 andView:shopView];
    UIButton *kefuBtn = [UIButton buttonWithType:0];
    [kefuBtn setTitle:@" 联系客服" forState:0];
    kefuBtn.titleLabel.font = SYS_Font(15);
    [kefuBtn setTitleColor:normalColors forState:0];
    [kefuBtn setImage:[UIImage imageNamed:@"store_客服_red"] forState:0];
    [kefuBtn addTarget:self action:@selector(doConnectKefu) forControlEvents:UIControlEventTouchUpInside];
    [shopView addSubview:kefuBtn];
    [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopView);
        make.centerY.equalTo(shopView.mas_bottom).offset(-20);
    }];
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, shopView.bottom + 10, _window_width, 140)];
    payView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:payView];
    UILabel *leftL = [[UILabel alloc]init];
    leftL.textColor = color32;
    leftL.numberOfLines = 0;
    leftL.font = SYS_Font(13);
    leftL.text = @"订单编号:\n\n下单时间:\n\n支付状态:\n\n支付方式:";
    [payView addSubview:leftL];
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payView).offset(15);
        make.centerY.equalTo(payView);
    }];
    UITextView *rightL = [[UITextView alloc]init];
    rightL.editable = NO;
    rightL.attributedText = [self getPayMessageAttstr];
    rightL.textColor = color96;
    rightL.delegate = self;
    rightL.font = SYS_Font(13);
    rightL.textAlignment = NSTextAlignmentRight;
    rightL.scrollEnabled = NO;
    [payView addSubview:rightL];
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payView).offset(-15);
        make.height.equalTo(leftL).offset(8);
        make.left.equalTo(leftL.mas_right).offset(10);
        make.centerY.equalTo(payView).offset(-1);
    }];
    CGFloat nextBottom = payView.bottom;
    if ([minstr([_orderMessage valueForKey:@"paid"]) isEqual:@"1"] && [minstr([_orderMessage valueForKey:@"status"]) intValue] > 0) {
        UIView *wuliuView = [[UIView alloc]initWithFrame:CGRectMake(0, payView.bottom + 10, _window_width, 110)];
        wuliuView.backgroundColor = [UIColor whiteColor];
        [_backScrollView addSubview:wuliuView];
        UILabel *wleftL = [[UILabel alloc]init];
        wleftL.textColor = color32;
        wleftL.numberOfLines = 0;
        wleftL.font = SYS_Font(13);
        wleftL.text = @"配送方式:\n\n快递公司:\n\n快递号:";
        [wuliuView addSubview:wleftL];
        [wleftL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wuliuView).offset(15);
            make.centerY.equalTo(wuliuView);
        }];
        UILabel *wrightL = [[UILabel alloc]init];
        wrightL.text = [NSString stringWithFormat:@"发货\n\n%@\n\n%@",minstr([_orderMessage valueForKey:@"delivery_name"]),minstr([_orderMessage valueForKey:@"delivery_id"])];
        wrightL.textColor = color96;
        wrightL.font = SYS_Font(13);
        wrightL.numberOfLines = 0;
        wrightL.textAlignment = NSTextAlignmentRight;
        [wuliuView addSubview:wrightL];
        [wrightL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wuliuView).offset(-15);
            make.centerY.equalTo(wuliuView);
        }];
        nextBottom = wuliuView.bottom;
    }
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, nextBottom + 10, _window_width, 120)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:moneyView];
    UILabel *mleftL = [[UILabel alloc]init];
    mleftL.textColor = color32;
    mleftL.numberOfLines = 0;
    mleftL.font = SYS_Font(13);
    mleftL.text = @"支付金额:\n\n运费:";
    [moneyView addSubview:mleftL];
    [mleftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyView).offset(15);
        make.centerY.equalTo(moneyView).offset(-20);
    }];
    UILabel *mrightL = [[UILabel alloc]init];
    mrightL.text = [NSString stringWithFormat:@"¥%@\n\n¥%@",minstr([_orderMessage valueForKey:@"total_price"]),minstr([_orderMessage valueForKey:@"pay_postage"])];
    mrightL.textColor = color96;
    mrightL.font = SYS_Font(13);
    mrightL.numberOfLines = 0;
    mrightL.textAlignment = NSTextAlignmentRight;
    [moneyView addSubview:mrightL];
    [mrightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moneyView).offset(-15);
        make.centerY.equalTo(mleftL);
    }];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, 79, moneyView.width-30, 1) andColor:colorf0 andView:moneyView];
    UILabel *pay_priceL = [[UILabel alloc]init];
    pay_priceL.textColor = color32;
    pay_priceL.font = SYS_Font(13);
    pay_priceL.attributedText = [self getMoneyAtt];
    [moneyView addSubview:pay_priceL];
    [pay_priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moneyView).offset(-15);
        make.centerY.equalTo(moneyView.mas_bottom).offset(-20);
    }];
    _backScrollView.contentSize = CGSizeMake(0, moneyView.bottom + 10);
}
- (NSMutableAttributedString *)getPayMessageAttstr{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",minstr([_orderMessage valueForKey:@"order_id"])]];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"att_copy"];
    textAttachment.bounds = CGRectMake(0, -2, 28, 15);//设置frame
    NSMutableAttributedString *imageString = [[NSMutableAttributedString attributedStringWithAttachment:(NSTextAttachment *)(textAttachment)] mutableCopy];
    [imageString addAttribute:NSLinkAttributeName
    value:@"copyOrder://"
    range:NSMakeRange(0, imageString.length)];
    [muStr appendAttributedString:imageString];
    NSString *pay_type = minstr([_orderMessage valueForKey:@"pay_type"]);
    if ([pay_type isEqual:@"weixin"]) {
        pay_type = @"微信支付";
    }else if ([pay_type isEqual:@"yue"]){
        pay_type = @"余额支付";
    }else {
        pay_type = @"线下支付";
    }
    NSString *str2 = [NSString stringWithFormat:@"\n\n%@\n\n%@\n\n%@",minstr([_orderMessage valueForKey:@"_add_time"]),[minstr([_orderMessage valueForKey:@"paid"]) isEqual:@"1"]?@"已支付":@"未支付",pay_type];
    NSAttributedString *atts = [[NSAttributedString alloc]initWithString:str2];
    [muStr appendAttributedString:atts];
    return muStr;
}
- (NSMutableAttributedString *)getMoneyAtt{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付款：¥%@",minstr([_orderMessage valueForKey:@"pay_price"])]];
    [muStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:normalColors} range:NSMakeRange(4, muStr.length-4)];
    return muStr;

}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"copyOrder"]) {
        NSLog(@"复制订单号");
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = minstr([_orderMessage valueForKey:@"order_id"]);
        [MBProgressHUD showError:@"复制成功"];

        return NO;
    }
    return YES;
}
#pragma mark -- 联系客服

- (void)doConnectKefu{
//    [MBProgressHUD showError:@"敬请期待"];
    if (minstr([_orderMessage valueForKey:@"service_url"]).length > 6) {
        WYWebViewController *web = [[WYWebViewController alloc] init];
        web.urls = minstr([_orderMessage valueForKey:@"service_url"]);
        [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
    }else{
        [MBProgressHUD showError:@"客服暂未上线"];
    }


}
- (void)doPingjiaGoosd:(UIButton *)sender{
    evaluateWriteViewController *vc = [[evaluateWriteViewController alloc]init];
    cartModel *model = _goodsArray[sender.tag - 1000];
    vc.goodsModel = model;
    WeakSelf;
    vc.block = ^{
        model.is_reply = @"1";
        [sender setTitle:@"已评价" forState:0];
        [sender setTitleColor:color32 forState:0];
        [sender setBorderColor:color96];
        sender.userInteractionEnabled = NO;
        [weakSelf checkAllGoodsReplay];
        [weakSelf getNeworderMessage];
    };
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)checkAllGoodsReplay{
    BOOL isAllReplay = YES;
    for (cartModel *model in _goodsArray) {
        if ([model.is_reply isEqual:@"0"]) {
            isAllReplay = NO;
        }
    }
    if (isAllReplay) {
        if (self.block) {
            self.block();
        }
    }
}
#pragma mark -- 底部视图
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-50-ShowDiff, _window_width, 50+ShowDiff)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self creatBottomButton];
    }
    return _bottomView;
}
- (void)creatBottomButton{
    NSArray *array;
    if ([minstr([_orderMessage valueForKey:@"paid"]) isEqual:@"1"]) {
        //订单状态|0=待发货,1=待收货,2=待评价,3=已完成
        if ([minstr([_orderMessage valueForKey:@"status"]) intValue] == 0) {
            array = @[@"申请退款"];
        }else if ([minstr([_orderMessage valueForKey:@"status"]) intValue] == 1){
            array = @[@"确认收货",@"查看物流",@"申请退款"];
        }else if ([minstr([_orderMessage valueForKey:@"status"]) intValue] == 2){
            array = @[@"申请退款",@"查看物流",@"再次购买"];
        }else{
            array = @[@"申请退款",@"查看物流",@"删除订单",@"再次购买"];
        }
    }else{
        array = @[@"立即付款"];
    }
    CGFloat btnWidth;
    if (IS_IPHONE_5) {
        btnWidth = 65;
    }else{
        btnWidth = 79;
    }
    for (int i = 0; i < array.count; i ++) {
        NSString *titleStr = array[i];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(_window_width-(btnWidth + 15) - i*(btnWidth + 8), 10, btnWidth, 30);
        [btn setCornerRadius:15];
        btn.titleLabel.font = SYS_Font(13);
        btn.layer.masksToBounds = YES;
        if ((i == 0 && [titleStr isEqual:@"申请退款"]) || i > 0) {
            [btn setTitleColor:RGB_COLOR(@"#A9A9A9", 1) forState:0];
            [btn setBorderWidth:0.5];
            [btn setBorderColor:RGB_COLOR(@"#DDDDDD", 1)];
        }else{
            [btn setBackgroundColor:normalColors];
        }
        [btn setTitle:titleStr forState:0];
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }
}
- (void)bottomBtnClick:(UIButton *)sender{
    NSString *titleStr = sender.titleLabel.text;
    if ([titleStr isEqual:@"申请退款"]) {
        ApplyReturnMoneyViewController *vc = [[ApplyReturnMoneyViewController alloc]init];
        vc.orderMessage = _orderMessage;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if ([titleStr isEqual:@"确认收货"]){
        [self doquerenshouhuo];
    }else if ([titleStr isEqual:@"查看物流"]){
        LogisticsMsgViewController *vc = [[LogisticsMsgViewController alloc]init];
        vc.orderMessage = _orderMessage;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if ([titleStr isEqual:@"再次购买"]){
        [self doAgainBuyOrder];
    }else if ([titleStr isEqual:@"删除订单"]){
        [self doDeateOrder];
    }else if ([titleStr isEqual:@"立即付款"]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:WYWXApiPaySuccess object:nil];
        [self doPayNow];
    }
}
- (void)doPayNow{
    if (!payTypeView) {
        payTypeView = [[payTypeSelectView alloc] init];
        WeakSelf;
        payTypeView.block = ^(NSString * _Nonnull type) {
            [weakSelf doPayWithType:type];
        };
        [self.view addSubview:payTypeView];
    }else{
        [payTypeView show];
    }
}
- (void)doPayWithType:(NSString *)type{
    [MBProgressHUD showMessage:@"订单支付中"];
    [WYToolClass postNetworkWithUrl:@"order/pay" andParameter:@{@"uni":minstr([_orderMessage valueForKey:@"order_id"]),@"paytype":type,@"from":@"ios"} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            if ([type isEqual:@"yue"]) {
                [MBProgressHUD showError:msg];
                if (self.block) {
                    self.block();
                }
                [self getNeworderMessage];
            }else{
                NSDictionary *result = [info valueForKey:@"result"];
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

            }
        }
    } fail:^{
        
    }];

}
- (void)wxPayResult:(NSNotification *)not{
    [MBProgressHUD hideHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    PayResp *response = not.object;
    switch (response.errCode)
    {
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            [MBProgressHUD showError:@"支付成功"];
            NSLog(@"支付成功");
            if (self.block) {
                self.block();
            }
            [self getNeworderMessage];

            break;
        case WXErrCodeUserCancel:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            //交易取消
            [MBProgressHUD showError:@"已取消支付"];
            break;
        default:
            [MBProgressHUD showError:@"支付失败"];
            break;
    }

}

- (void)doquerenshouhuo{
    
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"为保障权益，请收到货确认无误后，再确认收货" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doQueRen];
    }];
    [sureAction setValue:normalColors forKey:@"_titleTextColor"];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];

}
- (void)doQueRen{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"order/take" andParameter:@{@"uni":minstr([_orderMessage valueForKey:@"order_id"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            NSInteger gain_integral = [minstr([info valueForKey:@"gain_integral"]) integerValue];
            NSInteger gain_coupon = [minstr([info valueForKey:@"gain_coupon"]) integerValue];
            if (gain_integral == 0 && gain_coupon == 0) {
                [MBProgressHUD showSuccess:msg];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getNeworderMessage];
                });
            }else{
                [self showSenfGiftViewWithGain_integral:gain_integral andGain_coupon:gain_coupon];
            }
            if (self.block) {
                self.block();
            }
        }
    } fail:^{
        
    }];

}
- (void)showSenfGiftViewWithGain_integral:(NSInteger)gain_integral andGain_coupon:(NSInteger)gain_coupon{
    sendGiftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    sendGiftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:sendGiftView];
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10;
    [sendGiftView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sendGiftView);
        make.width.equalTo(sendGiftView).multipliedBy(0.75);
    }];
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"promoter"];
    [whiteView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(whiteView);
        make.height.equalTo(imgV.mas_width).multipliedBy(0.482);
    }];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.font = [UIFont boldSystemFontOfSize:15];
    titleL.textColor = color32;
    [whiteView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(imgV.mas_bottom).offset(15);
    }];
    UILabel *messageL = [[UILabel alloc]init];
    messageL.font = SYS_Font(13);
    messageL.textColor = color64;
    messageL.numberOfLines = 0;
    messageL.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:messageL];
    [messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.width.equalTo(whiteView).multipliedBy(0.8);
        make.top.equalTo(titleL.mas_bottom).offset(15);
    }];
    if (gain_integral != 0 && gain_coupon != 0) {
        titleL.text = @"恭喜您获得优惠礼包";
        messageL.text = [NSString stringWithFormat:@"恭喜您获得%ld元优惠券以及%ld积分，购买商品时可抵现哦~",gain_coupon,gain_integral];
    }else if (gain_integral != 0){
        titleL.text = @"赠送积分";
        messageL.text = [NSString stringWithFormat:@"恭喜您获得%ld积分，购买商品时可抵现哦~",gain_integral];

    }else{
        titleL.text = @"恭喜您获得优惠券";
        messageL.text = [NSString stringWithFormat:@"恭喜您获得%ld元优惠券，购买商品时可抵现哦~",gain_coupon];
    }
    UIButton *button = [UIButton buttonWithType:0];
    [button setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:0];
    [button setTitle:@"我知道了" forState:0];
    button.titleLabel.font = SYS_Font(15);
    [button setCornerRadius:15];
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(wozhidaole) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.width.equalTo(whiteView).multipliedBy(0.55);
        make.top.equalTo(messageL.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(whiteView).offset(-20);
    }];

}
- (void)wozhidaole{
    [self getNeworderMessage];
    [sendGiftView removeFromSuperview];
    sendGiftView = nil;
}
- (void)doDeateOrder{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"order/del" andParameter:@{@"uni":minstr([_orderMessage valueForKey:@"order_id"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"删除成功"];
        if (code == 200) {
            if (self.block) {
                self.block();
            }
            [self doReturn];
        }
    } fail:^{
        
    }];

}
- (void)doAgainBuyOrder{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"order/again" andParameter:@{@"uni":minstr([_orderMessage valueForKey:@"order_id"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [self doBuyAndPayView:minstr([info valueForKey:@"cateId"])];
        }else{
            [MBProgressHUD hideHUD];
        }
    } fail:^{
        
    }];

}
- (void)doBuyAndPayView:(NSString *)cartID{
    [WYToolClass postNetworkWithUrl:@"order/confirm" andParameter:@{@"cartId":cartID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            SubmitOrderViewController *vc = [[SubmitOrderViewController alloc]init];
            vc.orderMessage = [info mutableCopy];
            vc.liveUid = @"";
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } fail:^{
        
    }];

}
- (void)getNeworderMessage{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@?status=0",minstr([_orderMessage valueForKey:@"order_id"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            _orderMessage = info;
            _goodsArray = [NSMutableArray array];
            for (NSDictionary *dic in [_orderMessage valueForKey:@"cartInfo"]) {
                cartModel *model = [[cartModel alloc]initWithDic:dic];
                [_goodsArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                  [_backScrollView removeAllSubViews];
                  [self creatUI];
                  if (_bottomView) {
                      [_bottomView removeFromSuperview];
                      _bottomView = nil;
                      [self.view addSubview:self.bottomView];
                  }
            });
        }
    } Fail:^{
        
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
