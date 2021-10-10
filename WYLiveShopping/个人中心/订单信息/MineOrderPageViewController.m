//
//  MineOrderPageViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MineOrderPageViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "OrderListViewController.h"

@interface MineOrderPageViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>{
    UILabel *numsLabel;
}
//page
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation MineOrderPageViewController
- (void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 153)];
    headerView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    [self.view addSubview:headerView];
    
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 126)];
    colorView.backgroundColor = normalColors;
    [headerView addSubview:colorView];
    UILabel *headerTitleL = [[UILabel alloc]init];
    headerTitleL.text = @"订单信息";
    headerTitleL.font = [UIFont boldSystemFontOfSize:14];
    headerTitleL.textColor = [UIColor whiteColor];
    [colorView addSubview:headerTitleL];
    [headerTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorView).offset(30);
        make.top.equalTo(colorView).offset(20);
    }];
    
    numsLabel = [[UILabel alloc]init];
    numsLabel.text = [NSString stringWithFormat:@"消费订单：%@    总消费：¥ %@",minstr([_orderStatusNum valueForKey:@"order_count"]),minstr([_orderStatusNum valueForKey:@"sum_price"])];
    numsLabel.font = SYS_Font(11);
    numsLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [colorView addSubview:numsLabel];
    [numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerTitleL);
        make.top.equalTo(headerTitleL.mas_bottom).offset(14);
    }];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layer.cornerRadius = 4;
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.selectedTextColor = [UIColor blackColor];
    tabBar.layout.normalTextColor = color32;
    tabBar.layout.selectedTextFont = SYS_Font(14);
    tabBar.layout.normalTextFont = SYS_Font(14);
    tabBar.layout.cellWidth = (_window_width-30)/5;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.progressColor = normalColors;
    tabBar.layout.progressWidth = (_window_width-30)/10;
    tabBar.layout.progressHeight = 2;
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
    _tabBar.frame = CGRectMake(15,  83, _window_width-30, 70);
    _pagerController.view.frame = CGRectMake(0, self.naviView.bottom + 153, _window_width, _window_height-(self.naviView.bottom + 153) -ShowDiff);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.backgroundColor = normalColors;
    self.titleL.textColor = [UIColor whiteColor];
    self.lineView.hidden = YES;
    self.returnBtn.selected = YES;
    self.titleL.text = @"我的订单";
    [self creatHeaderView];
    [self addPagerController];
    [self loadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pagerController scrollToControllerAtIndex:_showIndex animate:YES];
        [self requestCount];

    });
}
- (void)loadData {
    _datas = @[
        [NSString stringWithFormat:@"待付款\n\n%@",minstr([_orderStatusNum valueForKey:@"unpaid_count"])],
        [NSString stringWithFormat:@"待发货\n\n%@",minstr([_orderStatusNum valueForKey:@"unshipped_count"])],
        [NSString stringWithFormat:@"待收货\n\n%@",minstr([_orderStatusNum valueForKey:@"received_count"])],
        [NSString stringWithFormat:@"待评价\n\n%@",minstr([_orderStatusNum valueForKey:@"evaluated_count"])],
        [NSString stringWithFormat:@"已完成\n\n%@",minstr([_orderStatusNum valueForKey:@"complete_count"])],
    ].mutableCopy;
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
    WeakSelf;
    OrderListViewController *VC = [[OrderListViewController alloc]init];
    VC.orderType = [NSString stringWithFormat:@"%ld",index];
    VC.block = ^{
        [weakSelf requestCount];
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
- (void)requestCount{
    [WYToolClass getQCloudWithUrl:@"order/data?status=0" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            _datas = @[
                [NSString stringWithFormat:@"待付款\n\n%@",minstr([info valueForKey:@"unpaid_count"])],
                [NSString stringWithFormat:@"待发货\n\n%@",minstr([info valueForKey:@"unshipped_count"])],
                [NSString stringWithFormat:@"待收货\n\n%@",minstr([info valueForKey:@"received_count"])],
                [NSString stringWithFormat:@"待评价\n\n%@",minstr([info valueForKey:@"evaluated_count"])],
                [NSString stringWithFormat:@"已完成\n\n%@",minstr([info valueForKey:@"complete_count"])],
            ].mutableCopy;
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
