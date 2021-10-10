//
//  YBLoginViewController.m
//  YBEducation
//
//  Created by IOS1 on 2020/2/21.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "WYLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "WYTabBarController.h"
#import "logInCodePutView.h"
#import "loginPwdPutView.h"
#import "registerAndForgetViewController.h"
#import "SBJson.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "LivebroadViewController.h"
@interface WYLoginViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>{
    UIButton *codeBtn;
    UIButton *phoneBtn;
    UIButton *loginCodeBtn;
    UIButton *loginPhoneBtn;
    logInCodePutView *codeLogView;
    loginPwdPutView *pwdLogView;
    NSArray *platformsarray;

}

@end

@implementation WYLoginViewController
- (void)doReturn{
    if (_isquitLogin) {
        [self loginSucess];
    }else{
        [super doReturn];
    }
}

-(void)viewWillAppear:(BOOL)animated{
}
- (void)rightBtnClick{
    registerAndForgetViewController *vc =[[registerAndForgetViewController alloc]init];
    vc.isregister = YES;
    vc.block = ^(NSString * _Nonnull phone, NSString * _Nonnull code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            codeLogView.nameT.text = phone;
            codeLogView.pwdT.text = code;
            [codeLogView ChangeBtnBackground];
        });
    };
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)itemBtnClick:(UIButton *)sender{
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:24];

    if (sender == codeBtn) {
        codeBtn.selected = YES;
        phoneBtn.selected = NO;
        phoneBtn.titleLabel.font = SYS_Font(15);

        codeLogView.hidden = NO;
        pwdLogView.hidden = YES;
    }else{
        codeBtn.selected = NO;
        codeBtn.titleLabel.font = SYS_Font(15);
        phoneBtn.selected = YES;
        codeLogView.hidden = YES;
        pwdLogView.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.returnBtn setImage:[UIImage imageNamed:@"login_exit"] forState:0];
    [self.rightBtn setTitle:@"注册" forState:0];
    [self.rightBtn setTitleColor:color64 forState:0];
    self.returnBtn.hidden = YES;
    self.rightBtn.hidden = NO;
    self.lineView.hidden = YES;
    self.naviView.backgroundColor = [UIColor clearColor];
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    backImgView.image = [UIImage imageNamed:@"login_back"];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    backImgView.clipsToBounds = YES;
    [self.view addSubview:backImgView];
    [self.view sendSubviewToBack:backImgView];
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, IS_IPHONE_5 ? 48:(98+statusbarHeight), 60, 60)];
    logoImgView.image = [UIImage imageNamed:@"login_logo"];
    [self.view addSubview:logoImgView];
    UILabel *tLabel = [[UILabel alloc]init];
    tLabel.font = [UIFont boldSystemFontOfSize:20];
    tLabel.text = @"欢迎体验万岳直播带货系统";
    [self.view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImgView);
        make.top.equalTo(logoImgView.mas_bottom).offset(20);
    }];
    
    WeakSelf;
    codeLogView = [[logInCodePutView alloc]initWithFrame:CGRectMake(0, logoImgView.bottom + 65, _window_width, 200)];
    codeLogView.block = ^{
        [weakSelf loginSucess];
    };
    [self.view addSubview:codeLogView];

    
    UIButton *xieyiBtn = [UIButton buttonWithType:0];
    xieyiBtn.titleLabel.font = SYS_Font(10);
    [xieyiBtn setTitleColor:color64 forState:0];
    NSString *xieyiStr = @"登录即代表你已同意《用户协议》";
    
    NSRange range = NSMakeRange(9, 6);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:xieyiStr];
    [str addAttribute:NSForegroundColorAttributeName value:normalColors range:range];
    [xieyiBtn setAttributedTitle:str forState:0];
    [xieyiBtn addTarget:self action:@selector(doXieyi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiBtn];
    [xieyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(25+ShowDiff));
        make.height.mas_equalTo(20);
    }];
    
    
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            NSLog(@"wifi-------");
        }
    }];
    platformsarray = @[@"wx"];
    [self creatThirdLog];
}

- (void)creatThirdLog{
    if (platformsarray.count == 0) {
        return;
    }
//    [platformsarray addObject:@"apple"];
    CGFloat index;
    if (platformsarray.count==1) {
        index = 1.00/(platformsarray.count/2);
    }else{
        
    }
    CGFloat jianju = (_window_width - 30 - platformsarray.count * 60)/(platformsarray.count + 1);
    for (int i = 0 ; i < platformsarray.count; i ++) {
//        if ([platformsarray[i] isEqual:@"apple"]) {
//            if (@available(iOS 13.0, *)) {
//                ASAuthorizationAppleIDButton *authorizationButton = [[ASAuthorizationAppleIDButton alloc]init];
//                [authorizationButton addTarget:self action:@selector(appleClick) forControlEvents:(UIControlEventTouchUpInside)];
//                authorizationButton.layer.cornerRadius = 30;
//                authorizationButton.layer.masksToBounds = YES;
//                [self.view addSubview:authorizationButton];
//                [authorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.view).offset(-(75 + ShowDiff));
//                    make.height.width.mas_equalTo(60);
//                    make.left.equalTo(self.view).offset(15 + jianju + i * (60 + jianju));
//        //            if (platformsarray.count==1) {
//        //                make.centerX.equalTo(self.view);
//        //            }else{
//        //                make.centerX.equalTo(self.view).multipliedBy(0.75+i*0.5);
//        //            }
//                }];
//
//            } else {
//                // Fallback on earlier versions
//            }
//        }else{
                    UIButton *btn = [UIButton buttonWithType:0];
                    [btn setTitle:platformsarray[i] forState:0];
                    [btn setTitleColor:[UIColor clearColor] forState:0];
                    [btn addTarget:self action:@selector(thirdLogTypeClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.view).offset(-(75 + ShowDiff));
                        make.height.width.mas_equalTo(60);
                        make.left.equalTo(self.view).offset(15 + jianju + i * (60 + jianju));
            //            if (platformsarray.count==1) {
            //                make.centerX.equalTo(self.view);
            //            }else{
            //                make.centerX.equalTo(self.view).multipliedBy(0.75+i*0.5);
            //            }
                    }];
                    UIImageView *imageV = [[UIImageView alloc]init];
                    imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"login_%@",platformsarray[i]]];
                    [btn addSubview:imageV];
                    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.centerX.equalTo(btn);
                        make.width.height.mas_equalTo(40);
                        make.right.lessThanOrEqualTo(btn.mas_right);
                        make.left.greaterThanOrEqualTo(btn.mas_left);

                    }];
                    UILabel *label = [[UILabel alloc] init];
                    label.font = SYS_Font(10);
                    label.textColor = color64;
                    [btn addSubview:label];
                    if ([platformsarray[i] isEqual:@"wx"]) {
                        label.text = @"微信登录";
                    }else if ([platformsarray[i] isEqual:@"QQ"]) {
                        label.text = @"QQ登录";
                    }else if ([platformsarray[i] isEqual:@"apple"]) {
                        label.text = @"Apple登录";
                    }
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.lessThanOrEqualTo(btn.mas_right);
                        make.left.greaterThanOrEqualTo(btn.mas_left);
                        make.bottom.centerX.equalTo(btn);
                    }];

        }
//    }
}
- (void)thirdLogTypeClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqual:@"Facebook"]) {
        //Facebook
        [self login:@"4" platforms:SSDKPlatformTypeFacebook];

    }else if ([sender.titleLabel.text isEqual:@"Twitter"]) {
        //Twitter
        [self login:@"5" platforms:SSDKPlatformTypeTwitter];

    }else if ([sender.titleLabel.text isEqual:@"QQ"]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ result:^(NSError *error) {
            
        }];
        //QQ
        [self login:@"1" platforms:SSDKPlatformTypeQQ];
        
    }else if ([sender.titleLabel.text isEqual:@"wx"]) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat result:^(NSError *error) {
            
        }];
        //WX
        [self login:@"wx" platforms:SSDKPlatformTypeWechat];
        
    }else if ([sender.titleLabel.text isEqual:@"weibo"]) {
        //微博
        [self login:@"3" platforms:SSDKPlatformTypeSinaWeibo];
        
    }else if ([sender.titleLabel.text isEqual:@"apple"]) {
        //sign with Apple
        [self login:@"apple" platforms:SSDKPlatformTypeAppleAccount];
    }

}
-(void)login:(NSString *)types platforms:(SSDKPlatformType)platform{
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self RequestLogin:user LoginType:types];
             
         } else if (state == 2 || state == 3) {
             if ([types isEqual:@"apple"]) {
                 if ([UIDevice currentDevice].systemVersion.floatValue < 13) {
                     [MBProgressHUD showError:@"ios13以下系统暂不支持苹果登录"];
                 }
             }
         }
         
     }];
}
-(void)RequestLogin:(SSDKUser *)user LoginType:(NSString *)LoginType
{
    
    [MBProgressHUD showMessage:@""];
    NSString *icon = nil;
    if ([LoginType isEqualToString:@"1"]) {
        icon = [user.rawData valueForKey:@"figureurl_qq_2"];
    }
    else
    {
        icon = user.icon;
    }
//    NSString *unionID;//unionid
//    if ([LoginType isEqualToString:@"2"]){
//
//        unionID = [user.rawData valueForKey:@"unionid"];
//
//    }
//    else{
//        unionID = user.uid;
//    }
    NSString *unionID = [NSString string];
    if ([LoginType isEqualToString:@"1"]) {
        //************为了和PC互通，获取QQ的unionID,需要注意的是只有腾讯开放平台的数据打通之后这个接口才有权限访问，不然会报错********
        NSString *url1 = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",user.credential.token];
        url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:nil];
        NSRange rang1 = [str rangeOfString:@"{"];
        NSString *str2 = [str substringFromIndex:rang1.location];
        NSRange rang2 = [str2 rangeOfString:@")"];
        NSString *str3 = [str2 substringToIndex:rang2.location];
        NSString *str4 = [str3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSData *data = [str4 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [data JSONValue];
        unionID = [dic valueForKey:@"unionid"];
        //************为了和PC互通，获取QQ的unionID********
    }
    else if ([LoginType isEqualToString:@"wx"]){
        unionID = [user.rawData valueForKey:@"unionid"];
    }
    else{
        unionID = user.uid;
    }
    if (!icon || !unionID) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"未获取到授权，请重试"];
        return;
    }
    NSDictionary *signDic = @{
        @"openid":minstr([user.rawData valueForKey:@"openid"]),
        @"type":[NSString stringWithFormat:@"%@",[self encodeString:LoginType]],
    };
    NSString *signStr = [WYToolClass sortString:signDic];
    NSString *pushid;
//    if ([JPUSHService registrationID]) {
//        pushid = [JPUSHService registrationID];
//    }else{
        pushid = @"";
//    }

    NSDictionary *pDic = @{
                           @"openid":minstr([user.rawData valueForKey:@"openid"]),
                           @"unionid":[NSString stringWithFormat:@"%@",unionID],
                           @"type":[NSString stringWithFormat:@"%@",[self encodeString:LoginType]],
                           @"nickname":[NSString stringWithFormat:@"%@",[self encodeString:user.nickname]],
                           @"avatar":[NSString stringWithFormat:@"%@",[self encodeString:icon]],
                           @"gender":[NSString stringWithFormat:@"%ld",user.gender],
                           @"sign":signStr,
                           @"source":@"2",
                           @"pushid":pushid
                           };
    [WYToolClass postNetworkWithUrl:@"thirdlogin" andParameter:pDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];

        if (code == 200) {
            NSString *token = minstr([info valueForKey:@"token"]);
            [Config saveOwnToken:token];
            [self getUserInfo:token];
        }
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
- (void)getUserInfo:(NSString *)token{
    [WYToolClass getQCloudWithUrl:@"userinfo" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
            [Config saveProfile:userInfo];
            [self loginSucess];
        }
    } Fail:^{
        
    }];
}

-(NSString*)encodeString:(NSString*)unencodedString{
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (void)loginSucess{
    [self IMLogin];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    app2.window.rootViewController = nil;
    WYTabBarController *tabbarV = [[WYTabBarController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:tabbarV];
    app2.window.rootViewController = navi;
}
- (void)IMLogin{

}
- (void)doXieyi{
    WYWebViewController *web = [[WYWebViewController alloc]init];
    web.urls = [NSString stringWithFormat:@"%@/appapi/page/detail?id=2",h5url];
    [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
}
-(void)configUI{
//    if (@available(iOS 13.0, *)) {
//        self.authorizationButton = [[ASAuthorizationAppleIDButton alloc]init];
//        [self.authorizationButton addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
//        self.authorizationButton.center = self.view.center;
//        [self.view addSubview:self.authorizationButton];
//    } else {
//        // Fallback on earlier versions
//    }
}

-(void)appleClick API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    auth.delegate = self;
    auth.presentationContextProvider = self;
    [auth performRequests];
}
///代理主要用于展示在哪里
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.view.window;
}


-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
        if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
            ASAuthorizationAppleIDCredential *apple = authorization.credential;
            ///将返回得到的user 存储起来
            NSString *userIdentifier = apple.user;
            NSPersonNameComponents *fullName = apple.fullName;
            NSString *email = apple.email;
            //用于后台像苹果服务器验证身份信息
            NSData *identityToken = apple.identityToken;
            
            
            NSLog(@"%@%@%@%@",userIdentifier,fullName,email,identityToken);
        }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
            
            //// Sign in using an existing iCloud Keychain credential.
            ASPasswordCredential *pass = authorization.credential;
            NSString *username = pass.user;
            NSString *passw = pass.password;
            
        }
    
}

///回调失败
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"%@",error);
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
