//
//  jubaoVC.m
//  iphoneLive
//
//  Created by Boom on 2017/7/14.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "jubaoVC.h"
#import "jubaoCell.h"
@interface jubaoVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    NSDictionary *selctDic;
    NSInteger selctCount;
    UITextView *jubaoTextView;
    CGFloat textHeight;
    UILabel *placeLabel;
    UILabel *headerLabel;
    
    UIColor *bg_corlor;
    UIView *secionFootV;
}

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UITableView *table;
@end

@implementation jubaoVC

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.titleL.text = @"举报";
    bg_corlor = RGB_COLOR(@"#f4f5f6", 1);
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight-ShowDiff) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = bg_corlor;//RGB(240, 240, 240);
    selctCount = 100000;
    textHeight = 0.0;
    self.view.backgroundColor = bg_corlor;
    [self.view addSubview:_table];
    [self requetData];

}
- (void)requetData{
    WeakSelf;
    [WYToolClass getQCloudWithUrl:@"livereportcat" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            weakSelf.dataArr = [info mutableCopy];
            [weakSelf.table reloadData];
        }
    } Fail:^{
        
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!headerLabel) {
        headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        headerLabel.text = @"   选择举报的理由";
        headerLabel.textColor = RGB_COLOR(@"#959697", 1);
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    }
    return headerLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!secionFootV) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 80+110)];
        view.backgroundColor = bg_corlor;//_table.backgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _window_width-20, 30)];
        label.textColor = RGB_COLOR(@"#959697", 1);
        label.text = @"更多详细信息请在说明框中描述（选填）";
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        jubaoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.bottom, _window_width-20,90)];
        jubaoTextView.layer.masksToBounds = YES;
        jubaoTextView.layer.cornerRadius = 5.0;
        jubaoTextView.font = SYS_Font(13);
        jubaoTextView.textColor = RGB_COLOR(@"#333333", 1);//RGB_COLOR(@"#333333", 1);
        jubaoTextView.backgroundColor = [UIColor whiteColor];
        [view addSubview:jubaoTextView];
        placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 15)];
        placeLabel.font = SYS_Font(12);
        placeLabel.textColor = RGB_COLOR(@"#999999", 1);
    //    placeLabel.text = @"输入举报理由";
        [jubaoTextView addSubview:placeLabel];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(20, jubaoTextView.bottom+10, _window_width-40, 40);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20.0;
        [btn setBackgroundColor:normalColors];
        [btn setTitle:@"提交" forState:0];
        
        [btn addTarget:self action:@selector(dojubao) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        secionFootV = view;
    }
    return secionFootV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80+110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    jubaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jubaoCell"];
    if (!cell) {
        cell = [[jubaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jubaoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftLabel.text = [_dataArr[indexPath.row] valueForKey:@"name"];
    if (indexPath.row == selctCount) {
        cell.rightImage.image = [UIImage imageNamed:@"jubao_sel"];//ask_jubao2
    }else{
        cell.rightImage.image = [UIImage imageNamed:@"jubao_nor"];//ask_jubao1
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selctDic = [NSDictionary dictionaryWithDictionary:_dataArr[indexPath.row]];
    selctCount = indexPath.row;
    [_table reloadData];
}
- (void)dojubao{
    if (selctCount == 100000) {
        [MBProgressHUD showError:@"请选择举报理由"];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"%@%@",minstr([selctDic valueForKey:@"name"]),jubaoTextView.text];
    
    NSMutableDictionary *parameterDic = @{
                         @"touid":_liveuid,
                         @"content":content
                         }.mutableCopy;
    [WYToolClass postNetworkWithUrl:@"livereport" andParameter:parameterDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:msg];
            [self doReturn];
        }
    } fail:^{
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        placeLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        placeLabel.hidden = NO;
    }
    

    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
