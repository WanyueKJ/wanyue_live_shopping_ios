//
//  OrderListViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCell.h"
#import "OrderDetailsViewController.h"
#import "payTypeSelectView.h"
#import <WXApi.h>

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource,OrderCellControlDelegate>{
    NSMutableArray *dataArray;
    int page;
    payTypeSelectView *payTypeView;
    orderModel *payModel;
}
@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation OrderListViewController
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height-(64 +statusbarHeight + 153) -ShowDiff) style:0];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.separatorStyle = 0;
        _orderTableView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
        _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _orderTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        [_orderTableView addSubview:self.nothingImgView];

    }
    return _orderTableView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.55)];
        _nothingImgView.image = [UIImage imageNamed:@"noOrder"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil] lastObject];
        if ([_orderType isEqual:@"1"] || [_orderType isEqual:@"2"]) {
            cell.leftBtn.hidden = YES;
            [cell.rightBtn setTitle:@"查看详情" forState:0];
            cell.rightBtn.userInteractionEnabled = NO;
        }
        if ([_orderType isEqual:@"3"]) {
            cell.leftBtn.hidden = YES;
            [cell.rightBtn setTitle:@"去评价" forState:0];
            cell.rightBtn.userInteractionEnabled = NO;
        }
        if ([_orderType isEqual:@"4"]) {
            [cell.leftBtn setTitle:@"再次购买" forState:0];
            [cell.leftBtn setBackgroundColor:normalColors];
            [cell.leftBtn setTitleColor:[UIColor whiteColor] forState:0];
            [cell.leftBtn setBorderColor:[UIColor clearColor]];
            [cell.rightBtn setTitle:@"删除订单" forState:0];
            [cell.rightBtn setBackgroundColor:[UIColor whiteColor]];
            [cell.rightBtn setTitleColor:RGB_COLOR(@"#A9A9A9", 1) forState:0];
            [cell.rightBtn setBorderColor:RGB_COLOR(@"#dddddd", 1)];
            [cell.rightBtn setBorderWidth:1];
        }
    }
    cell.delegate = self;
    cell.model = dataArray[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    orderModel *model = dataArray[indexPath.row];
    return model.rowH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@""];
    orderModel *model = dataArray[indexPath.row];
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@?status=0",model.orderNums] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            OrderDetailsViewController *vc = [[OrderDetailsViewController alloc]init];
            vc.orderMessage = info;
            vc.isCart = NO;
            vc.orderType = 0;
            WeakSelf;
            vc.block = ^{
                [dataArray removeObject:model];
                [weakSelf.orderTableView reloadData];
                if (weakSelf.block) {
                    weakSelf.block();
                }
            };
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } Fail:^{
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    dataArray = [NSMutableArray array];
    page = 1;
    [self.view addSubview:self.orderTableView];
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated{
    if ([_orderType isEqual:@"0"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:WYWXApiPaySuccess object:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    if ([_orderType isEqual:@"0"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/list?type=%@&status=0&page=%d",_orderType,page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_orderTableView.mj_header endRefreshing];
        [_orderTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
                if (self.block) {
                    self.block();
                }
            }
            for (NSDictionary *dic in info) {
                orderModel *modle = [[orderModel alloc]initWithDic:dic];
                [dataArray addObject:modle];
            }
            if ([info count] < 20) {
                [_orderTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_orderTableView reloadData];
            if ([dataArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }

        }
    } Fail:^{
        [_orderTableView.mj_header endRefreshing];
        [_orderTableView.mj_footer endRefreshing];
    }];

}
- (void)doRemoveCurrentOrder:(orderModel *)model{
    [dataArray removeObject:model];
    [_orderTableView reloadData];
    if ([dataArray count] == 0) {
        _nothingImgView.hidden = NO;
    }else{
        _nothingImgView.hidden = YES;
    }
    if (self.block) {
        self.block();
    }
}
- (void)doPayOrder:(orderModel *)model{
    payModel = model;
    if (!payTypeView) {
        payTypeView = [[payTypeSelectView alloc] init];
        WeakSelf;
        payTypeView.block = ^(NSString * _Nonnull type) {
            [weakSelf payOrderWithType:type andorderModel:model];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:payTypeView];
    }else{
        [payTypeView show];
    }

}
- (void)payOrderWithType:(NSString *)type andorderModel:(orderModel *)model{
    [MBProgressHUD showMessage:@"订单支付中"];
    [WYToolClass postNetworkWithUrl:@"order/pay" andParameter:@{@"uni":model.orderNums,@"paytype":type,@"from":@"ios"} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            
            if ([type isEqual:@"yue"]) {
                [self doRemoveCurrentOrder:model];
                [MBProgressHUD showError:msg];
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
            NSLog(@"支付成功");
            [self doRemoveCurrentOrder:payModel];
            [MBProgressHUD showError:@"支付成功"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
