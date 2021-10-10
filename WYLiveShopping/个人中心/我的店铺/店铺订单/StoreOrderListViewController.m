//
//  StoreOrderListViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "StoreOrderListViewController.h"
#import "OrderCell.h"
#import "OrderDetailsViewController.h"
#import "ReturnOrderCell.h"
#import "ReturnOrderDetailsViewController.h"

@interface StoreOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArray;
    int page;
    NSMutableArray *btnArray;
    UIView *moveLineV;
    UIButton *otherButton;
    UIView *otherBackView;
    NSMutableArray *otherBtnArray;

}
@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) UIImageView *nothingImgView;
@property (nonatomic,strong) NSString *orderType;

@end

@implementation StoreOrderListViewController
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom + 50, _window_width, _window_height-(64 +statusbarHeight + 50) -ShowDiff) style:1];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.separatorStyle = 0;
        _orderTableView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
        _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _orderTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
        [_orderTableView addSubview:self.nothingImgView];

    }
    return _orderTableView;
}
-(UIImageView *)nothingImgView{
    if (!_nothingImgView) {
        _nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, _window_width, _window_width*0.55)];
        _nothingImgView.image = [UIImage imageNamed:@"noOrder"];
        _nothingImgView.contentMode = UIViewContentModeScaleAspectFit;
        _nothingImgView.hidden = YES;
    }
    return _nothingImgView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_orderType isEqual:@"-3"]) {
        return dataArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_orderType isEqual:@"-3"]) {
        orderModel *oModel = dataArray[section];
        return oModel.goodsArray.count;
    }
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_orderType isEqual:@"-3"]) {
        ReturnOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReturnOrderCELL"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnOrderCell" owner:nil options:nil] lastObject];
        }
        orderModel *oModel = dataArray[indexPath.section];
        cell.model = oModel.goodsArray[indexPath.row];
        return cell;

    }else{
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCELL"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil] lastObject];
            cell.store_nameL.hidden = YES;
            cell.storeImgView.hidden = YES;
            cell.leftBtn.hidden = YES;
            [cell.rightBtn setTitle:@"查看详情" forState:0];
            cell.rightBtn.userInteractionEnabled = NO;
        }
        orderModel *model = dataArray[indexPath.row];
        cell.model = model;
        cell.timeL.text = model.add_time;
        cell.allPriceL.text = [NSString stringWithFormat:@"¥ %@",model.total_price];
        if ([_statusType isEqual:@"1"]) {
            cell.profitLabel.text = [NSString stringWithFormat:@"代销收益 ¥ %@",model.bring_price];
        }
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_orderType isEqual:@"-3"]) {
        return 80;
    }

    orderModel *model = dataArray[indexPath.row];
    return model.rowH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_orderType isEqual:@"-3"]) {
        return 43;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_orderType isEqual:@"-3"]) {

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 43)];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = NO;
        orderModel *model = dataArray[section];
        UILabel *label = [[UILabel alloc]init];
        label.text = model.orderNums;
        label.font = SYS_Font(14);
        label.textColor = color32;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.centerY.equalTo(view);
        }];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 42, _window_width, 1) andColor:RGB_COLOR(@"#eeeeee", 1) andView:view];
        
        UIImageView *statusImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width-65, 8, 50, 50)];
        if ([model.refund_status isEqual:@"2"]) {
            statusImgV.image = [UIImage imageNamed:@"已退款"];
        }else{
            statusImgV.image = [UIImage imageNamed:@"退款中"];
        }
        [view addSubview:statusImgV];

        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_orderType isEqual:@"-3"]) {

        return 48;
    }
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_orderType isEqual:@"-3"]) {

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 43)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *totalLabel = [[UILabel alloc]init];
        totalLabel.font = SYS_Font(14);
        totalLabel.textColor = color32;
        [view addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-15);
            make.centerY.equalTo(view).offset(-2.5);
        }];
        orderModel *model = dataArray[section];
        totalLabel.attributedText = [self getAttStrWithNums:model.total_num andTotalMoney:model.total_price];
        if ([_statusType isEqual:@"1"]) {
            UILabel *label = [[UILabel alloc]init];
            label.text = [NSString stringWithFormat:@"代销收益 ¥ %@",model.bring_price];
            label.font = SYS_Font(13);
            label.textColor = color32;
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.centerY.equalTo(view);
            }];
        }

        [[WYToolClass sharedInstance]lineViewWithFrame:CGRectMake(0, 43, _window_width, 5) andColor:colorf0 andView:view];
        return view;
    }
    return nil;
}
- (NSAttributedString *)getAttStrWithNums:(NSString *)nums andTotalMoney:(NSString *)money{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%@件商品 总金额：¥%@",nums,money]];
    [mustr setAttributes:@{NSForegroundColorAttributeName:normalColors,NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(mustr.length-money.length-1, money.length+1)];
    return mustr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showMessage:@""];
    orderModel *model = dataArray[indexPath.row];
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/detail/%@?status=%@",model.orderNums,_statusType] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            if ([_orderType isEqual:@"-3"]) {
                ReturnOrderDetailsViewController *vc = [[ReturnOrderDetailsViewController alloc]init];
                vc.orderMessage = info;
                [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
            }else{
                OrderDetailsViewController *vc = [[OrderDetailsViewController alloc]init];
                vc.orderMessage = info;
                vc.isCart = NO;
                vc.orderType = 1;
                [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
            }
        }
    } Fail:^{
        
    }];
    
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/list?type=%@&status=%@&page=%d",_orderType,_statusType,page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_orderTableView.mj_header endRefreshing];
        [_orderTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                orderModel *modle = [[orderModel alloc]initWithDic:dic];
                [dataArray addObject:modle];
            }
            if ([info count] < 20) {
                [_orderTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_orderTableView reloadData];
            if ([dataArray count] == 0) {
                _nothingImgView.hidden = NO;
            }else{
                _nothingImgView.hidden = YES;
            }

        }
    } Fail:^{
        [_orderTableView.mj_header endRefreshing];
        [_orderTableView.mj_footer endRefreshing];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_statusType isEqual:@"1"]) {
        self.titleL.text = @"代销订单";
    }else{
        self.titleL.text = @"店铺订单";
    }
    self.view.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    btnArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    otherBtnArray = [NSMutableArray array];
    page = 1;
    _orderType = @"0";
    [self creatHedaerView];
    [self.view addSubview:self.orderTableView];
    [self creatOtherView];
    [self requestCount];
    [self requestData];

}
- (void)creatHedaerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    NSArray *array = @[@"待付款 0",@"待发货 0",@"已发货 0",@"其他"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        [btn setTitleColor:color96 forState:0];
        [btn setTitleColor:color32 forState:UIControlStateSelected];
        btn.titleLabel.font = SYS_Font(14);
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(_window_width/4*i, 0, _window_width/4, 50);
        btn.tag = 1000 + i;
        if (i == 3) {

            [btn setImage:[UIImage imageNamed:@"order_down"] forState:0];
            CGRect rect = [array[i] boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : SYS_Font(14)} context:nil];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-2.5, 0, btn.imageView.image.size.width+2.5);
            //button图片的偏移量，这个偏移量是相对于标题的
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);

            otherButton = btn;
        }
        [view addSubview:btn];
        [btnArray addObject:btn];
        if (i == 0) {
            moveLineV = [[UIView alloc]initWithFrame:CGRectMake(btn.centerX-10, 44, 20, 2)];
            moveLineV.layer.cornerRadius = 1;
            moveLineV.backgroundColor = normalColors;
            [view addSubview:moveLineV];
            
        }
    }
    
}
- (void)creatOtherView{
    otherBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom+50, _window_width, _window_height-(self.naviView.bottom+50))];
    otherBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    otherBackView.hidden = YES;
    [self.view addSubview:otherBackView];
    NSArray *array = @[@"已收货 0",@"已完成 0",@"退款 0"];
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 50, _window_width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [otherBackView addSubview:view];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(15, 0, view.width-15, view.height);
        [btn setTitle:array[i] forState:0];
        [btn setTitleColor:color96 forState:0];
        [btn setTitleColor:color32 forState:UIControlStateSelected];
        btn.titleLabel.font = SYS_Font(14);
        [btn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000 + i;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [view addSubview:btn];
        
        [otherBtnArray addObject:btn];
    }

}
- (void)typeBtnClick:(UIButton *)sender{
    if (sender == otherButton) {
        otherBackView.hidden = !otherBackView.hidden;
    }else{
        if (sender.selected) {
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            moveLineV.centerX = sender.centerX;
        }];
        [otherButton setTitle:@"其他" forState:0];
        CGRect rect = [otherButton.titleLabel.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : SYS_Font(14)} context:nil];
        otherButton.titleEdgeInsets = UIEdgeInsetsMake(0, -otherButton.imageView.image.size.width-2.5, 0, otherButton.imageView.image.size.width+2.5);
        //button图片的偏移量，这个偏移量是相对于标题的
        otherButton.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);

        otherButton.selected = NO;
        otherBackView.hidden = YES;
        for (UIButton *btn in btnArray) {
            if (sender == btn) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
        for (UIButton *btn in otherBtnArray) {
            btn.selected = NO;
        }
        _orderType = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
        page = 1;
        [self requestData];
        
    }
}
- (void)otherBtnClick:(UIButton *)sender{
    if (sender.selected) {
        otherBackView.hidden = YES;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            moveLineV.centerX = otherButton.centerX;
        }];
        [otherButton setTitle:sender.titleLabel.text forState:0];
        CGRect rect = [otherButton.titleLabel.text boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : SYS_Font(14)} context:nil];
        otherButton.titleEdgeInsets = UIEdgeInsetsMake(0, -otherButton.imageView.image.size.width-2.5, 0, otherButton.imageView.image.size.width+2.5);
        //button图片的偏移量，这个偏移量是相对于标题的
        otherButton.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width+2.5, 0, -rect.size.width-2.5);
        otherButton.selected = YES;
        otherBackView.hidden = YES;
        for (UIButton *btn in btnArray) {
            btn.selected = NO;
        }
        for (UIButton *btn in otherBtnArray) {
            if (sender == btn) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
        if (sender.tag == 2002) {
            _orderType = @"-3";
        }else{
            _orderType = [NSString stringWithFormat:@"%ld",sender.tag - 2000 + 3];
        }
        page = 1;
        [self requestData];

    }
}
- (void)requestCount{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"order/data?status=%@",_statusType] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            for (int i = 0; i < btnArray.count - 1; i ++) {
                UIButton *btn = btnArray[i];
                if (i == 0) {
                    [btn setTitle:[NSString stringWithFormat:@"待付款 %@",minstr([info valueForKey:@"unpaid_count"])] forState:0];
                }else if (i == 1){
                    [btn setTitle:[NSString stringWithFormat:@"待发货 %@",minstr([info valueForKey:@"unshipped_count"])] forState:0];
                }else{
                    [btn setTitle:[NSString stringWithFormat:@"已发货 %@",minstr([info valueForKey:@"received_count"])] forState:0];
                }
            }
            for (int i = 0; i < otherBtnArray.count - 1; i ++) {
                UIButton *btn = otherBtnArray[i];
                if (i == 0) {
                    [btn setTitle:[NSString stringWithFormat:@"已收货 %@",minstr([info valueForKey:@"evaluated_count"])] forState:0];
                }else if (i == 1){
                    [btn setTitle:[NSString stringWithFormat:@"已完成 %@",minstr([info valueForKey:@"complete_count"])] forState:0];
                }else{
                    [btn setTitle:[NSString stringWithFormat:@"退款 %@",minstr([info valueForKey:@"refund_count"])] forState:0];
                }
            }

        }
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
