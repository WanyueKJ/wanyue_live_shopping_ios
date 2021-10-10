//
//  BilldetailsViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "BilldetailsViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "BillListViewController.h"

@interface BilldetailsViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
//page
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation BilldetailsViewController
- (void)addtabbar{
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.selectedTextColor = normalColors;
    tabBar.layout.normalTextColor = color32;
    tabBar.layout.selectedTextFont = SYS_Font(15);
    tabBar.layout.normalTextFont = SYS_Font(15);
    tabBar.layout.cellWidth = _window_width/3;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.progressColor = normalColors;
    tabBar.layout.progressWidth = _window_width/3;
    tabBar.layout.progressHeight = 1;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
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
- (void)loadData {
    _datas = @[
        @"全部",@"消费",@"充值"
    ].mutableCopy;
    [self reloadData];
}
- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"账单明细";
    [self addtabbar];
    [self addPagerController];
    [self loadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_pagerController scrollToControllerAtIndex:_showIndex animate:YES];
    });

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0,  self.naviView.bottom, _window_width, 50);
    _pagerController.view.frame = CGRectMake(0, _tabBar.bottom, _window_width, _window_height-(_tabBar.bottom));
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
    BillListViewController *VC = [[BillListViewController alloc]init];
    VC.type = [NSString stringWithFormat:@"%ld",index];
    return VC;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
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
