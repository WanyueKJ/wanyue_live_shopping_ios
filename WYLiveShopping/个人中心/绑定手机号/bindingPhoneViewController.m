//
//  bindingPhoneViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "bindingPhoneViewController.h"

@interface bindingPhoneViewController (){
    UITextField *phoneTextT;
    UITextField *codeTextT;
    UIButton *codeBtn;
    NSString *codeKey;
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    NSString *step;
}

@end

@implementation bindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.returnBtn setImage:[UIImage imageNamed:@"navi_backImg_white"] forState:0];
    self.lineView.hidden = YES;
    self.naviView.image = [UIImage imageNamed:@"button_back"];
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = @"绑定手机号";
    codeKey = @"";
    step = @"0";
    [self creatUI];
}
- (void)creatUI{
    NSArray *array = @[@"填写手机号",@"填写验证码"];
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom + 20 +i * 60, _window_width, 60)];
        [self.view addSubview:view];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(25, 20, _window_width-50, 40)];
        text.placeholder = array[i];
        text.font = SYS_Font(16);
        text.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:text];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(text.left, 59, text.width, 1) andColor:RGB_COLOR(@"#E8E8E8", 1) andView:view];
        if (i == 0) {
            phoneTextT = text;
        }else{
            text.width = (_window_width-50)/2;
            codeTextT = text;
            codeBtn = [UIButton buttonWithType:0];
            [codeBtn setTitle:@"获取验证码" forState:0];
            [codeBtn setTitleColor:normalColors forState:0];
            codeBtn.titleLabel.font = SYS_Font(16);
            [codeBtn addTarget:self action:@selector(requestCodeKey) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:codeBtn];
            [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-25);
                make.bottom.height.equalTo(text);
            }];
        }
    }
    UIButton *changeBtn = [UIButton buttonWithType:0];
    [changeBtn setTitle:@"确认绑定" forState:0];
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:0];
    [changeBtn addTarget:self action:@selector(doBinding) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.frame = CGRectMake(25, self.naviView.bottom + 20 + 160, _window_width-50, 40);
    changeBtn.layer.cornerRadius = 20;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.clipsToBounds = YES;
    [self.view addSubview:changeBtn];

}
- (void)requestCodeKey{
    [MBProgressHUD showMessage:@""];
    WeakSelf;
    [WYToolClass getQCloudWithUrl:@"verify_code" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            codeKey = minstr([info valueForKey:@"key"]);
            [weakSelf getCode];
        }
    } Fail:^{

    }];
}
- (void)getCode{
    //@"type":@"login",
    if (phoneTextT.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }

    codeBtn.userInteractionEnabled = NO;
    [WYToolClass postNetworkWithUrl:@"register/verify" andParameter:@{@"phone":phoneTextT.text,@"key":codeKey} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {

        if (code == 200) {
            [codeTextT becomeFirstResponder];
            if (messsageTimer == nil) {
                messageIssssss = 60;
                messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            }
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        codeBtn.userInteractionEnabled = YES;
    }];

}
//获取验证码倒计时
-(void)daojishi{
    messageIssssss-=1;
    [codeBtn setTitle:[NSString stringWithFormat:@"%ds",messageIssssss] forState:UIControlStateNormal];
    codeBtn.userInteractionEnabled = NO;
    
    if (messageIssssss<=0) {
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeBtn.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
}
- (void)doBinding{
    [self.view endEditing:YES];
    if (phoneTextT.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (codeTextT.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }

    [MBProgressHUD showMessage:@""];
    NSDictionary *dic = @{
        @"phone":phoneTextT.text,
        @"captcha":codeTextT.text,
        @"step":step
    };
    [WYToolClass postNetworkWithUrl:@"binding" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            if ([minstr([info valueForKey:@"is_bind"]) isEqual:@"1"]) {
                UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertContro addAction:cancleAction];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    step = @"1";
                    [self doBinding];
                }];
                [sureAction setValue:normalColors forKey:@"_titleTextColor"];
                [alertContro addAction:sureAction];
                [self presentViewController:alertContro animated:YES completion:nil];
            }else{
                [MBProgressHUD showError:msg];
                [self doReturn];
            }
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
