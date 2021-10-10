//
//  ReturnOrderListViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ReturnOrderListViewController.h"
#import "ReturnOrderCell.h"
#import "orderModel.h"
#import "ReturnOrderDetailsViewController.h"
@interface ReturnOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArray;
    int page;
}
@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation ReturnOrderListViewController
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height-(64 +statusbarHeight)) style:1];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    orderModel *oModel = dataArray[section];
    return oModel.goodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReturnOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnOrderCell" owner:nil options:nil] lastObject];
    }
    orderModel *oModel = dataArray[indexPath.section];
    cell.model = oModel.goodsArray[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 43)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = NO;
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"小店"];
    [view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(16);
    }];
    orderModel *model = dataArray[section];
    UILabel *label = [[UILabel alloc]init];
    label.text = model.store_name;
    label.font = SYS_Font(14);
    label.textColor = color32;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(8);
        make.centerY.equalTo(view);
    }];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 42, _window_width, 1) andColor:RGB_COLOR(@"#eeeeee", 1) andView:view];
    
    UIImageView *statusImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width-65, 8, 50, 50)];
    if ([model.refund_status isEqual:@"2"]) {
        statusImgV.image = [UIImage imageNamed:@"已退款"];
    }else{
        statusImgV.image = [UIImage imageNamed:@"退款中"];
    }
    [view addSubview:statusImgV];

    return view;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 48;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 43)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.font = SYS_Font(14);
    totalLabel.textColor = color32;
    [view addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view).offset(-2.5);
    }];
    orderModel *model = dataArray[section];
    totalLabel.attributedText = [self getAttStrWithNums:model.total_num andTotalMoney:model.total_price];
    [[WYToolClass sharedInstance]lineViewWithFrame:CGRectMake(0, 43, _window_width, 5) andColor:colorf0 andView:view];
    return view;
}
- (NSAttributedString *)getAttStrWithNums:(NSString *)nums andTotalMoney:(NSString *)money{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%@件商品 总金额：¥%@",nums,money]];
    [mustr setAttributes:@{NSForegroundColorAttributeName:normalColors,NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(mustr.length-money.length-1, money.length+1)];
    return mustr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@""];
    orderModel *model = dataArray[indexPath.section];
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@?status=0",model.orderNums] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            ReturnOrderDetailsViewController *vc = [[ReturnOrderDetailsViewController alloc]init];
            vc.orderMessage = info;
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } Fail:^{

    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"退货列表";
    dataArray = [NSMutableArray array];
    page = 1;
    [self.view addSubview:self.orderTableView];
    [self requestData];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/list?type=-3&status=0&page=%d",page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_orderTableView.mj_header endRefreshing];
        [_orderTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
