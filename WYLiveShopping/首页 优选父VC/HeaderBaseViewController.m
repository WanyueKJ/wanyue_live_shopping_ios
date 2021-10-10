//
//  HeaderBaseViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/17.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "HeaderBaseViewController.h"
#import "LiveSearchViewController.h"
#import "GoodsSearchViewController.h"
#import "WYCarViewController.h"

@interface HeaderBaseViewController ()

@end

@implementation HeaderBaseViewController
- (void)addheaderView{
    UIView *navi =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];
    self.messageBtn = [[WYBadgeButton alloc] initWithFrame:CGRectMake(10, 26.5 + statusbarHeight, 35, 35)];
    [_messageBtn setImage:[UIImage imageNamed:@"home_message"] forState:0];
    [_messageBtn addTarget:self action:@selector(doMessage) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:self.messageBtn];
    [_messageBtn showBadgeWithNumber:0];
    self.carBtn = [[WYBadgeButton alloc] initWithFrame:CGRectMake(_window_width-45, 26.5 + statusbarHeight, 35, 35)];
    [_carBtn setImage:[UIImage imageNamed:@"购物车"] forState:0];
    [_carBtn addTarget:self action:@selector(doCar) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:self.carBtn];
    [_carBtn showBadgeWithNumber:0];
    _searchBtn = [UIButton buttonWithType:0];
    [_searchBtn setImage:[UIImage imageNamed:@"home_search"] forState:0];
    [_searchBtn setTitle:@"  搜索直播间" forState:0];
    [_searchBtn setTitleColor:RGB_COLOR(@"#b4b4b4", 1) forState:0];
    _searchBtn.titleLabel.font = SYS_Font(14);
    [_searchBtn setBackgroundColor:RGB_COLOR(@"#F5F5F5", 1)];
    _searchBtn.layer.cornerRadius = 15;
    _searchBtn.layer.masksToBounds = YES;
    [_searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [navi addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messageBtn.mas_right).offset(15);
        make.right.equalTo(_carBtn.mas_left).offset(-15);
        make.centerY.equalTo(_messageBtn);
        make.height.mas_equalTo(30);
    }];
}
- (void)doMessage{
    
    [MBProgressHUD showError:@"敬请期待"];
}
- (void)doCar{
    WYCarViewController *vc = [[WYCarViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)doSearch{
    if (_searchBtn.selected) {
        GoodsSearchViewController *vc = [[GoodsSearchViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }else{
        LiveSearchViewController *vc = [[LiveSearchViewController alloc]init];
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addheaderView];
    [self requestCartNum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCartNum) name:WYCarNumChange object:nil];

}
- (void)requestCartNum{
    [WYToolClass getQCloudWithUrl:@"cart/count?numType=true" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [_carBtn showBadgeWithNumber:[minstr([info valueForKey:@"count"]) integerValue]];
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
