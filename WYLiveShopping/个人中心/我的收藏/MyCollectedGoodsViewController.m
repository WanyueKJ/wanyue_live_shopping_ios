//
//  MyCollectedGoodsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MyCollectedGoodsViewController.h"
#import "recommendView.h"
#import "collectGoodsCell.h"
#import "GoodsDetailsViewController.h"

@interface MyCollectedGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,collectGoodsCellDelegate>{
    int page;
    NSMutableArray *dataArray;
}
@property (nonatomic,strong) recommendView *recommendV;
@property (nonatomic,strong) UITableView *collectTableView;

@end

@implementation MyCollectedGoodsViewController
-(recommendView *)recommendV{
    if (!_recommendV) {
        _recommendV = [[recommendView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _collectTableView.height) andNothingImage:[UIImage imageNamed:@"noCollection"]];
        _recommendV.hidden = YES;
    }
    return _recommendV;
}
- (UITableView *)collectTableView{
    if (!_collectTableView) {
        _collectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height- (self.naviView.bottom + ShowDiff)) style:0];
        _collectTableView.delegate = self;
        _collectTableView.dataSource = self;
        _collectTableView.separatorStyle = 0;
        _collectTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _collectTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];

    }
    return _collectTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"收藏商品";
    page = 1;
    dataArray = [NSMutableArray array];
    [self.view addSubview:self.collectTableView];
    [self requestData];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"collect/user?page=%d&limit=20",page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_collectTableView.mj_header endRefreshing];
        [_collectTableView.mj_footer endRefreshing];

        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                collectGoodsModel *model = [[collectGoodsModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            [_collectTableView reloadData];
            if (dataArray.count == 0) {
                if (!_recommendV) {
                    [_collectTableView addSubview:self.recommendV];
                }
                _recommendV.hidden = NO;
            }else{
                _recommendV.hidden = YES;
                if ([info count] < 20) {
                    [_collectTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    } Fail:^{
        [_collectTableView.mj_header endRefreshing];
        [_collectTableView.mj_footer endRefreshing];

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    collectGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"collectGoodsCell" owner:nil options:nil] lastObject];
        cell.delegate = self;
    }
    cell.model = dataArray[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    collectGoodsModel *model = dataArray[indexPath.row];
    vc.goodsID = model.pid;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)removeCollected:(collectGoodsModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"collect/del" andParameter:@{@"id":model.pid,@"category":model.category} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [MBProgressHUD showSuccess:@"取消收藏成功"];
            [dataArray removeObject:model];
            [_collectTableView reloadData];
            if (dataArray.count == 0) {
                if (!_recommendV) {
                    [_collectTableView addSubview:self.recommendV];
                }
                _recommendV.hidden = NO;
            }
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
