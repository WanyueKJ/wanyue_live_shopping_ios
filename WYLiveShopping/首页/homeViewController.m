//
//  homeViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/10.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "homeViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "LiveClassViewController.h"
#import "RecommendViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>


@implementation HoverPageScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.scrollViewWhites == nil) return YES;
    for (UIScrollView *item in self.scrollViewWhites) {
        if (otherGestureRecognizer.view == item){
            return YES;
        }
    }
    return NO;
}
@end

@interface homeViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,SDCycleScrollViewDelegate>{
    NSMutableArray *sliderArray;

}

//page
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *datas;

@property(nonatomic, strong) HoverPageScrollView *mainScrollView;
@property(nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播图

@end

@implementation homeViewController
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, _window_width-20, _window_width*0.34) delegate:self placeholderImage:nil];
        _cycleScrollView.currentPageDotImage = [WYToolClass getImgWithColor:[UIColor whiteColor]];
        _cycleScrollView.pageDotImage = [WYToolClass getImgWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
        _cycleScrollView.pageControlDotSize = CGSizeMake(9, 2);
        _cycleScrollView.layer.cornerRadius = 7.5;
        _cycleScrollView.layer.masksToBounds = YES;
    }
    return _cycleScrollView;
}
- (void)showOfReloadSliderView:(NSArray *)array{
    sliderArray = [array mutableCopy];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [imageArray addObject:minstr([dic valueForKey:@"pic"])];
    }
    _cycleScrollView.imageURLStringsGroup = imageArray;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSString *urls = minstr([sliderArray[index] valueForKey:@"wap_url"]);
    if (urls.length > 6) {
        WYWebViewController *web = [[WYWebViewController alloc]init];
        web.urls = urls;
        [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView = [[HoverPageScrollView alloc]init];
    self.mainScrollView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight+ShowDiff+48));
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.height +  _window_width*0.34);
    if (@available(iOS 11.0, *)){
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.mainScrollView addSubview:self.cycleScrollView];
    [self addTabPageBar];
    [self addPagerController];
    [self loadData];
//    [self requestLiveClass];
}
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.selectedTextColor = color32;
    tabBar.layout.normalTextColor = color64;
    tabBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:15];
    tabBar.layout.normalTextFont = SYS_Font(14);
    tabBar.layout.cellWidth = 0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 15;
    tabBar.layout.progressColor = normalColors;
    tabBar.layout.progressWidth = 14;
    tabBar.layout.progressHeight = 2;
    tabBar.layout.progressRadius = 1;
    tabBar.layout.progressVerEdging = 5;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.mainScrollView addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.mainScrollView addSubview:pagerController.view];
    _pagerController = pagerController;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0,  _window_width*0.34, _window_width, 50);
    _pagerController.view.frame = CGRectMake(0, _tabBar.bottom, _window_width, _window_height-(_tabBar.bottom) -48-ShowDiff + _window_width*0.34);
}
- (void)requestLiveClass{
    [WYToolClass getQCloudWithUrl:@"live/class" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_datas addObjectsFromArray:info];
                [self reloadData];
                [_pagerController scrollToControllerAtIndex:1 animate:NO];
            });
        }
    } Fail:^{
        
    }];

}
- (void)loadData {
    _datas = @[@{@"id":@"-1",@"name":@"关注"},@{@"id":@"0",@"name":@"精选"}].mutableCopy;
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = minstr([_datas[index] valueForKey:@"name"]);
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = minstr([_datas[index] valueForKey:@"name"]);
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
    if (index == 1) {
        RecommendViewController *vc = [[RecommendViewController alloc]init];
        WeakSelf;
        vc.block = ^(NSArray * _Nonnull array, NSArray * _Nonnull liveclass) {
            [weakSelf showOfReloadSliderView:array];
            if (liveclass.count != _datas.count) {
                weakSelf.datas = [liveclass mutableCopy];
                [weakSelf reloadData];
            }
        };
        return vc;
    }else{
        LiveClassViewController *VC = [[LiveClassViewController alloc]init];
        if (index == 0) {
            VC.isFollow = YES;
        }
        VC.classID = minstr([_datas[index] valueForKey:@"id"]);
        return VC;

    }
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
    [_pagerController scrollToControllerAtIndex:1 animate:NO];
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
