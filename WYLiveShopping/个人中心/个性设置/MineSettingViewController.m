//
//  MineSettingViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "MineSettingViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "WYRoomManagerVC.h"
@interface MineSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *itemArray;
    UITableView *setTable;
    float MBCache;

}

@end

@implementation MineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"设置";
    self.view.backgroundColor = colorf0;
//    itemArray = @[YZMsg(@"切换语言"),YZMsg(@"联系我们"),YZMsg(@"版本更新"),YZMsg(@"清除缓存")];
    itemArray = @[@"房间管理",@"联系我们",@"版本更新",@"清除缓存"];

    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    MBCache = bytesCache/1000/1000;
    setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 50*itemArray.count+1) style:0];
    setTable.delegate =self;
    setTable.dataSource =self;
    setTable.scrollEnabled = NO;
    [self.view addSubview:setTable];
    
    UIButton *logOutBtn = [UIButton buttonWithType:0];
    logOutBtn.frame = CGRectMake(0, setTable.bottom+60, _window_width, 50);
    [logOutBtn setBackgroundColor:[UIColor whiteColor]];
    [logOutBtn setTitle:@"退出登录" forState:0];
    [logOutBtn setTitleColor:RGB_COLOR(@"#FD4A4A", 1) forState:0];
    logOutBtn.titleLabel.font = SYS_Font(12);
    [logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBtn];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCell"];
        cell.textLabel.font = SYS_Font(12);
        cell.detailTextLabel.font = SYS_Font(12);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = itemArray[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == 1 ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessoryImage"]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 2) {
            NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//本地的版本号
            cell.detailTextLabel.text = build;
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",MBCache];
        }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self roomManager];
            break;
        case 1:
            [self gunayuwomen];
            break;
        case 2:
            [self checkBuild];
            break;
        case 3:
            [self clearCrash];
            break;

        default:
            break;
    }
}
- (void)roomManager{
    WYRoomManagerVC *roomVC = [WYRoomManagerVC new];
    [self.navigationController pushViewController:roomVC animated:YES];
}
- (void)logOutBtnClick{
    [[WYToolClass sharedInstance] quitLogin];
}
- (void)gunayuwomen{

    WYWebViewController *web = [[WYWebViewController alloc]init];
    web.urls = [NSString stringWithFormat:@"%@//appapi/page/detail?id=1",h5url];
    [self.navigationController pushViewController:web animated:YES];
}
- (void)checkBuild{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地
//    NSNumber *build = (NSNumber *)[common ipa_ver];//远程
//    NSComparisonResult r = [app_build compare:build];
//    if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
//        UIAlertController *alertupdate = [UIAlertController alertControllerWithTitle:@"提示" message:[common ipa_des] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"使用旧版" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[common app_ios]]];
//        }];
//        [alertupdate addAction:action1];
//        [alertupdate addAction:action2];
//        [self presentViewController:alertupdate animated:YES completion:nil];
//
//    }else if(r == NSOrderedSame) {//可改为if(r == 0L)
        [MBProgressHUD showError:@"当前已是最新版本"];
        
//    }

}
- (void)clearCrash{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    MBCache = 0;
    [setTable reloadData];
    [MBProgressHUD showError:@"缓存已清除"];
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
