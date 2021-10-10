//
//  GoodsAdminViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "GoodsAdminViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "GoodsListViewController.h"
#import "adminAddViewController.h"
@interface GoodsAdminViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>{
    NSString *shopsalenums;
    NSString *shopnumsno;
}
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation GoodsAdminViewController
-(void)addBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-60-ShowDiff, _window_width, 60 + ShowDiff)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *addBtn = [UIButton buttonWithType:0];
    addBtn.frame = CGRectMake(15, 12, _window_width - 30, 36);
    [addBtn setTitle:@"添加商品" forState:0];
    [addBtn setBackgroundColor:normalColors];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    addBtn.layer.cornerRadius = 18;
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.borderColor = normalColors.CGColor;
    addBtn.layer.borderWidth = 0.5;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];

}
- (void)addBtnClick:(UIButton *)sender{
    adminAddViewController *vc = [[adminAddViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"商品管理";
    shopsalenums = @"0";
    shopnumsno = @"0";
    [self creatHeaderView];
    [self addPagerController];
    [self loadData];
    [self addBottomView];
    [self getSellerGoodsNum];
    [self getShopnumsno];

}
- (void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 50)];
    headerView.backgroundColor = RGB_COLOR(@"#ffffff", 1);
    [self.view addSubview:headerView];
        
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layer.cornerRadius = 4;
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.selectedTextColor = color32;
    tabBar.layout.normalTextColor = color96;
    tabBar.layout.selectedTextFont = SYS_Font(14);
    tabBar.layout.normalTextFont = SYS_Font(14);
    tabBar.layout.cellWidth = _window_width/2;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.progressColor = normalColors;
    tabBar.layout.progressWidth = 20;
    tabBar.layout.progressHeight = 2;
    tabBar.layout.progressRadius = 1;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [headerView addSubview:tabBar];
    _tabBar = tabBar;

}
- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0,  0, _window_width, 50);
    _pagerController.view.frame = CGRectMake(0, self.naviView.bottom + 50, _window_width, _window_height-(self.naviView.bottom + 50) -ShowDiff - 60);
}
- (void)loadData {
    _datas = @[[NSString stringWithFormat:@"在售 %@",shopsalenums],[NSString stringWithFormat:@"已下架 %@",shopnumsno]].mutableCopy;
    [self reloadData];
}
#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index] ;
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    GoodsListViewController *VC = [[GoodsListViewController alloc]init];
    VC.index = index;
    WeakSelf;
    VC.block = ^{
        [weakSelf getSellerGoodsNum];
        [weakSelf getShopnumsno];
    };
    return VC;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}
- (void)getSellerGoodsNum{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"shopnums?liveuid=%@",[Config getOwnID]] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            shopsalenums = minstr([info valueForKey:@"nums"]);
            _datas = @[[NSString stringWithFormat:@"在售 %@",shopsalenums],[NSString stringWithFormat:@"已下架 %@",shopnumsno]].mutableCopy;
            [_tabBar reloadData];
        }
    } Fail:^{
        
    }];
}
- (void)getShopnumsno{
    [WYToolClass getQCloudWithUrl:@"shopnumsno" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            shopnumsno = minstr([info valueForKey:@"nums"]);
            _datas = @[[NSString stringWithFormat:@"在售 %@",shopsalenums],[NSString stringWithFormat:@"已下架 %@",shopnumsno]].mutableCopy;
            [_tabBar reloadData];

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
