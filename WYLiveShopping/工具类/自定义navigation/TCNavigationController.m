//
//  TCViewController.m
//  TCLVBIMDemo
//
//  Created by annidyfeng on 16/7/29.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "TCNavigationController.h"
#import "UIImage+Additions.h"

@interface TCNavigationController ()

@end

@implementation TCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (void)initialize
{
    if (self == [TCNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearance];
//        [bar setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
        [bar setTintColor:[UIColor blackColor]];
//        [bar setBarTintColor: UIColorFromRGB(0xF5F5F5)];
//        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x000000)}];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
    BOOL rorate = [self.viewControllers.lastObject shouldAutorotate];
    return rorate;
}

//ios5.0 横竖屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self shouldAutorotate];
}

@end
