//
//  WYCarViewController.m
//  YBEducation
//
//  Created by IOS1 on 2020/5/6.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYCarViewController.h"
#import "cartGoodsCell.h"
#import "GoodsDetailsViewController.h"
#import "cartInvalidCell.h"
#import "carBottomView.h"
#import "recommendView.h"
#import "GoodsDetailsViewController.h"
#import "SubmitOrderViewController.h"

@interface WYCarViewController ()<UITableViewDelegate,UITableViewDataSource,cartGoodsCellDelegate>{
    UILabel *cartNumsLabel;
    UIButton *adminButton;
    NSMutableArray *invalidArray;
    UIView *invalidView;
}
@property (nonatomic,strong) UITableView *carTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *inbalidTableView;
@property (nonatomic,strong) carBottomView *carBottomV;

@property (nonatomic,strong) recommendView *recommendV;

@end

@implementation WYCarViewController
-(recommendView *)recommendV{
    if (!_recommendV) {
        _recommendV = [[recommendView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom + 55, _window_width, _window_height - (self.naviView.bottom + 55)) andNothingImage:[UIImage imageNamed:@"noCart"]];
    }
    return _recommendV;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.titleL.text = @"购物车";
    _dataArray = [NSMutableArray array];
    invalidArray = [NSMutableArray array];

    [self addHeaderView];
    [self requestCartNums];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCartNums) name:WYCarNumChange object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
}
- (void)addHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"商品数量";
    label.font = SYS_Font(12);
    label.textColor = color32;
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(18);
        make.centerY.equalTo(headerView.mas_top).offset(25);
    }];
    cartNumsLabel = [[UILabel alloc]init];
    cartNumsLabel.text = @"";
    cartNumsLabel.font = SYS_Font(12);
    cartNumsLabel.textColor = normalColors;
    [headerView addSubview:cartNumsLabel];
    [cartNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(3);
        make.centerY.equalTo(label);
    }];
    
    adminButton = [UIButton buttonWithType:0];
    
    adminButton.layer.cornerRadius = 3;
    adminButton.layer.masksToBounds = YES;
    adminButton.layer.borderColor = color96.CGColor;
    adminButton.layer.borderWidth = 1;
    [adminButton setTitle:@"管理" forState:0];
    [adminButton setTitle:@"取消" forState:UIControlStateSelected];
    [adminButton setTitleColor:color32 forState:0];
    adminButton.titleLabel.font = SYS_Font(10);
    [adminButton addTarget:self action:@selector(doAdminCartGoods) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:adminButton];
    [adminButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-15);
        make.centerY.equalTo(label);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 50, _window_width, 5) andColor:colorf0 andView:headerView];
}
- (void)requestCartNums{
    [WYToolClass getQCloudWithUrl:@"cart/count?numType=true" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            cartNumsLabel.text = minstr([info valueForKey:@"count"]);
            if (_carBottomV) {
                _carBottomV.numsL.text = [NSString stringWithFormat:@"全选(%@)",minstr([info valueForKey:@"count"])];
            }
        }
    } Fail:^{
        
    }];
}

-(UITableView *)carTableView{
    if (!_carTableView) {
        _carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom+55, _window_width, _window_height-(self.naviView.bottom+55+60+ShowDiff)) style:1];
        _carTableView.delegate = self;
        _carTableView.dataSource = self;
        _carTableView.separatorStyle = 0;
        _carTableView.backgroundColor = colorf0;
    }
    return _carTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _carTableView) {
        NSArray *array = [_dataArray[section] valueForKey:@"model"];
        return array.count;
    }
    return invalidArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _carTableView) {
        return _dataArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _carTableView) {
        cartGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartGoodsCELL"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cartGoodsCell" owner:nil options:nil] lastObject];
            cell.delegate = self;
        }
        NSArray *array = [_dataArray[indexPath.section] valueForKey:@"model"];
        cell.model = array[indexPath.row];
        return cell;
    }else{
        cartInvalidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartInvalidCELL"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cartInvalidCell" owner:nil options:nil] lastObject];
        }
        cell.model = invalidArray[indexPath.row];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _carTableView) {
        return 120;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _carTableView) {
        return 40;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _carTableView) {

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setImage:[UIImage imageNamed:@"jubao_nor"] forState:0];
        [btn setImage:[UIImage imageNamed:@"cart_sel"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = section + 1000;
        btn.selected = YES;
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.centerY.equalTo(view);
            make.width.height.mas_equalTo(25);
        }];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = [UIImage imageNamed:@"小店"];
        [view addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(16);
        }];
        NSDictionary *dic = _dataArray[section];
        UILabel *label = [[UILabel alloc]init];
        label.text = minstr([dic valueForKey:@"name"]);
        label.font = SYS_Font(14);
        label.textColor = color32;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.mas_right).offset(8);
            make.centerY.equalTo(view);
        }];
        for (cartModel *model in [dic valueForKey:@"model"]) {
            if (!model.isSelected) {
                btn.selected = NO;
            }
        }
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, 39, _window_width-30, 1) andColor:RGB_COLOR(@"#eeeeee", 1) andView:view];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _carTableView) {
        return 5;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _carTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 5)];
        view.backgroundColor = RGB_COLOR(@"#eeeeee", 1);
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _carTableView) {
        NSArray *array = [_dataArray[indexPath.section] valueForKey:@"model"];
        cartModel *model = array[indexPath.row];

        GoodsDetailsViewController *vc= [[GoodsDetailsViewController alloc]init];
        vc.goodsID = model.goods_id;
        vc.liveUid = @"";
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
    }
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"cart/list" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSArray *valid = [info valueForKey:@"valid"];
            NSArray *invalid = [info valueForKey:@"invalid"];
            if ([valid count] > 0 || [invalid count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_carTableView) {
                        _carTableView.hidden = NO;
                        _carBottomV.hidden = NO;
                    }else{
                        [self.view addSubview:self.carTableView];
                        [self.view addSubview:self.carBottomV];
                    }
                    if (_recommendV) {
                        _recommendV.hidden = YES;
                    }

                    [_dataArray removeAllObjects];
                    CGFloat allMoney = 0;
                    for (NSDictionary *dic in valid) {
                        NSMutableDictionary *mudic = [dic mutableCopy];
                        NSMutableArray *array = [NSMutableArray array];
                        NSArray *list = [dic valueForKey:@"list"];
                        for (NSDictionary *dicc in list) {
                            cartModel *model = [[cartModel alloc] initWithDic:dicc];
                            allMoney += [model.price floatValue] * [model.cart_num intValue];
                            [array addObject:model];
                        }
                        [mudic setObject:array forKey:@"model"];
                        [_dataArray addObject:mudic];
                    }
                    _carBottomV.moneyL.text = [NSString stringWithFormat:@"¥%.2f",allMoney];
                    if ([invalid isKindOfClass:[NSArray class]] && [invalid count] > 0) {
                        [invalidArray removeAllObjects];
                        if (invalidView) {
                            [invalidView removeFromSuperview];
                            invalidView = nil;
                        }
                        for (NSDictionary *dicc in invalid) {
                            cartModel *model = [[cartModel alloc] initWithDic:dicc];
                            [invalidArray addObject:model];
                        }
                        [self addTableBottomView];
                    }
                    [_carTableView reloadData];
                    [self reloadSelected];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view addSubview:self.recommendV];
                });
                if (_carTableView) {
                    _carTableView.hidden = YES;
                    _carBottomV.hidden = YES;
                }
                if (_recommendV) {
                    _recommendV.hidden = NO;
                }

            }
        }
    } Fail:^{
        
    }];
}
- (void)addTableBottomView{
    if (invalidView) {
        [invalidView removeFromSuperview];
        invalidView = nil;
    }
    invalidView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
    invalidView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setImage:[UIImage imageNamed:@"down_gray"] forState:0];
    [btn setImage:[UIImage imageNamed:@"up_gray"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@" 失效商品" forState:0];
    btn.titleLabel.font = SYS_Font(12);
    [btn setTitleColor:color32 forState:0];
    [invalidView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(invalidView).offset(15);
        make.centerY.equalTo(invalidView.mas_top).offset(20);
    }];
    UIButton *delbtn = [UIButton buttonWithType:0];
    [delbtn setImage:[UIImage imageNamed:@"profit_del"] forState:0];
    [delbtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [delbtn setTitle:@" 清空" forState:0];
    delbtn.titleLabel.font = SYS_Font(12);
    [delbtn setTitleColor:color96 forState:0];
    [invalidView addSubview:delbtn];
    [delbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(invalidView).offset(-15);
        make.centerY.equalTo(btn);
    }];
    _carTableView.tableFooterView = invalidView;
}
- (UITableView *)inbalidTableView{
    if (!_inbalidTableView) {
        _inbalidTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, _window_width, 100*invalidArray.count) style:0];
        _inbalidTableView.delegate = self;
        _inbalidTableView.dataSource = self;
        _inbalidTableView.separatorStyle = 0;
        _inbalidTableView.scrollEnabled = NO;
    }
    return _inbalidTableView;
}
- (void)bottomBtnClick:(UIButton *)sender{
    if (sender.selected) {
        [_inbalidTableView removeFromSuperview];
        invalidView.height = 40;
    }else{
        invalidView.height = 40+invalidArray.count * 100;
        [invalidView addSubview:self.inbalidTableView];
        [_inbalidTableView reloadData];
    }
    _carTableView.tableFooterView = invalidView;
    sender.selected = !sender.selected;
}
- (void)delBtnClick:(UIButton *)btn{
    NSString *ids = @"";
    for (int i = 0; i < invalidArray.count; i ++) {
        cartModel *model = invalidArray[i];
        if (i == 0) {
            ids = model.cart_id;
        }else{
            ids = [NSString stringWithFormat:@"%@,%@",ids,model.cart_id];
        }
    }
    [self delateCartGoodsForID:ids andIsValid:NO];
}

- (void)doAdminCartGoods{
    adminButton.selected = !adminButton.selected;
    _carBottomV.adminView.hidden = !adminButton.selected;
}
- (carBottomView *)carBottomV{
    if (!_carBottomV) {
        _carBottomV = [[[NSBundle mainBundle] loadNibNamed:@"carBottomView" owner:nil options:nil] lastObject];
        _carBottomV.numsL.text = [NSString stringWithFormat:@"全选(%@)",cartNumsLabel.text];

        _carBottomV.frame = CGRectMake(0, _carTableView.bottom, _window_width, 60+ShowDiff);
        WeakSelf;
        _carBottomV.block = ^(int type) {
            if (type == 0 || type == 1) {
                //选择
                [weakSelf bottomAllBtnCLick:type];
            }else if (type == 4){
                //收藏
                [weakSelf doCollectSelectedGoods];
            }else if (type == 2){
                //购买
                [weakSelf doBuy];
            }else if (type == 3){
                //删除
                [weakSelf bottomDelate];
            }
            
        };
    }
    return _carBottomV;;
}
- (void)bottomAllBtnCLick:(BOOL)isS{

    CGFloat allMoney = 0;
    
    for (NSDictionary *dic in _dataArray) {
        NSArray *list = [dic valueForKey:@"model"];
        for (cartModel *model in list) {
            model.isSelected = isS;
            if (model.isSelected) {
                allMoney += [model.price floatValue] * [model.cart_num intValue];
            }
        }
    }
    _carBottomV.moneyL.text = [NSString stringWithFormat:@"¥%.2f",allMoney];
    _carBottomV.allBtn.selected = isS;
    [_carTableView reloadData];
}
- (void)changeSelectedState:(BOOL)isSelected{
    if (!isSelected) {
        _carBottomV.allBtn.selected = NO;
    }
    [self reloadSelected];
}

- (void)headerBtnClick:(UIButton *)sender{
    NSArray *array = [_dataArray[sender.tag - 1000] valueForKey:@"model"];
    for (cartModel *model in array) {
        model.isSelected = !sender.selected;
    }
    [self reloadSelected];
}
- (void)reloadSelected{
    CGFloat allMoney = 0;
    BOOL isALL = YES;
    for (NSDictionary *dic in _dataArray) {
        NSArray *list = [dic valueForKey:@"model"];
        for (cartModel *model in list) {
            if (model.isSelected) {
                allMoney += [model.price floatValue] * [model.cart_num intValue];
            }else{
                isALL = NO;
            }
        }
    }
    _carBottomV.moneyL.text = [NSString stringWithFormat:@"¥%.2f",allMoney];
    _carBottomV.allBtn.selected = isALL;
    [_carTableView reloadData];

}
- (void)bottomDelate{
    NSString *ids = @"";
    for (NSDictionary *dic in _dataArray) {
        NSArray *list = [dic valueForKey:@"model"];
        for (cartModel *model in list) {
            if (model.isSelected) {
                if (ids.length == 0) {
                    ids = model.cart_id;
                }else{
                    ids = [NSString stringWithFormat:@"%@,%@",ids,model.cart_id];
                }
            }
        }
    }
    [self delateCartGoodsForID:ids andIsValid:YES];

}
///删除购物车商品
- (void)delateCartGoodsForID:(NSString *)ids andIsValid:(BOOL)isValid{
    [WYToolClass postNetworkWithUrl:@"cart/del" andParameter:@{@"ids":ids} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            if (isValid) {
                [self requestData];
                _carBottomV.allBtn.selected = YES;
            }else{
                [invalidArray removeAllObjects];
                [invalidView removeFromSuperview];
                invalidView = nil;
                _carTableView.tableFooterView = nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:WYCarNumChange object:nil];

        }
    } fail:^{
        
    }];
}

- (void)doCollectSelectedGoods{
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in _dataArray) {
        NSArray *list = [dic valueForKey:@"model"];
        for (cartModel *model in list) {
            if (model.isSelected) {
                [muArr addObject:model.goods_id];
            }
        }
    }
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muArr options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (muArr.count == 0) {
        [MBProgressHUD showError:@"请选择要收藏的商品"];
        return;
    }
    [WYToolClass postNetworkWithUrl:@"collect/all" andParameter:@{@"id":muArr,@"category":@"product"} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (void)doBuy{
    [MBProgressHUD showMessage:@""];
    NSString *ids = @"";
    for (NSDictionary *dic in _dataArray) {
        NSArray *list = [dic valueForKey:@"model"];
        for (cartModel *model in list) {
            if (model.isSelected) {
                if (ids.length == 0) {
                    ids = model.cart_id;
                }else{
                    ids = [NSString stringWithFormat:@"%@,%@",ids,model.cart_id];
                }
            }
        }
    }
    [WYToolClass postNetworkWithUrl:@"order/confirm" andParameter:@{@"cartId":ids} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            SubmitOrderViewController *vc = [[SubmitOrderViewController alloc]init];
            vc.orderMessage = [info mutableCopy];
            vc.liveUid = @"";
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
        }
    } fail:^{
        
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
