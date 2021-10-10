//
//  startLiveClassVC.m
//  yunbaolive
//
//  Created by Boom on 2018/9/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "startLiveClassVC.h"
#import "startLiveClassCell.h"
@interface startLiveClassVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *classTable;
    NSArray *classArray;
}

@end

@implementation startLiveClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    classArray = [common liveclass];
    self.titleL.text = @"直播分类";
    classTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight) style:UITableViewStylePlain];
    classTable.delegate = self;
    classTable.dataSource = self;
    classTable.separatorStyle = 0;
    [self.view addSubview:classTable];
    [self requestData];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"live/class" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        classArray = info;
        [classTable reloadData];
    } Fail:^{
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return classArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    startLiveClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"startLiveClassCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"startLiveClassCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = classArray[indexPath.row];
    if ([minstr([dic valueForKey:@"id"])isEqual:_classID]) {
        cell.selectImfView.hidden = NO;
    }else{
        cell.selectImfView.hidden = YES;
    }
    cell.nameLabel.text = minstr([dic valueForKey:@"name"]);
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, _window_width-40, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB_COLOR(@"#C6C6C6", 1);
    label.text = @"请选择直播分类";
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = classArray[indexPath.row];
    if (![minstr([dic valueForKey:@"id"])isEqual:_classID]) {
        self.block(dic);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
