//
//  adminAddViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "adminAddViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "AdminGoodsViewController.h"
@interface adminAddViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,UITextFieldDelegate>{
    UITextField *searchTextF;
    
}
//page
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic,assign) NSInteger curSelIndex;

@end

@implementation adminAddViewController
- (void)addheaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 46)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(15, 8, _window_width-30, 30)];
    searchTextF.font = SYS_Font(14);
    searchTextF.placeholder = @"搜索商品";
    searchTextF.delegate = self;
    searchTextF.leftViewMode = UITextFieldViewModeAlways;
    searchTextF.layer.cornerRadius = 15;
    searchTextF.layer.masksToBounds = YES;
    searchTextF.backgroundColor = RGB_COLOR(@"#F5F5F5", 1);
    searchTextF.returnKeyType = UIReturnKeySearch;
    [view addSubview:searchTextF];
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 20, 20)];
    imgV.image = [UIImage imageNamed:@"搜索"];
    [leftV addSubview:imgV];
    searchTextF.leftView = leftV;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text != nil && textField.text != NULL && textField.text.length > 0 ) {
        AdminGoodsViewController *vc = (AdminGoodsViewController *)_pagerController.visibleControllers[_curSelIndex];
        vc.keywordStr = minstr(textField.text);
        [vc doSearchGoods];
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.curSelIndex = 0;
    self.titleL.text = @"添加商品";
    [self addheaderView];
    [self addTabPageBar];
    [self addPagerController];
    [self loadData];
    [self requestGoodsClass];
    
}
- (void)addTabPageBar{
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.selectedTextColor = color32;
    tabBar.layout.normalTextColor = color96;
    tabBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:15];
    tabBar.layout.normalTextFont = SYS_Font(14);
    tabBar.layout.cellWidth = 85;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.progressColor = normalColors;
    tabBar.layout.progressWidth = 14;
    tabBar.layout.progressHeight = 2;
    tabBar.layout.progressRadius = 1;
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
    pagerController.scrollView.scrollEnabled = NO;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0,  110+statusbarHeight, _window_width, 50);
    _pagerController.view.frame = CGRectMake(0, _tabBar.bottom , _window_width, _window_height-(_tabBar.bottom) -ShowDiff);
}
- (void)loadData {
    _datas = @[@{@"cate_name":@"精选商品",@"id":@""}].mutableCopy;
    [self reloadData];
}
#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = minstr([_datas[index] valueForKey:@"cate_name"]);
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = minstr([_datas[index] valueForKey:@"cate_name"]);
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
    _curSelIndex = index;
    AdminGoodsViewController *vc = (AdminGoodsViewController *)_pagerController.visibleControllers[_curSelIndex];
    if (vc.keywordStr.length > 0) {
        searchTextF.text = @"";
        vc.keywordStr = @"";
        [vc doSearchGoods];
    }
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    AdminGoodsViewController *VC = [[AdminGoodsViewController alloc]init];
    VC.cid = minstr([_datas[index] valueForKey:@"id"]);
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
- (void)requestGoodsClass{
    [WYToolClass getQCloudWithUrl:@"category" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_datas addObjectsFromArray:info];
        [self reloadData];
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
