//
//  registerAndForgetViewController.m
//  YBEducation
//
//  Created by IOS1 on 2020/2/27.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "registerAndForgetViewController.h"
#import "AppDelegate.h"
#import "WYTabBarController.h"

@interface registerAndForgetViewController (){
    UITextField *nameT;
    UITextField *codeT;
    UITextField *pwdT;
    UITextField *spreadT;

    UIButton *logBtn;
    UIButton *codeBtn;
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    NSString *codeKey;

}

@end

@implementation registerAndForgetViewController
- (void)ChangeBtnBackground{
    if (nameT.text.length == 11 && codeT.text.length == 6  && pwdT.text.length >= 6) {
        logBtn.alpha = 1;
        logBtn.userInteractionEnabled = YES;
    }else{
        logBtn.alpha = 0.5;
        logBtn.userInteractionEnabled = NO;
    }
    if (nameT.text.length == 11) {
        [codeBtn setTitleColor:normalColors forState:0];
        codeBtn.userInteractionEnabled = YES;
    }else{
        [codeBtn setTitleColor:RGB_COLOR(@"#c9c9c9", 1) forState:0];
        codeBtn.userInteractionEnabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineView.hidden = YES;
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

}
- (void)creatUI{
    UILabel *lable = [[UILabel alloc]init];
    lable.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:lable];
    NSArray *array = [NSArray array];
    if (_isregister) {
        lable.text = @"手机号注册";
        array = @[@"请输入您的手机号",@"请输入验证码",@"请设置密码",@"请输入推广人ID（选填）"];
    }else{
        lable.text = @"找回密码";
        array = @[@"请输入您的手机号",@"请输入验证码",@"请输入重置密码"];

    }
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(80);
        make.height.mas_equalTo(30);
    }];

    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,110 + i * 70, _window_width, 70)];
        [self.view addSubview:view];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(25, 30, _window_width-50, 40)];
        text.placeholder = array[i];
        text.font = SYS_Font(16);
        [view addSubview:text];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(text.left, 69, text.width, 1) andColor:RGB_COLOR(@"#E8E8E8", 1) andView:view];
        if (i == 0) {
            text.keyboardType = UIKeyboardTypeNumberPad;
            nameT = text;
        }else if (i == 1) {
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.width = (_window_width-50)/2;
            codeT = text;
            codeBtn = [UIButton buttonWithType:0];
            [codeBtn setTitle:@"获取验证码" forState:0];
            [codeBtn setTitleColor:RGB_COLOR(@"#c9c9c9", 1) forState:0];
            codeBtn.titleLabel.font = SYS_Font(16);
            [codeBtn addTarget:self action:@selector(requestCodeKey) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:codeBtn];
            [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-25);
                make.bottom.height.equalTo(text);
            }];
        }else if(i == 2){
            text.keyboardType = UIKeyboardTypeDefault;
            text.secureTextEntry = YES;
            pwdT = text;
        }else{
            text.keyboardType = UIKeyboardTypeNumberPad;
            spreadT = text;
        }
    }
    logBtn = [UIButton buttonWithType:0];
    if (_isregister) {
        [logBtn setTitle:@"注册" forState:0];
    }else{
        [logBtn setTitle:@"登录" forState:0];
    }
    [logBtn setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:0];
    [logBtn addTarget:self action:@selector(doCrontro) forControlEvents:UIControlEventTouchUpInside];
    logBtn.frame = CGRectMake(25, 110 + 70*array.count + 30, _window_width-50, 45);
    logBtn.layer.cornerRadius = 22.5;
    logBtn.layer.masksToBounds = YES;
    logBtn.alpha = 0.5;
    logBtn.userInteractionEnabled = NO;
    [self.view addSubview:logBtn];

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
    codeBtn.userInteractionEnabled = NO;
    [WYToolClass postNetworkWithUrl:@"register/verify" andParameter:@{@"phone":nameT.text,@"type":@"register",@"key":codeKey} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {

        if (code == 200) {
            if (messsageTimer == nil) {
                messageIssssss = 60;
                messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            }
            [MBProgressHUD showError:msg];
            [codeT becomeFirstResponder];
        }
    } fail:^{
        codeBtn.userInteractionEnabled = YES;
    }];

//    codeBtn.userInteractionEnabled = NO;
//    NSString *sign = [WYToolClass sortString:@{@"account":nameT.text}];
//    [WYToolClass postNetworkWithUrl:@"Login.GetCode" andParameter:@{@"account":nameT.text,@"sign":sign,@"type":_isregister?@"1":@"2"} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
//        [MBProgressHUD showError:msg];
//
//        if (code == 0) {
//            if (messsageTimer == nil) {
//                messageIssssss = 60;
//                messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
//            }
//            [codeT becomeFirstResponder];
//        }else{
//            if (code == 1002) {
//                [codeT becomeFirstResponder];
//            }
//
//            codeBtn.userInteractionEnabled = YES;
//
//        }
//    } fail:^{
//        codeBtn.userInteractionEnabled = YES;
//    }];

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
- (void)doCrontro{
    
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@""];
    NSString *pushid;
//    if ([JPUSHService registrationID]) {
//        pushid = [JPUSHService registrationID];
//    }else{
        pushid = @"";
//    }
    NSString *spreadID = @"";
    if (spreadT.text != nil && spreadT.text != NULL && spreadT.text.length > 0) {
        spreadID = spreadT.text;
    }
    NSDictionary *Login = @{
                            @"account":nameT.text,
                            @"password":pwdT.text,
                            @"captcha":codeT.text,
                            @"spread":spreadID,
                            @"source":@"2",
//                            @"pushid":pushid,
                            };
    
    [WYToolClass postNetworkWithUrl:_isregister ? @"register" : @"Login.Forget" andParameter:Login success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
//            if (_isregister) {
//                NSDictionary *infos = [info objectAtIndex:0];
//                LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
//                [Config saveProfile:userInfo];
//                [self loginSucess];
//            }else{
            if (self.block) {
                self.block(nameT.text, codeT.text);
            }
                [MBProgressHUD showError:msg];
                [self doReturn];
//            }
        }else {
            [MBProgressHUD showError:msg];
        }

    } fail:^{
        [MBProgressHUD hideHUD];
    }];

    
}

- (void)loginSucess{
    [self IMLogin];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    WYTabBarController *tabbarV = [[WYTabBarController alloc]init];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabbarV];
    app2.window.rootViewController = nav;
}
- (void)IMLogin{

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
