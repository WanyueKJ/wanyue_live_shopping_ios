//
//  AdminGoodsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "AdminGoodsViewController.h"
#import "AddGoodsCell.h"
#import "GoodsDetailsViewController.h"

@interface AdminGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,AddGoodsCellDelegate>{
    NSMutableArray *dataArray;
    int page;
    NSString *keywords;
}
@property (nonatomic,strong) UITableView *goodsTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation AdminGoodsViewController
- (void)doSearchGoods{
    page = 1;
    [self requestData];
}

-(UITableView *)goodsTableView{
    if (!_goodsTableView) {
        _goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height-(110 +statusbarHeight + 50) -ShowDiff) style:0];
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
    _keywordStr = @"";
    [self.view addSubview:self.goodsTableView];
    [self requestData];
}
- (void)requestData{
//    NSString *url;
//    if (_index == 0) {
//        url = [NSString stringWithFormat:@"%@shopaddlist?page=%d&cid=%@sid=&keyword=",purl,page,_cid];
//    }else{
//        url = [NSString stringWithFormat:@"%@shoplistno?page=%d",purl,page];
//    }
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"shopaddlist?page=%d&cid=%@sid=&keyword=%@",page,_cid,_keywordStr] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_goodsTableView.mj_header endRefreshing];
        [_goodsTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                model.isAdmin = YES;
                model.is_sale = @"0";
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
    AddGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddGoodsCell" owner:nil options:nil] lastObject];
        [cell.addBtn setTitle:@"一键添加" forState:0];
        cell.delegate = self;
        cell.btnWidth.constant = 70;
    }
    cell.model = dataArray[indexPath.row];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    liveGoodsModel *model = dataArray[indexPath.row];
    vc.goodsID = model.goodsID;
    vc.isAdd = YES;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)addGoodsChange:(liveGoodsModel *)model{
    [dataArray removeObject:model];
    [_goodsTableView reloadData];
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
