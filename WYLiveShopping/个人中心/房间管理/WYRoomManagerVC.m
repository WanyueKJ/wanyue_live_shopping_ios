//
//  WYRoomManagerVC.m
//  WYLiveShopping
//
//  Created by apple on 2020/8/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYRoomManagerVC.h"
#import "RoomUserTypeCell.h"
#import "RoomUserListViewController.h"
#import "WYLiveUserManagerVC.h"

@interface WYRoomManagerVC ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *lineView;
    UITableView *leftTable;
    UITableView *rightTable;
    NSArray *leftArray;
    NSMutableArray *rightArray;
    NSInteger p;
}

@end

@implementation WYRoomManagerVC
- (void)navi{
        NSArray *arr = @[@"我的直播间",@"我的房间"];
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(_window_width/2-90+i*90, 24+statusbarHeight, 90, 40);
            [btn setTitle:arr[i] forState:0];
            [btn setTitleColor:RGB_COLOR(@"#323232", 1) forState:UIControlStateSelected];
            [btn setTitleColor:RGB_COLOR(@"#969696", 1) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(topBtnclick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = SYS_Font(15);
            [self.naviView addSubview:btn];
            if (i== 0) {
                btn.selected = YES;
                leftBtn = btn;
                lineView = [[UIView alloc]initWithFrame:CGRectMake(btn.centerX-7.5, 60+statusbarHeight, 15, 4)];
                lineView.layer.cornerRadius = 2;
                lineView.layer.masksToBounds = YES;
                [self.naviView addSubview:lineView];
            }else{
                btn.selected = NO;
                rightBtn = btn;
            }
        }
}
- (void)topBtnclick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            lineView.centerX = sender.centerX;
        }];
        if (sender == leftBtn) {
            rightBtn.selected = NO;
            leftTable.hidden = NO;
            rightTable.hidden = YES;
        }else{
            leftBtn.selected = NO;
            leftTable.hidden = YES;
            rightTable.hidden = NO;
            if (rightArray.count == 0) {
                [self requestData];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navi];
    p = 1;
    leftArray = @[@"管理员",@"禁言用户",@"拉黑用户"];
    leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight-ShowDiff) style:0];
    leftTable.delegate = self;
    leftTable.dataSource = self;
    leftTable.separatorStyle = 0;
    leftTable.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    [self.view addSubview:leftTable];
    
    rightTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight-ShowDiff) style:0];
    rightTable.delegate = self;
    rightTable.dataSource = self;
    rightTable.separatorStyle = 0;
    rightTable.hidden = YES;
    rightTable.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    rightArray = [NSMutableArray array];
    [self.view addSubview:rightTable];
    [self requestData];
}
#pragma mark-TODO
- (void)requestData{
    [WYToolClass postNetworkWithUrl:@"managelist" andParameter:@{@"p":@(p)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSArray *infoA = info;
            if (p == 1) {
                [rightArray removeAllObjects];
            }
            [rightArray addObjectsFromArray:infoA];
            if (infoA.count < 20) {
                [rightTable.mj_footer endRefreshingWithNoMoreData];
            }else{
                rightTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    p += 1;
                    [self requestData];
                }];
            }
            [rightTable reloadData];
        }
    } fail:^{
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == leftTable) {
        return leftArray.count;
    }
    return rightArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomUserTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomUserTypeCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RoomUserTypeCell" owner:nil options:nil] lastObject];
    }
    if (tableView == leftTable) {
        cell.titleL.text = leftArray[indexPath.row];
    }else{
        
        cell.titleL.text = [NSString stringWithFormat:@"%@ 的直播间",minstr([rightArray[indexPath.row] valueForKey:@"nickname"])];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == leftTable) {
        RoomUserListViewController *vc = [[RoomUserListViewController alloc]init];
        vc.type = indexPath.row;
        vc.titleStr = leftArray[indexPath.row];
        vc.liveuid = [Config getOwnID];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *userinfo = rightArray[indexPath.row];
        WYLiveUserManagerVC *vc = [[WYLiveUserManagerVC alloc]init];
        vc.titleStr =[NSString stringWithFormat:@"%@ 的直播间",minstr([userinfo valueForKey:@"nickname"])];
        vc.liveuid = minstr([userinfo valueForKey:@"liveuid"]);
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
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
