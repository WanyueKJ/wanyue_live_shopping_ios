//
//  mineProfitViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "mineProfitViewController.h"
#import "profitHistoryCell.h"
#import "tiquProfitVC.h"
#import "historyProfitViewController.h"

@interface mineProfitViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *dayLabel;///今日收益
    UILabel *allLabel;///总收益
    UILabel *receivedLabel;///已结算
    UILabel *settlementLabel;///结算中
    NSMutableArray *dataArray;
    int page;
    UILabel *profitLabel;
    NSDictionary *profitDic;
}
@property (nonatomic,strong) UITableView *profitTableView;

@end

@implementation mineProfitViewController
- (void)creatHeaderView{
    UIImageView *backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 64+statusbarHeight + 10, _window_width-30, (_window_width-30)*0.478)];
    backImgV.image = [UIImage imageNamed:@"收益背景"];
    [self.view addSubview:backImgV];
    NSArray *array = @[@"今日收益(元)",@"总收益(元)",@"已结算(元)",@"未结算(元)"];
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = SYS_Font(12);
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        label.text = array[i];
        [backImgV addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%2 == 0) {
                make.left.equalTo(backImgV).offset(25);
            }else{
                make.right.equalTo(backImgV).offset(-25);
            }
            if (i/2 == 0) {
                make.centerY.equalTo(backImgV).multipliedBy(0.39);
            }else{
                make.centerY.equalTo(backImgV).multipliedBy(1.3);
            }
        }];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.font = SYS_Font(12);
        label2.textColor = [UIColor whiteColor];
        label2.attributedText = [self setAttText:@"0.00"];
        [backImgV addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%2 == 0) {
                make.left.equalTo(label);
            }else{
                make.right.equalTo(label);
            }
            make.top.equalTo(label.mas_bottom).offset(10);
        }];
        if (i == 0) {
            dayLabel = label2;
        }else if (i == 1){
            allLabel = label2;
        }else if (i == 2){
            receivedLabel = label2;
        }
        else{
            settlementLabel = label2;
        }
    }
}
- (NSAttributedString *)setAttText:(NSString *)nums{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:nums];
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, [nums rangeOfString:@"."].location)];
    return muStr;
}
- (void)addBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-ShowDiff-60, _window_width, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    NSArray *array = @[@"立即提现",@"提现记录"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(_window_width-95-i*90, 15, 80, 30);
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn setTitle:array[i] forState:0];
        [btn addTarget:self action:@selector(bottomButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYS_Font(13);
        btn.tag = 1000 + i;
        [bottomView addSubview:btn];
        if (i == 1) {
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = normalColors.CGColor;
            [btn setTitleColor:normalColors forState:0];
        }else{
            [btn setBackgroundColor:normalColors];
        }
    }
    UILabel *label = [[UILabel alloc]init];
    label.font = SYS_Font(11);
    label.textColor = color64;
    label.text = @"可提现金额";
    [bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(15);
        make.centerY.equalTo(bottomView).multipliedBy(0.6);
    }];
    
    profitLabel = [[UILabel alloc]init];
    profitLabel.font = [UIFont boldSystemFontOfSize:16];
    profitLabel.textColor = color32;
    profitLabel.text = @"¥0.00";
    [bottomView addSubview:profitLabel];
    [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(15);
        make.centerY.equalTo(bottomView).multipliedBy(1.32);
    }];

}
- (void)bottomButtonCLick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //
        tiquProfitVC *vc = [[tiquProfitVC alloc]init];
        if (_ptofitType == 0) {
            vc.moneyStr = minstr([profitDic valueForKey:@"bring"]);
        }else if (_ptofitType == 1){
            vc.moneyStr = minstr([profitDic valueForKey:@"shop"]);
        }
        vc.ptofitType = _ptofitType;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }else{
        historyProfitViewController*vc = [[historyProfitViewController alloc]init];
        vc.ptofitType = _ptofitType;
        [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

    }
}
- (void)requestData{
    NSString *url;
    if (_ptofitType == 0) {
        url = @"bring";
    }else if (_ptofitType == 1){
        url = @"shopcash";
    }else if (_ptofitType == 2){
        url = @"commission";
    }
    [WYToolClass getQCloudWithUrl:url Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            profitDic = info;
            if (_ptofitType == 0) {
                [dayLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"bring_t"])]];
                [allLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"bring_total"])]];
                [receivedLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"bring_ok"])]];
                [settlementLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"bring_no"])]];
                [profitLabel setAttributedText:[self setAttText:[NSString stringWithFormat:@"¥ %@",minstr([info valueForKey:@"bring"])]]];
            }else if (_ptofitType == 1){
                [dayLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"shop_t"])]];
                [allLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"shop_total"])]];
                [receivedLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"shop_ok"])]];
                [settlementLabel setAttributedText:[self setAttText:minstr([info valueForKey:@"shop_no"])]];
                [profitLabel setAttributedText:[self setAttText:[NSString stringWithFormat:@"¥ %@",minstr([info valueForKey:@"shop"])]]];
            }
        }
    } Fail:^{
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_ptofitType == 0) {
        self.titleL.text = @"代销收益";
    }else if (_ptofitType == 1) {
        self.titleL.text = @"店铺收益";
    }
    dataArray = [NSMutableArray array];
    page = 1;
    [self creatHeaderView];
    [self.view addSubview:self.profitTableView];
    [self addBottomView];
    [self requestHistoryData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (UITableView *)profitTableView{
    if (!_profitTableView) {
        _profitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight+20 + (_window_width-30)*0.478, _window_width, _window_height-(64+statusbarHeight+((_window_width-30)*0.478+20)+ShowDiff+60)) style:0];
        _profitTableView.delegate = self;
        _profitTableView.dataSource = self;
        _profitTableView.separatorStyle = 0;
        _profitTableView.backgroundColor = [UIColor whiteColor];
        _profitTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestHistoryData];
        }];
        _profitTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestHistoryData];
        }];
    }
    return _profitTableView;
}
- (void)requestHistoryData{
    NSString *url;
    if (_ptofitType == 0) {
        url = @"bringsettle";
    }else if (_ptofitType == 1){
        url = @"shopsettle";
    }
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"%@?page=%d",url,page] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_profitTableView.mj_header endRefreshing];
        [_profitTableView.mj_footer endRefreshing];
        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:info];
            [_profitTableView reloadData];
        }
    } Fail:^{
        [_profitTableView.mj_header endRefreshing];
        [_profitTableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    profitHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profitHistoryCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"profitHistoryCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = dataArray[indexPath.row];
    cell.orderNumL.text =minstr([dic valueForKey:@"title"]);
    cell.timeL.text = minstr([dic valueForKey:@"settle_time"]);
    cell.moneyL.text = [NSString stringWithFormat:@"¥ %@",minstr([dic valueForKey:@"money"])];
    cell.statusL.text = minstr([dic valueForKey:@"status"]);
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 37)];
    view.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    UILabel *label = [[UILabel alloc]init];
    label.text = @"结算记录";
    label.font = SYS_Font(12);
    label.textColor = color32;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view).offset(1);
    }];
    return view;
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
