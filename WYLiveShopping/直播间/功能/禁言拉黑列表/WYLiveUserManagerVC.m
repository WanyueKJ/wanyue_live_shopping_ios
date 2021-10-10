//
//  WYLiveUserManagerVC.m
//  WYLiveShopping
//
//  Created by apple on 2020/8/15.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYLiveUserManagerVC.h"

#import "RoomUserTypeCell.h"
#import "RoomUserListViewController.h"
@interface WYLiveUserManagerVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *leftTable;
    NSArray *listArray;
}


@end

@implementation WYLiveUserManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.titleL.text = _titleStr;
    listArray = @[@"禁言用户",@"拉黑用户"];
    leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight-ShowDiff) style:0];
    leftTable.delegate = self;
    leftTable.dataSource = self;
    leftTable.separatorStyle = 0;
    leftTable.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    [self.view addSubview:leftTable];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomUserTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomUserTypeCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RoomUserTypeCell" owner:nil options:nil] lastObject];
    }
    cell.titleL.text = listArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomUserListViewController *vc = [[RoomUserListViewController alloc]init];
    vc.type = indexPath.row+1;
    vc.titleStr = listArray[indexPath.row];
    vc.liveuid = _liveuid;
    [self.navigationController pushViewController:vc animated:YES];
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

