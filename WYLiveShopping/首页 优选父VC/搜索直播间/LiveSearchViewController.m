//
//  LiveSearchViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/20.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "LiveSearchViewController.h"
#import "HomeLiveCell.h"
#import "LivePlayerViewController.h"

@interface LiveSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>{
    NSMutableArray *infoArray;
    int page;
    UITextField *searchTextF;

}
@property (nonatomic,strong) UICollectionView *classCollectionView;
@property (nonatomic,strong) UIImageView *nothingImgView;

@end

@implementation LiveSearchViewController
- (void)addSearchView{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 46)];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(15, 8, _window_width-75, 30)];
    searchTextF.font = SYS_Font(14);
    searchTextF.placeholder = @"搜索直播间ID或房间名称";
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
    page = 1;
    [self requestData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doSearch];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"搜索直播间";
    infoArray = [NSMutableArray array];
    page = 1;
    [self addSearchView];
    [self.view addSubview:self.classCollectionView];

}
- (UICollectionView *)classCollectionView{
    if (!_classCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
            flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake((_window_width-25)/2, (_window_width-25)/2 * 1.2 + 70);
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        flow.sectionInset = UIEdgeInsetsMake(5, 10,5, 10);
        _classCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight + 50, _window_width, _window_height-64-statusbarHeight-50) collectionViewLayout:flow];
        [_classCollectionView registerNib:[UINib nibWithNibName:@"HomeLiveCell" bundle:nil] forCellWithReuseIdentifier:@"HomeLiveCELL"];
        _classCollectionView.delegate =self;
        _classCollectionView.dataSource = self;
        _classCollectionView.backgroundColor = RGB_COLOR(@"#ffffff", 1);
        _classCollectionView.mj_footer  = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        _classCollectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        if (@available(iOS 11.0, *)) {
            _classCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_classCollectionView addSubview:self.nothingImgView];
    }
    return _classCollectionView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.6)];
        _nothingImgView.image = [UIImage imageNamed:@"noSearch"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}


- (void)requestData{
    [searchTextF resignFirstResponder];
    NSString *url = [NSString stringWithFormat:@"livesearch?keyword=%@",searchTextF.text];
    [WYToolClass getQCloudWithUrl:url Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_classCollectionView.mj_header endRefreshing];
        [_classCollectionView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [infoArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                HomeLiveModel *model = [[HomeLiveModel alloc]initWithDic:dic];
                [infoArray addObject:model];
            }
            [_classCollectionView reloadData];
            if ([info count] < 20) {
                [_classCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if ([infoArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }
        }
        
    } Fail:^{
        [_classCollectionView.mj_header endRefreshing];
        [_classCollectionView.mj_footer endRefreshing];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return infoArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HomeLiveModel *model = infoArray[indexPath.row];
    [MBProgressHUD showMessage:@""];
    [self checkLive:model];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeLiveCell *cell = (HomeLiveCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeLiveCELL" forIndexPath:indexPath];
    cell.model = infoArray[indexPath.row];
    
    return cell;
}
- (void)checkLive:(HomeLiveModel *)model{
    [WYToolClass postNetworkWithUrl:@"live/check" andParameter:@{@"stream":model.stream} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            LivePlayerViewController *player = [[LivePlayerViewController alloc]init];
            player.roomDic = [model.originDic mutableCopy];
            [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
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
