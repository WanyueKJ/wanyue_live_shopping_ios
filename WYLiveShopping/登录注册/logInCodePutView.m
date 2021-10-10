//
//  logInputView.m
//  YBEducation
//
//  Created by IOS1 on 2020/2/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "logInCodePutView.h"

@implementation logInCodePutView{
    UIButton *logBtn;
    UIButton *codeBtn;
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    NSString *codeKey;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        codeKey = @"";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
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
- (void)ChangeBtnBackground{
    if (_nameT.text.length == 11 && _pwdT.text.length == 6) {
        logBtn.alpha = 1;
        logBtn.userInteractionEnabled = YES;
    }else{
        logBtn.alpha = 0.5;
        logBtn.userInteractionEnabled = NO;
    }
    if (_nameT.text.length == 11) {
        [codeBtn setTitleColor:normalColors forState:0];
        codeBtn.userInteractionEnabled = YES;
    }else{
        [codeBtn setTitleColor:RGB_COLOR(@"#c9c9c9", 1) forState:0];
        codeBtn.userInteractionEnabled = NO;

    }
}
- (void)creatUI{
    NSArray *array = @[@"请输入您的手机号",@"请输入验证码"];
    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 60, self.width, 60)];
        [self addSubview:view];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(25, 20, self.width-50, 40)];
        text.placeholder = array[i];
        text.font = SYS_Font(16);
        text.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:text];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(text.left, 59, text.width, 1) andColor:RGB_COLOR(@"#E8E8E8", 1) andView:view];
        if (i == 0) {
            _nameT = text;
        }else{
            text.width = (self.width-50)/2;
            _pwdT = text;
            codeBtn = [UIButton buttonWithType:0];
            [codeBtn setTitle:@"获取验证码" forState:0];
            [codeBtn setTitleColor:RGB_COLOR(@"#c9c9c9", 1) forState:0];
            codeBtn.titleLabel.font = SYS_Font(16);
            [codeBtn addTarget:self action:@selector(requestCodeKey) forControlEvents:UIControlEventTouchUpInside];
            codeBtn.userInteractionEnabled = NO;
            [view addSubview:codeBtn];
            [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-25);
                make.bottom.height.equalTo(text);
            }];
        }
    }
    logBtn = [UIButton buttonWithType:0];
    [logBtn setTitle:@"立即登录" forState:0];
    [logBtn setBackgroundColor:normalColors];
    [logBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    logBtn.frame = CGRectMake(25, 160, _window_width-50, 40);
    logBtn.layer.cornerRadius = 20;
    logBtn.layer.masksToBounds = YES;
    logBtn.clipsToBounds = YES;
    logBtn.alpha = 0.5;
    logBtn.userInteractionEnabled = NO;
    [self addSubview:logBtn];

}
- (void)getCode{
    codeBtn.userInteractionEnabled = NO;
    [WYToolClass postNetworkWithUrl:@"register/verify" andParameter:@{@"phone":_nameT.text,@"type":@"login",@"key":codeKey} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {

        if (code == 200) {
            if (messsageTimer == nil) {
                messageIssssss = 60;
                messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            }
            [MBProgressHUD showError:msg];
            [_pwdT becomeFirstResponder];
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
                            @"phone":_nameT.text,
                            @"captcha":_pwdT.text,
                            @"source":@"2",
                            @"spread":@"0"
                            };
    
    [WYToolClass postNetworkWithUrl:@"login/mobile" andParameter:Login success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSString *token = minstr([info valueForKey:@"token"]);
            [Config saveOwnToken:token];
            [self getUserInfo:token];
        }

    } fail:^{
    }];

}
- (void)getUserInfo:(NSString *)token{
    [WYToolClass getQCloudWithUrl:@"userinfo" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
            [Config saveProfile:userInfo];
            if (self.block) {
                self.block();
            }
        }
    } Fail:^{
        
    }];
}
@end
