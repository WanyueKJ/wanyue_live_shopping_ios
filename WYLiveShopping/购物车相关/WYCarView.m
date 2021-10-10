//
//  YBCarView.m
//  YBEducation
//
//  Created by IOS1 on 2020/5/5.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYCarView.h"
#import "WYCarViewController.h"

@implementation WYCarView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, _window_height-(50+ShowDiff), _window_width, 50+ShowDiff);
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
        [self requestData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:WYCarNumChange object:nil];

    }
    return self;
}
- (void)creatUI{
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 0, _window_width, 1) andColor:colorf0 andView:self];
    NSArray *array = @[@"客服",@"收藏"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(5+i*45, 0, 45, 50);
        [btn setTitle:array[i] forState:0];
        [btn setTitleColor:color64 forState:0];
        btn.titleLabel.font = SYS_Font(10);
        [btn addTarget:self action:@selector(buttonCLick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"收藏_nor"] forState:0];
            [btn setImage:[UIImage imageNamed:@"收藏_sel"] forState:UIControlStateSelected];
            _collectButton = btn;
        }else{
            [btn setImage:[UIImage imageNamed:@"客服"] forState:0];
        }
        [self addSubview:btn];
        [WYToolClass setUpImgDownText:btn];
    }
    WYBadgeButton *carBtn = [WYBadgeButton buttonWithType:0];
    carBtn.frame = CGRectMake(95, 0, 45, 50);
    [carBtn setImage:[UIImage imageNamed:@"购物车"] forState:0];
    [carBtn setTitle:@"购物车" forState:0];
    [carBtn setTitleColor:color64 forState:0];
    carBtn.titleLabel.font = SYS_Font(10);
    [carBtn addTarget:self action:@selector(doCar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:carBtn];
    carBtn.size = CGSizeMake(90, 100);
    [WYToolClass setUpImgDownText:carBtn];
    carBtn.size = CGSizeMake(45, 50);
    _carButton = carBtn;

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(_carButton.right+5, 7, _window_width - (_carButton.right+5) - 15, 36)];
    backView.layer.cornerRadius = 18;
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    NSArray *array2 = @[@"加入购物车",@"立即购买"];
    for (int i = 0; i < array2.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(i * backView.width/2, 0, backView.width/2, backView.height);
        [btn setTitle:array2[i] forState:0];
        btn.titleLabel.font = SYS_Font(15);
        [btn setBackgroundImage:[UIImage imageNamed:array2[i]] forState:0];
        [backView addSubview:btn];
        if (i == 0) {
            _addButton = btn;
            [btn addTarget:self action:@selector(doAddCar) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn addTarget:self action:@selector(dobuyNow) forControlEvents:UIControlEventTouchUpInside];
            _buyButton = btn;
        }
    }

}
- (void)doCar{
    WYCarViewController *vc = [[WYCarViewController alloc]init];
    vc.goodsIndefiter = _goodsIndefiter;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)doAddCar{
    if (self.block) {
        self.block(0);
    }
}

- (void)dobuyNow{
    if (self.block) {
        self.block(1);
    }
}

- (void)buttonCLick:(UIButton *)sender{
    if (sender == _collectButton) {
        _collectButton.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _collectButton.userInteractionEnabled = YES;
        });
        //收藏
        if (self.block) {
            self.block(2);
        }
    }else {
        //客服
        if (self.block) {
            self.block(3);
        }

//        [MBProgressHUD showError:@"敬请期待"];
    }
}

- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"cart/count?numType=true" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [_carButton showBadgeWithNumber:[minstr([info valueForKey:@"count"]) integerValue]];
        }
    } Fail:^{
        
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
