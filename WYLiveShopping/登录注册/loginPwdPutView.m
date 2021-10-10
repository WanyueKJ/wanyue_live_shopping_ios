//
//  loginPwdPutView.m
//  YBEducation
//
//  Created by IOS1 on 2020/2/27.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "loginPwdPutView.h"
#import "registerAndForgetViewController.h"
@implementation loginPwdPutView{
    UITextField *nameT;
    UITextField *pwdT;
    UIButton *logBtn;

}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}
- (void)ChangeBtnBackground{
    if (nameT.text.length == 11 && pwdT.text.length > 5) {
        logBtn.alpha = 1;
        logBtn.userInteractionEnabled = YES;
    }else{
        logBtn.alpha = 0.5;
        logBtn.userInteractionEnabled = NO;
    }
}
- (void)creatUI{
    NSArray *array = @[@"请输入您的手机号",@"请输入密码"];
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 70, self.width, 70)];
        [self addSubview:view];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(25, 30, self.width-50, 40)];
        text.placeholder = array[i];
        text.font = SYS_Font(16);
        [view addSubview:text];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(text.left, 69, text.width, 1) andColor:RGB_COLOR(@"#E8E8E8", 1) andView:view];
        if (i == 0) {
            nameT = text;
            text.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            text.secureTextEntry = YES;
            pwdT = text;
        }
    }
    logBtn = [UIButton buttonWithType:0];
    [logBtn setTitle:@"登录" forState:0];
    [logBtn setBackgroundImage:[UIImage imageNamed:@"buttonBack"] forState:0];
    [logBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    logBtn.frame = CGRectMake(25, 175, _window_width-50, 45);
    logBtn.layer.cornerRadius = 25;
    logBtn.layer.masksToBounds = YES;
    logBtn.alpha = 0.5;
    logBtn.userInteractionEnabled = NO;
    logBtn.clipsToBounds = YES;
    [self addSubview:logBtn];
    
    UIButton *forgotBtn = [UIButton buttonWithType:0];
    [forgotBtn setTitle:@"忘记密码" forState:0];
    [forgotBtn addTarget:self action:@selector(doForgot) forControlEvents:UIControlEventTouchUpInside];
    forgotBtn.frame = CGRectMake(logBtn.right-70, logBtn.bottom, 70, 30);
    [forgotBtn setTitleColor:RGB_COLOR(@"#c9c9c9", 1) forState:0];
    forgotBtn.titleLabel.font = SYS_Font(13);
    [self addSubview:forgotBtn];


}
- (void)doLogin{
    [self endEditing:YES];
    [MBProgressHUD showMessage:@"正在登录"];
    NSString *pushid;
//    if ([JPUSHService registrationID]) {
//        pushid = [JPUSHService registrationID];
//    }else{
        pushid = @"";
//    }

    NSDictionary *Login = @{
                            @"username":nameT.text,
                            @"pass":pwdT.text,
                            @"source":@"2",
                            @"pushid":pushid
                            };
    
    [WYToolClass postNetworkWithUrl:@"Login.Login" andParameter:Login success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 0) {
            NSDictionary *infos = [info objectAtIndex:0];
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
            [Config saveProfile:userInfo];
            if (self.block) {
                self.block();
            }
        }else {
            [MBProgressHUD showError:msg];
        }

    } fail:^{
        [MBProgressHUD hideHUD];
    }];


}
- (void)doForgot{
    registerAndForgetViewController *vc =[[registerAndForgetViewController alloc]init];
    vc.isregister = NO;
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
