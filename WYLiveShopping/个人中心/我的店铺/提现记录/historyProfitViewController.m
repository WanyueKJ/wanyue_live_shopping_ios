//
//  historyProfitViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "historyProfitViewController.h"
#import "profitHistoryCell.h"
@interface historyProfitViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArray;
    int page;
}
@property (nonatomic,strong) UITableView *profitTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation historyProfitViewController
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, _window_width, _window_width*0.55)];
        _nothingImgView.image = [UIImage imageNamed:@"noTixian"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"提现记录";
    page = 1;
    dataArray = [NSMutableArray array];
    [self.view addSubview:self.profitTableView];
    [self requestHistoryData];

}
- (UITableView *)profitTableView{
    if (!_profitTableView) {
        _profitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight)) style:0];
        _profitTableView.delegate = self;
        _profitTableView.dataSource = self;
        _profitTableView.separatorStyle = 0;
        _profitTableView.backgroundColor = colorf0;
        _profitTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestHistoryData];
        }];
        _profitTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestHistoryData];
        }];
        [_profitTableView addSubview:self.nothingImgView];

    }
    return _profitTableView;
}
- (void)requestHistoryData{
    NSString *url;
    if (_ptofitType == 0) {
        url = @"bringlist";
    }else if (_ptofitType == 1){
        url = @"shopcashlist";
    }

    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"%@?page=%d&limit=20",url,page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_profitTableView.mj_header endRefreshing];
        [_profitTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:info];
            [_profitTableView reloadData];
            if ([dataArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }

        }
    } Fail:^{
        [_profitTableView.mj_header endRefreshing];
        [_profitTableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    profitHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profitHistoryCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"profitHistoryCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = dataArray[indexPath.row];
    cell.orderNumL.text = [NSString stringWithFormat:@"订单%@",minstr([dic valueForKey:@"orderno"])];
    cell.timeL.text = minstr([dic valueForKey:@"addtime"]);
    cell.moneyL.text = [NSString stringWithFormat:@"¥ %@",minstr([dic valueForKey:@"money"])];
    cell.statusL.text = minstr([dic valueForKey:@"status_txt"]);
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
