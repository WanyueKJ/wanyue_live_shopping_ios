//
//  GoodsSearchViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/20.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "GoodsSearchViewController.h"
#import "liveGoodsCell.h"
#import "GoodsDetailsViewController.h"
@interface GoodsSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int page;
    NSMutableArray *infoArray;
    UITextField *searchTextF;
    NSArray *keyArray;
    NSString *searchString;
}
@property (nonatomic,strong) UITableView *searchTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation GoodsSearchViewController

- (void)addSearchView{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 46)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(15, 8, _window_width-75, 30)];
    searchTextF.font = SYS_Font(14);
    searchTextF.placeholder = @"搜索商品名称关键字";
    searchTextF.leftViewMode = UITextFieldViewModeAlways;
    searchTextF.layer.cornerRadius = 15;
    searchTextF.layer.masksToBounds = YES;
    searchTextF.backgroundColor = RGB_COLOR(@"#F5F5F5", 1);
    searchTextF.returnKeyType = UIReturnKeySearch;
    searchTextF.delegate = self;
    [searchView addSubview:searchTextF];
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 20, 20)];
    imgV.image = [UIImage imageNamed:@"搜索"];
    [leftV addSubview:imgV];
    searchTextF.leftView = leftV;
    UIButton *searchBtn = [UIButton buttonWithType:0];
    searchBtn.frame = CGRectMake(searchTextF.right+5, 8, 50, 30);
    [searchBtn setTitle:@"搜索" forState:0];
    [searchBtn setTitleColor:color32 forState:0];
    searchBtn.titleLabel.font = SYS_Font(14);
    [searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
}
- (void)doSearch{
    searchString = searchTextF.text;
    page = 1;
    [self requestData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doSearch];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"搜索商品";
    self.nothingImgV.image = [UIImage imageNamed:@"noSearch"];
    infoArray = [NSMutableArray array];
    page = 1;
    searchString = @"";
    [self addSearchView];
    [self.view addSubview:self.searchTableView];
    [self requestSearchKeyword];
}
- (void)requestSearchKeyword{
    [WYToolClass getQCloudWithUrl:@"search/keyword" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            keyArray = info;
            if (keyArray.count > 0) {
                [self creatTableHeader];
            }
        }
    } Fail:^{
        
    }];
    
}
- (void)creatTableHeader{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 93.5)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, _window_width-30, 18)];
    label.text = @"热门搜索";
    label.textColor = color96;
    label.font = SYS_Font(15);
    [view addSubview:label];
    CGFloat leftS = 15;
    CGFloat topS = label.bottom + 15;
    for (int i = 0; i < keyArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:keyArray[i] forState:0];
        [btn setTitleColor:color32 forState:0];
        btn.titleLabel.font = SYS_Font(15);
        btn.layer.cornerRadius = 2.5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = color96.CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(keyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = [[WYToolClass sharedInstance] widthOfString:keyArray[i] andFont:SYS_Font(15) andHeight:30] + 20;
        if (leftS + width > _window_width) {
            leftS = 15;
            topS += 40;
        }
        btn.frame = CGRectMake(leftS, topS, width, 30);
        [view addSubview:btn];
        leftS = leftS + width + 10;
        if (i == keyArray.count -1) {
            view.height = btn.bottom + 20;
        }
    }
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, view.height-5, _window_width, 5) andColor:colorf0 andView:view];
    _searchTableView.tableHeaderView = view;
    _nothingImgView.y = view.height + 20;
}
- (void)keyBtnClick:(UIButton *)sender{
    searchString = sender.titleLabel.text;
    page = 1;
    [self requestData];
}
- (void)requestData{
    [searchTextF resignFirstResponder];
    NSString *url = [NSString stringWithFormat:@"products?keyword=%@",searchString];
    [WYToolClass getQCloudWithUrl:url Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_searchTableView.mj_header endRefreshing];
        [_searchTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [infoArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                liveGoodsModel *model = [[liveGoodsModel alloc]initWithDic:dic];
                [infoArray addObject:model];
            }
            [_searchTableView reloadData];
            if ([info count] < 20) {
                [_searchTableView.mj_footer endRefreshingWithNoMoreData];
            }
            if ([infoArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }
        }
        
    } Fail:^{
        [_searchTableView.mj_header endRefreshing];
        [_searchTableView.mj_footer endRefreshing];
    }];
}
-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight + 50, _window_width, _window_height-64-statusbarHeight-50) style:0];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorStyle = 0;
        _searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        [_searchTableView addSubview:self.nothingImgView];
    }
    return _searchTableView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.5)];
        _nothingImgView.image = [UIImage imageNamed:@"noSearch"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    liveGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveGoodsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"liveGoodsCell" owner:nil options:nil] lastObject];
        cell.caozuoBtn.hidden = YES;
        cell.salesNumL.hidden = NO;
    }
    liveGoodsModel *model = infoArray[indexPath.row];
    cell.model = model;
    cell.salesNumL.text = [NSString stringWithFormat:@"已售%@件",model.sales];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    liveGoodsModel *model = infoArray[indexPath.row];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
    vc.goodsID = model.goodsID;
    vc.liveUid = @"";
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

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
