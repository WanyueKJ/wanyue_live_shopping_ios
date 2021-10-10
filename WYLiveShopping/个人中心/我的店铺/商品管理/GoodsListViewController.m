//
//  GoodsListViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "GoodsListViewController.h"
#import "adminGoodsCell.h"

@interface GoodsListViewController ()<UITableViewDelegate,UITableViewDataSource,adminGoodsCellDelegate>{
    NSMutableArray *dataArray;
    int page;
}
@property (nonatomic,strong) UITableView *goodsTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation GoodsListViewController
-(UITableView *)goodsTableView{
    if (!_goodsTableView) {
        _goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height-(64 +statusbarHeight + 50) -ShowDiff - 60) style:0];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.separatorStyle = 0;
        _goodsTableView.backgroundColor = colorf0;
        _goodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _goodsTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        if (@available(iOS 13.0, *)) {
            _goodsTableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
        }
        [_goodsTableView addSubview:self.nothingImgView];
    }
    return _goodsTableView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.11, 40, _window_width*0.78, _window_width*0.78*0.81)];
        _nothingImgView.image = [UIImage imageNamed:@"noShops"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    page = 1;
    [self.view addSubview:self.goodsTableView];
    [self requestData];
}
- (void)requestData{
    NSString *url;
    if (_index == 0) {
        url = [NSString stringWithFormat:@"shoplist?page=%d&liveuid=%@",page,[Config getOwnID]];
    }else{
        url = [NSString stringWithFormat:@"shoplistno?page=%d",page];
    }
    [WYToolClass getQCloudWithUrl:url Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_goodsTableView.mj_header endRefreshing];
        [_goodsTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
                if (self.block) {
                    self.block();
                }
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            [_goodsTableView reloadData];
            if (dataArray.count == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }
        }
    } Fail:^{
        [_goodsTableView.mj_header endRefreshing];
        [_goodsTableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    adminGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adminGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"adminGoodsCell" owner:nil options:nil] lastObject];
        cell.delegate = self;
        if (_index == 0) {
            cell.delateBtn.hidden = YES;
            [cell.rightBtn setTitle:@"下架" forState:0];
            [cell.rightBtn setTitleColor:color32 forState:0];
            cell.rightBtn.layer.borderColor = RGB_COLOR(@"#E0E0E0", 1).CGColor;
        }else{
            [cell.rightBtn setTitle:@"上架" forState:0];
            [cell.rightBtn setTitleColor:normalColors forState:0];
            cell.rightBtn.layer.borderColor = normalColors.CGColor;
        }
    }
    cell.model = dataArray[indexPath.row];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}
- (void)shangjiaGoods:(liveGoodsModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"shopadd" andParameter:@{@"productid":model.goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [dataArray removeObject:model];
            [_goodsTableView reloadData];
            if (self.block) {
                self.block();
            }
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (void)xiajiaGoods:(liveGoodsModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"shopedit" andParameter:@{@"productid":model.goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [dataArray removeObject:model];
            [_goodsTableView reloadData];
            if (self.block) {
                self.block();
            }
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];

}
- (void)delateGoods:(liveGoodsModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"shopdel" andParameter:@{@"productid":model.goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [dataArray removeObject:model];
            [_goodsTableView reloadData];
            if (self.block) {
                self.block();
            }
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
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
