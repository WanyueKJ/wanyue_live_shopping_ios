//
//  ReplyListViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ReplyListViewController.h"
#import "ReplyCell.h"

@interface ReplyListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArray;
    int page;
    NSMutableArray *btnArray;
    UILabel *highLabel;
    WYStarView *starView;
    int type;
}
@property (nonatomic,strong) UITableView *replyTableView;

@end

@implementation ReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"商品评分";
    dataArray = [NSMutableArray array];
    btnArray = [NSMutableArray array];
    page = 1;
    type = 0;
    [self addHeaderView];
    [self.view addSubview:self.replyTableView];
    [self getReplyNums];
    [self requestData];
}
- (void)addHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, 90)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 33, 47)];
    label.text = @"评分";
    label.font = SYS_Font(15);
    label.textColor = normalColors;
    [headerView addSubview:label];
    starView = [[WYStarView alloc]initWithFrame:CGRectMake(label.right+5, label.centerY-7.5, 80, 16) starCount:5 starStyle:IncompleteStar isAllowScroe:NO];
    [headerView addSubview:starView];
    UILabel *highTipsLabel = [[UILabel alloc]init];
    highTipsLabel.font = SYS_Font(15);
    highTipsLabel.textColor = color64;
    highTipsLabel.text = @"好评率";
    [headerView addSubview:highTipsLabel];
    [highTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-15);
        make.centerY.equalTo(label);
    }];

    highLabel = [[UILabel alloc]init];
    highLabel.font = SYS_Font(15);
    highLabel.textColor = normalColors;
    highLabel.text = @"";
    [headerView addSubview:highLabel];
    [highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(highTipsLabel.mas_left).offset(-1);
        make.centerY.equalTo(label);
    }];
    NSArray *array = @[@"全部(0)",@"好评(0)",@"中评(0)",@"差评(0)"];
    MASViewAttribute *masL = label.mas_left;
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",array[i]] forState:0];
        [btn setBackgroundImage:[WYToolClass getImgWithColor:colorCC] forState:0];
        [btn setBackgroundImage:[WYToolClass getImgWithColor:normalColors] forState:UIControlStateSelected];
        [btn setTitleColor:color32 forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = SYS_Font(12);
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(typeBtnChange:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(masL);
            }else{
                make.left.equalTo(masL).offset(10);
            }
            make.top.equalTo(label.mas_bottom);
            make.height.mas_equalTo(27);
        }];
        masL = btn.mas_right;
        [btnArray addObject:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
}
- (void)typeBtnChange:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in btnArray) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    type = (int)sender.tag - 1000;
    page = 1;
    [self requestData];
}
- (void)getReplyNums{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"reply/config/%@",_goodsID] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            highLabel.text = [NSString stringWithFormat:@"%@%%",minstr([info valueForKey:@"reply_chance"])];
            starView.currentScore = [minstr([info valueForKey:@"reply_star"]) floatValue];
            for (int i = 0; i < btnArray.count ; i ++) {
                UIButton *btn = btnArray[i];
                if (i == 0) {
                    [btn setTitle:[NSString stringWithFormat:@"  全部(%@)  ",minstr([info valueForKey:@"sum_count"])] forState:0];
                }else if (i == 1) {
                    [btn setTitle:[NSString stringWithFormat:@"  好评(%@)  ",minstr([info valueForKey:@"good_count"])] forState:0];
                }else if (i == 2) {
                    [btn setTitle:[NSString stringWithFormat:@"  中评(%@)  ",minstr([info valueForKey:@"in_count"])] forState:0];
                }else {
                    [btn setTitle:[NSString stringWithFormat:@"  差评(%@)  ",minstr([info valueForKey:@"poor_count"])] forState:0];
                }

            }
        }
    } Fail:^{
        
    }];
}

-(UITableView *)replyTableView{
    if (!_replyTableView) {
        _replyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom + 90, _window_width, _window_height-(self.naviView.bottom + 90)) style:0];
        _replyTableView.delegate = self;
        _replyTableView.dataSource = self;
        _replyTableView.separatorStyle = 0;
        _replyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self requestData];
        }];
        _replyTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            page ++;
            [self requestData];
        }];
    }
    return _replyTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil] lastObject];
    }
    replyModel *model = dataArray[indexPath.row];
    cell.model = model;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    replyModel *model = dataArray[indexPath.row];
    return model.rowH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"reply/list/%@?page=%d&type=%d",_goodsID,page,type] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_replyTableView.mj_header endRefreshing];
        [_replyTableView.mj_footer endRefreshing];

        if (code == 200) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in info) {
                replyModel *model = [[replyModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            [_replyTableView reloadData];
            if ([info count] < 20) {
                [_replyTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } Fail:^{
        [_replyTableView.mj_header endRefreshing];
        [_replyTableView.mj_footer endRefreshing];
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
