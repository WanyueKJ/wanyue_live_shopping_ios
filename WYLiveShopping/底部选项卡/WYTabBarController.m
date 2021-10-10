//
//  ZYTabBarController.m
//  tabbar增加弹出bar
//
//  Created by tarena on 16/7/2.
//  Copyright © 2016年 张永强. All rights reserved.
//
#import "WYTabBarController.h"
#import "homeViewController.h"
#import "MineViewController.h"
#import "ClassificationViewController.h"
#import "LivebroadViewController.h"
#import "ApplyShopViewController.h"
//#import "MHSDK.h"
//@import CoreLocation;

@interface WYTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    UIAlertController *alertupdate;
}
@property(nonatomic,strong)NSString *Build;

@end
@implementation WYTabBarController
#pragma mark ============定位=============

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self buildUpdate];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    //设置子视图
    [self setUpAllChildVc];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self setCusTintColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getHomeConfig];
}

#pragma mark  在这里更换 左右tabbar的image
- (void)setUpAllChildVc {
    homeViewController *home = [homeViewController new];
    MineViewController *mine = [MineViewController new];
    ClassificationViewController *class  = [ClassificationViewController new];
//
    [self setUpOneChildVcWithVc:home Image:@"tab_home" selectedImage:@"tab_home_sel" title:@"首页" andTag:0];
    [self setUpOneChildVcWithVc:class Image:@"tab_class" selectedImage:@"tab_class_sel" title:@"分类" andTag:1];
    [self setUpOneChildVcWithVc:mine Image:@"tab_mine" selectedImage:@"tab_mine_sel" title:@"我的" andTag:2];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */

- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title andTag:(int)tttttt
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationController.navigationBar.hidden = YES;
    Vc.tabBarItem.tag = tttttt;
//    Vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -7);
    [Vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
//    [Vc.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];

    [self addChildViewController:nav];
}
-(void)setCusTintColor {
    if (@available(iOS 13.0, *)) {
        UITabBar *tabBar = [UITabBar appearance];
        [tabBar setTintColor:normalColors];
        [tabBar setUnselectedItemTintColor:RGB_COLOR(@"#c8c8c8", 1)];
    } else {
    // Override point for customization after application launch.
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:RGB_COLOR(@"#c8c8c8", 1)} forState:UIControlStateNormal];
        // 选中状态的标题颜色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:normalColors} forState:UIControlStateSelected];
    }

}
//点击开始直播
-(void)buildUpdate{
   
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *VC =nav.topViewController;
    if ([VC isKindOfClass:[homeViewController class]]) {
                
        return YES;
    }else{
        if (![Config getOwnID] || [[Config getOwnID] intValue] == 0) {
            [[WYToolClass sharedInstance] showLoginView];
            return NO;
        }
    }
    return YES;
    
}
- (void)getHomeConfig{
    [WYToolClass getQCloudWithUrl:@"config" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            liveCommon *commons = [[liveCommon alloc]initWithDic:info];
            [common saveProfile:commons];

        }
    } Fail:^{
        
    }];
}

 
@end
