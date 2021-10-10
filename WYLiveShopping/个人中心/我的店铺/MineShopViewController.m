//
//  MineShopViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/20.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MineShopViewController.h"
#import "WYButton.h"
#import "mineProfitViewController.h"
#import "GoodsAdminViewController.h"
#import "adminAddViewController.h"
#import "StoreOrderListViewController.h"

@interface MineShopViewController (){
    UIView *headerView;
    UIView *orderView;
    UIButton *waitPayBtn;
    UIButton *waitSendBtn;
    UIButton *sendBtn;
    UIView *goodsView;
}
@property (nonatomic,strong) NSMutableArray *labelArray;
@property (nonatomic,strong) NSMutableArray *orderLabelArray;
@property (nonatomic,strong) NSDictionary *infoDic;


@end

@implementation MineShopViewController
-(void)doReturn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:0];
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = normalColors;
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = @"我的店铺";
    _labelArray = [NSMutableArray array];
    _orderLabelArray = [NSMutableArray array];
    [self creatUI];
    [self requestData];
}
- (void)creatUI{
    UIImageView *colorImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 76)];
    colorImgView.backgroundColor = normalColors;
    colorImgView.userInteractionEnabled = YES;
    [self.view addSubview:colorImgView];
    colorImgView.layer.mask = [[WYToolClass sharedInstance] setViewLeftBottom:25 andRightBottom:25 andView:colorImgView];
    NSArray *array = @[@"店铺订单",@"店铺收益",@"商家后台"];
    NSArray *array2 = @[@[@"待发货",@"待收货",@"待评价"],@[@"今日收益(元)",@"总收益(元)",@"已结算(元)",@"未结算(元)"],@[]];
    CGFloat toppppp = 80+statusbarHeight;
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, toppppp, _window_width-30, i==1?200:110)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3.0;
        view.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.05].CGColor;
        view.layer.borderWidth = 0.5;
        [self.view addSubview:view];
        toppppp = view.bottom + 10;
        UIButton *rightBtn = [UIButton buttonWithType:0];
        [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag = 1000 + i;
        [view addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-5);
            make.top.equalTo(view);
            make.height.mas_equalTo(44);
        }];
        UIImageView *rightImgV = [[UIImageView alloc]init];
        rightImgV.image = [UIImage imageNamed:@"mine_right"];
        [rightBtn addSubview:rightImgV];
        [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(rightBtn);
            make.height.mas_equalTo(13);
            make.width.equalTo(rightImgV.mas_width);
        }];
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = SYS_Font(12);
        rightLabel.textColor = RGB_COLOR(@"#dcdcdc", 1);
        if (i == 0) {
            rightLabel.text = @"查看全部订单";
        }else if (i == 1){
            rightLabel.text = @"查看详情";
        }else{
            rightBtn.hidden = YES;
        }
        [rightBtn addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightBtn);
            make.right.equalTo(rightImgV.mas_left).offset(-2);
            make.centerY.equalTo(rightBtn);
        }];
        UIImageView *leftImgV = [[UIImageView alloc]init];
        leftImgV.image = [UIImage imageNamed:@"代销竖线"];
        [view addSubview:leftImgV];
        [leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(rightBtn);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(13);
        }];

        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = color32;
        label.text = array[i];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImgV.mas_right).offset(5);
            make.centerY.equalTo(rightBtn);
        }];

        NSArray *contentArray = array2[i];
        for (int j = 0; j < contentArray.count; j ++) {
            UILabel *topLabel = [[UILabel alloc]init];
            topLabel.font = SYS_Font(12);
            topLabel.textColor = color64;
            topLabel.text = contentArray[j];
            [view addSubview:topLabel];
            [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    if (j == 0) {
                        make.left.equalTo(label);
                    }else if (j == 1) {
                        make.left.equalTo(view.mas_centerX).offset(-35);
                    }else{
                        make.centerX.equalTo(view).multipliedBy(1.5);
                    }
                    make.centerY.equalTo(rightBtn.mas_bottom).offset(16);
                }else{
                    if (j%2 == 0) {
                        make.left.equalTo(label);
                    }else{
                        make.left.equalTo(view.mas_centerX).offset(30);
                    }
                    make.centerY.equalTo(rightBtn.mas_bottom).offset(16 + (j/2)*75);
                }
            }];
            UILabel *botLabel = [[UILabel alloc]init];
            if (i == 1) {
                botLabel.textColor = normalColors;
            }else{
                botLabel.textColor = color32;
            }
            botLabel.font = [UIFont boldSystemFontOfSize:20];
            botLabel.text = @"0";
            [view addSubview:botLabel];
            [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(topLabel);
                make.top.equalTo(topLabel.mas_bottom).offset(10);
            }];
            [_labelArray addObject:botLabel];
        }
        if ( i == 2) {
            UILabel *topLabel = [[UILabel alloc]init];
            topLabel.text = @"发布商品/管理订单请前往PC端商家后台";
            topLabel.font = SYS_Font(12);
            topLabel.textColor = color64;
            [view addSubview:topLabel];
            [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label);
                make.centerY.equalTo(view).offset(-2);
            }];
            
            UILabel *botLabel = [[UILabel alloc]init];
            botLabel.text = [common shop_url];
            botLabel.font = SYS_Font(12);
            botLabel.textColor = color32;
            [view addSubview:botLabel];
            [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label);
                make.top.equalTo(topLabel.mas_bottom).offset(15);
            }];
            UIButton *copyBtn = [UIButton buttonWithType:0];
            [copyBtn setTitle:@"复制地址" forState:0];
            [copyBtn setTitleColor:normalColors forState:0];
            [copyBtn addTarget:self action:@selector(doCopy) forControlEvents:UIControlEventTouchUpInside];
            copyBtn.titleLabel.font = SYS_Font(10);
            [view addSubview:copyBtn];
            [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(botLabel);
                make.left.equalTo(botLabel.mas_right).offset(15);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(20);
                make.right.lessThanOrEqualTo(view).offset(-10);
            }];
        }

    }
}
- (void)rightButtonClick:(UIButton *)sender{
    NSLog(@"店铺%ld",sender.tag - 1000);
    if (sender.tag == 1000) {
        StoreOrderListViewController *vc = [[StoreOrderListViewController alloc]init];
        vc.statusType = @"2";
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){
        mineProfitViewController *vc = [[mineProfitViewController alloc]init];
        vc.ptofitType = 1;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
    else{
        
    }

}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"shop" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            _infoDic = info;
            for (int i = 0; i < _labelArray.count; i ++) {
                UILabel *label = _labelArray[i];
                if (i == 0) {
                    label.text = minstr([info valueForKey:@"unshipped"]);
                }
                else if (i == 1) {
                    label.text = minstr([info valueForKey:@"received"]);
                }
                else if (i == 2) {
                    label.text = minstr([info valueForKey:@"evaluated"]);
                }
//                else if (i == 3) {
//                    label.text = minstr([info valueForKey:@"orders_all"]);
//                }
                else if (i == 3) {
                    label.attributedText = [self setAttText:minstr([info valueForKey:@"shop_t"])];
                }
                else if (i == 4) {
                    label.attributedText = [self setAttText:minstr([info valueForKey:@"shop_all"])];
                }
                else if (i == 5) {
                    label.attributedText = [self setAttText:minstr([info valueForKey:@"shop_ok"])];
                }
                else if (i == 6) {
                    label.attributedText = [self setAttText:minstr([info valueForKey:@"shop_no"])];
                }

            }
        }
    } Fail:^{
        
    }];

}
- (NSAttributedString *)setAttText:(NSString *)nums{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:nums];
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, [nums rangeOfString:@"."].location)];
    return muStr;
}
- (void)doCopy{
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = [common shop_url];
    [MBProgressHUD showError:@"复制成功"];

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
