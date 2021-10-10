//
//  AddressListViewController.m
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "AddressListViewController.h"
#import "addressCell.h"
#import "addAddressVC.h"

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource,addressCellDeleagte>
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *nothingImgView;


@end

@implementation AddressListViewController
-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight+ShowDiff+60)) style:0];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = 0;
        _listTableView.backgroundColor = colorf0;
        _listTableView.estimatedRowHeight = 140;
        _listTableView.estimatedSectionFooterHeight = 0;
        _listTableView.estimatedSectionHeaderHeight = 0;
        [_listTableView addSubview:self.nothingImgView];

    }
    return _listTableView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.55)];
        _nothingImgView.image = [UIImage imageNamed:@"noAddress"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-60-ShowDiff, _window_width, 60+ShowDiff)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *creatButton = [UIButton buttonWithType:0];
        [creatButton setTitle:@"  添加新地址" forState:0];
        [creatButton setBackgroundColor:normalColors];
        creatButton.titleLabel.font = SYS_Font(15);
        creatButton.layer.cornerRadius = 20;
        creatButton.layer.masksToBounds = YES;
        [creatButton setImage:[UIImage imageNamed:@"address添加"] forState:0];
        [creatButton addTarget:self action:@selector(doCreateAddr) forControlEvents:UIControlEventTouchUpInside];
        creatButton.frame = CGRectMake(15, 10, _window_width-30, 40);
        [_bottomView addSubview:creatButton];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"地址管理";
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.bottomView];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"address/list" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [_dataArray removeAllObjects];
            for (NSDictionary *dic in info) {
                addressModel *model = [[addressModel alloc]initWithDic:dic];
                [_dataArray addObject:model];
            }
            [_listTableView reloadData];
            if (_dataArray.count == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }

        }
    } Fail:^{
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"addressCell" owner:nil options:nil] lastObject];
    }
    cell.delegate = self;
    cell.model = _dataArray[indexPath.row];
    return cell;

}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 145;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.block) {
        addressModel *model = _dataArray[indexPath.row];
        NSDictionary *dic = @{
            @"id":model.aID,
            @"real_name":model.name,
            @"province":model.province,
            @"city":model.city,
            @"district":model.area,
            @"detail":model.detail,
            @"phone":model.mobile,
            @"is_default":model.isdef
        };
        self.block(dic);
        [super doReturn];
    }

}
- (void)delateAddress:(addressModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"address/del" andParameter:@{@"id":model.aID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
        if (code == 200) {
            if ([_curAddrID isEqual:model.aID]) {
                self.block(@{});
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestData];
            });
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
- (void)editAddress:(addressModel *)model{
    addAddressVC *vc = [[addAddressVC alloc]init];
    vc.model = model;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)setDefault:(addressModel *)model{
    [MBProgressHUD showMessage:@""];
    [WYToolClass postNetworkWithUrl:@"address/default/set" andParameter:@{@"id":model.aID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];

        if (code == 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestData];
            });
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

}


#pragma mark -- 创建新地址
- (void)doCreateAddr{
    addAddressVC *vc = [[addAddressVC alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
-(void)doReturn{
    if (_dataArray.count == 0) {
        if (self.block) {
            self.block(@{});
        }
    }
    [super doReturn];
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
