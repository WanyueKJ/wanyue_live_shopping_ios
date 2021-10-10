//
//  RoomUserListViewController.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "RoomUserListViewController.h"
#import "adminCell.h"
#import "WYManagerModel.h"
#import "WYLiveUserManagerVC.h"

@interface RoomUserListViewController ()<UITableViewDelegate,UITableViewDataSource,adminCellDelegate>{
    UITableView *listTable;
    NSMutableArray *listArray;
    int page;
    
}
@property (nonatomic,strong) NSString *addAdmins;


@end

@implementation RoomUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = [NSString stringWithFormat:@"%@列表",_titleStr];
    self.nothingMsgL.text = [NSString stringWithFormat:@"没有被%@",_titleStr];
    listArray = [NSMutableArray array];
    page = 1;
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight-ShowDiff) style:0];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    [self.view addSubview:listTable];
    listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
    listTable.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestData];
    }];
    [self requestData];
}
- (void)requestData{
    NSString *method;
    if (_type == 0) {
       method = @"managerlist";
    }
    if (_type == 1) {
        method = @"usershutlist";
    }
    if (_type == 2) {
        method = @"userkicklist";
    }

    NSDictionary *subdic = @{@"p":@(page),
                             @"liveuid":self.liveuid
                            };

    [WYToolClass postNetworkWithUrl:method andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
        if (code == 200) {
            if (_type == 0) {
                NSDictionary *dicInfo = info;
                NSArray *array = dicInfo[@"list"];
                if (page == 1) {
                    [listArray removeAllObjects];
                }
                for (NSDictionary *dic in array) {
                    WYManagerModel *model = [[WYManagerModel alloc] initWithDic:dic];
                    [listArray addObject:model];
                }
                self.addAdmins = minstr([dicInfo valueForKey:@"count"]);//总的管理员
            }else{
                if (page == 1) {
                    [listArray removeAllObjects];
                }
                for (NSDictionary *dic in info) {
                    WYManagerModel *model = [[WYManagerModel alloc] initWithDic:dic];
                    [listArray addObject:model];
                }
                if (listArray.count == 0) {
                    listTable.hidden = YES;
                    self.nothingView.hidden = NO;
                }
            }
            [listTable reloadData];
            
        }
    } fail:^{
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];

    }];

}
-(void)delateAdminUser:(WYManagerModel *)model{
    NSString *msg;
    if (_type == 0) {
        msg = [NSString stringWithFormat:@"%@%@%@？",@"是否确定取消",model.name,@"的管理员身份"];
    }
    if (_type == 1) {
        msg = @"是否解除对该用户的禁言";
    }
    if (_type == 2) {
        msg = @"是否解除对该用户的踢出";
    }

    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self caozuo:model];
    }];
    [sureAction setValue:normalColors forKey:@"_titleTextColor"];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}
- (void)caozuo:(WYManagerModel *)model{
    NSString *method;
    if (_type == 0) {
        method = @"delmanager";
    }
    if (_type == 1) {
        method = @"liveunshut";
    }
    if (_type == 2) {
        method = @"liveunkick";
    }

    NSDictionary *setadmin = @{
                               @"liveuid":_liveuid,
                               @"touid":model.uid,
                               };
    [WYToolClass postNetworkWithUrl:method andParameter:setadmin success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [listArray removeObject:model];
            [listTable reloadData];
            if (_type != 0) {
                if (listArray.count == 0) {
                    listTable.hidden = YES;
                    self.nothingView.hidden = NO;
                }
            }
            [MBProgressHUD showError:msg];

        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_type == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 30)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"    %@（%ld/%@）",@"当前管理员",listArray.count,self.addAdmins];
        return label;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_type == 0) {
        return 30;
    }
    return 0.00001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    adminCell *cell = [adminCell cellWithTableView:tableView];
    cell.delegate = self;
    WYManagerModel *model = listArray[indexPath.row];
    cell.model = model;
    if (_type == 0) {
        [cell.rightBtn setTitle:@"" forState:0];
        [cell.rightBtn setImage:[UIImage imageNamed:@"profit_del"] forState:0];
    }else{
        if (_type == 1) {
            [cell.rightBtn setTitle:@"解除禁言" forState:0];
        }else{
            [cell.rightBtn setTitle:@"解除拉黑" forState:0];
        }
        [cell.rightBtn setImage:[UIImage new] forState:0];
        cell.layer.borderColor = RGB_COLOR(@"#FF5434", 1).CGColor;
        cell.layer.borderWidth = 0.5;
        cell.layer.cornerRadius = 20;
        [cell.rightBtn setTitleColor:RGB_COLOR(@"#FF5434", 1) forState:0];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹窗
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WYManagerModel *model = listArray[indexPath.row];
    
}
-(void)doGuanzhu:(NSString *)st{
    //关注
    NSString *url = [NSString stringWithFormat:@"User.setAttention&uid=%@&showid=%@&token=%@",[Config getOwnID],st,[Config getOwnToken]];
    [WYToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/*
- (void)delateAdminUser:(WYManagerModel *)model{
    NSString *msg;
    if (_type == 0) {
        msg = [NSString stringWithFormat:@"%@%@%@？",@"是否确定取消",model.name,YZMsg(@"的管理员身份")];
    }
    if (_type == 1) {
        msg = @"是否解除对该用户的禁言";
    }
    if (_type == 2) {
        msg = @"是否解除对该用户的踢出";
    }

    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self caozuo:model];
    }];
    [sureAction setValue:normalColors forKey:@"_titleTextColor"];

    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}
 */

/*
- (void)caozuo:(WYManagerModel *)model{
    NSString *method;
    if (_type == 0) {
        method = @"Livemanage.cancelManage";
    }
    if (_type == 1) {
        method = @"Livemanage.cancelShut";
    }
    if (_type == 2) {
        method = @"Livemanage.cancelKick";
    }

    NSDictionary *setadmin = @{
                               @"liveuid":_liveuid,
                               @"touid":model.uid,
                               };
    [YBToolClass postNetworkWithUrl:method andParameter:setadmin success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [listArray removeObject:model];
            [listTable reloadData];
            if (_type != 0) {
                if (listArray.count == 0) {
                    listTable.hidden = YES;
                    self.nothingView.hidden = NO;
                }
            }
            [MBProgressHUD showError:msg];

        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];

}
 */


@end
