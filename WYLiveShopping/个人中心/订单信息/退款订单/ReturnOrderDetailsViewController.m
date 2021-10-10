//
//  ReturnOrderDetailsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ReturnOrderDetailsViewController.h"
#import "cartModel.h"
@interface ReturnOrderDetailsViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) NSMutableArray *goodsArray;
@end

@implementation ReturnOrderDetailsViewController
- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height-(self.naviView.bottom))];
        _backScrollView.backgroundColor = colorf0;
    }
    return _backScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:0];
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = color64;
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = @"订单详情";
    _goodsArray = [NSMutableArray array];
    for (NSDictionary *dic in [_orderMessage valueForKey:@"cartInfo"]) {
        cartModel *model = [[cartModel alloc]initWithDic:dic];
        [_goodsArray addObject:model];
    }
    [self creatUI];
}
- (void)creatUI{
    [self.view addSubview:self.backScrollView];
    ///订单状态视图
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 80)];
    statusView.backgroundColor = color64;;
    [_backScrollView addSubview:statusView];
    UILabel *statusTitleL = [[UILabel alloc]init];
    statusTitleL.text = minstr([[_orderMessage valueForKey:@"_status"] valueForKey:@"_msg"]);
    statusTitleL.font = SYS_Font(14);
    statusTitleL.textColor = [UIColor whiteColor];
    [statusView addSubview:statusTitleL];
    [statusTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusView).offset(15);
        make.bottom.equalTo(statusView.mas_centerY);
    }];
    UILabel *statusTimeL = [[UILabel alloc]init];
    statusTimeL.text = minstr([_orderMessage valueForKey:@"_add_time"]);
    statusTimeL.font = SYS_Font(11);
    statusTimeL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [statusView addSubview:statusTimeL];
    [statusTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusTitleL);
        make.top.equalTo(statusTitleL.mas_bottom).offset(10);
    }];
        
    UIView *shopView = [[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom + 10, _window_width, 80 + _goodsArray.count * 80)];
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
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, payView.bottom + 10, _window_width, 130)];
    addressView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:addressView];
    UILabel *adsleftL = [[UILabel alloc]init];
    adsleftL.textColor = color32;
    adsleftL.numberOfLines = 0;
    adsleftL.font = SYS_Font(13);
    adsleftL.text = @"收货人:\n\n联系电话:\n\n收货地址:";
    [addressView addSubview:adsleftL];
    [adsleftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(addressView).offset(15);
        make.width.mas_equalTo(60);
    }];
    UILabel *adsrightL = [[UILabel alloc]init];
    adsrightL.textColor = color96;
    adsrightL.font = SYS_Font(13);
    adsrightL.textAlignment = NSTextAlignmentRight;
    adsrightL.numberOfLines = 0;
    adsrightL.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",minstr([_orderMessage valueForKey:@"real_name"]),minstr([_orderMessage valueForKey:@"user_phone"]),minstr([_orderMessage valueForKey:@"user_address"])];

    [addressView addSubview:adsrightL];
    [adsrightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addressView).offset(-15);
        make.top.equalTo(adsleftL);
        make.left.equalTo(adsleftL.mas_right).offset(40);
    }];

    CGFloat nextBottom = addressView.bottom;
    if ([minstr([_orderMessage valueForKey:@"paid"]) isEqual:@"1"] && [minstr([_orderMessage valueForKey:@"status"]) intValue] > 0) {

        UIView *wuliuView = [[UIView alloc]initWithFrame:CGRectMake(0, addressView.bottom + 10, _window_width, 110)];
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
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0,  nextBottom + 10, _window_width, 120)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
