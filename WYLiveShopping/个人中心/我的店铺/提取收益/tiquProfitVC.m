//
//  myProfitVC.m
//  yunbaolive
//
//  Created by Boom on 2018/9/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "tiquProfitVC.h"
#import "profitTypeVC.h"
@interface tiquProfitVC (){
    UILabel *allVotesLabel;
    UITextField *votesT;
    UILabel *typeLabel;
    UIButton *inputBtn;
    NSDictionary *typeDic;
    UIImageView *seletTypeImgView;
}

@end

@implementation tiquProfitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"提取收益";
    self.view.backgroundColor = colorf0;
    [self creatUI];
}
- (void)creatUI{
    //黄色背景图
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 64+statusbarHeight+7, _window_width-30, (_window_width-30) * 0.35)];
    backImgView.image = [UIImage imageNamed:@"profitBg"];
    [self.view addSubview:backImgView];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    label.text = @"可提取金额";
    [backImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImgView);
        make.centerY.equalTo(backImgView).multipliedBy(0.6);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = SYS_Font(15);
    label2.textColor = [UIColor whiteColor];
    label2.attributedText = [self setAttText:_moneyStr];
    [backImgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImgView);
        make.centerY.equalTo(backImgView).multipliedBy(1.32);
    }];
    allVotesLabel = label2;
    //输入提现金额的视图
    CGFloat wwww = [[WYToolClass sharedInstance] widthOfString:@"输入提取金额" andFont:SYS_Font(13) andHeight:15] + 5;
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(backImgView.left, backImgView.bottom+10, backImgView.width, 50)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 5.0;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.textColor = color64;
    leftLabel.font = SYS_Font(13);
    leftLabel.text = @"输入提取金额";
    [textView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView).offset(15);
        make.centerY.equalTo(textView);
        make.width.mas_equalTo(wwww);
    }];
    votesT = [[UITextField alloc]init];
    votesT.textColor = normalColors;
    votesT.font = [UIFont boldSystemFontOfSize:18];
    votesT.placeholder = @"0";
    votesT.keyboardType = UIKeyboardTypeNumberPad;
    [textView addSubview:votesT];
    [votesT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right).offset(20);
        make.centerY.equalTo(textView);
        make.height.equalTo(textView);
        make.right.equalTo(textView).offset(-15);
    }];

    //选择提现账户
    
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(backImgView.left, textView.bottom+10, backImgView.width, 50)];
    typeView.backgroundColor = [UIColor whiteColor];
    typeView.layer.cornerRadius = 5.0;
    typeView.layer.masksToBounds = YES;
    [self.view addSubview:typeView];
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(textView.width*0.05, 0, typeView.width*0.95-40, 50)];
    typeLabel.textColor = color64;
    typeLabel.font = SYS_Font(13);
    typeLabel.text = @"请选择提现账户";
    [typeView addSubview:typeLabel];
    seletTypeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(typeLabel.left, 15, 20, 20)];
    seletTypeImgView.hidden = YES;
    [typeView addSubview:seletTypeImgView];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(typeView.width-30, 18, 14, 14)];
    rightImgView.image = [UIImage imageNamed:@"profit_right"];
    rightImgView.userInteractionEnabled = YES;
    [typeView addSubview:rightImgView];

    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, typeView.width, typeView.height);
    [btn addTarget:self action:@selector(selectPayType) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:btn];
    
    inputBtn = [UIButton buttonWithType:0];
    inputBtn.frame = CGRectMake(15, typeView.bottom + 55, _window_width - 30, 40);
    [inputBtn setBackgroundColor:normalColors];
    [inputBtn setTitle:@"立即提现" forState:0];
    [inputBtn addTarget:self action:@selector(inputBtnClick) forControlEvents:UIControlEventTouchUpInside];
    inputBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    inputBtn.layer.cornerRadius = 20;
    inputBtn.layer.masksToBounds = YES;
    [self.view addSubview:inputBtn];
    

}
- (NSAttributedString *)setAttText:(NSString *)nums{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:nums];
    [muStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0, [nums rangeOfString:@"."].location)];
    return muStr;
}

//选择z提现方式
- (void)selectPayType{
    profitTypeVC *vc = [[profitTypeVC alloc]init];
    if (typeDic) {
        vc.selectID = minstr([typeDic valueForKey:@"id"]);
    }else{
        vc.selectID = @"未选择提现方式";
    }
    vc.block = ^(NSDictionary * _Nonnull dic) {
        typeDic = dic;
        seletTypeImgView.hidden = NO;
        typeLabel.x = seletTypeImgView.right + 5;
        int type = [minstr([dic valueForKey:@"type"]) intValue];
        switch (type) {
            case 1:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_alipay"];
                typeLabel.text = [NSString stringWithFormat:@"%@(%@)",minstr([dic valueForKey:@"account"]),minstr([dic valueForKey:@"name"])];
                break;
            case 2:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_wx"];
                typeLabel.text = [NSString stringWithFormat:@"%@",minstr([dic valueForKey:@"account"])];

                break;
            case 3:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_card"];
                typeLabel.text = [NSString stringWithFormat:@"%@(%@)",minstr([dic valueForKey:@"account"]),minstr([dic valueForKey:@"name"])];
                break;
                
            default:
                break;
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
}
//提交申请
- (void)inputBtnClick{
    if (!votesT.text || [votesT.text integerValue] <= 0) {
        [MBProgressHUD showError:@"请输入要提取的金额"];
        return;
    }
    if(!typeDic){
        [MBProgressHUD showError:@"请选择提现账号"];
        return;
    }
    NSDictionary *dic = @{@"accountid":minstr([typeDic valueForKey:@"id"]),@"money":votesT.text};
    NSString *url;
    if (_ptofitType == 0) {
        url = @"cashbring";
    }else if (_ptofitType == 1){
        url = @"cashshop";
    }else if (_ptofitType == 2){
        url = @"cashshop";
    }

    [WYToolClass postNetworkWithUrl:url andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:msg];
//            _moneyStr = [NSString stringWithFormat:@"%.2f",[_moneyStr floatValue] - [votesT.text floatValue]];
//            allVotesLabel.attributedText = [self setAttText:_moneyStr];
            [self doReturn];
        }
    } fail:^{
        
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
