//
//  shareView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/10.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "shareView.h"
#import "shareImageView.h"

@implementation shareView{
    NSDictionary *roomDic;
    UIView *whiteView;
    shareImageView *shareImgV;
    UIImage *shareImage;
}

- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)roomMessage{
    if (self = [super initWithFrame:frame]) {
        roomDic = roomMessage;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHide)];
        [self addGestureRecognizer:tap];

        [self creatUI];
    }
    return self;
}
- (void)doHide{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)doNothing{
    
}
- (void)creatUI{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, 140+ShowDiff)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    whiteView.layer.mask = [[WYToolClass sharedInstance] setViewLeftTop:10 andRightTop:10 andView:whiteView];
    UITapGestureRecognizer *nothingTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doNothing)];
    [whiteView addGestureRecognizer:nothingTap1];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.font = SYS_Font(13);
    titleL.textColor = color32;
    titleL.text = @"分享直播间";
    [whiteView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(13);
        make.centerX.equalTo(whiteView);
    }];
    NSArray *array = @[@"login_wx",@"share_code"];
    NSArray *array2 = @[@"分享到微信",@"二维码海报"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array2[i] forState:0];
        [btn setImage:[UIImage imageNamed:array[i]] forState:0];
        [btn setTitleColor:color32 forState:0];
        btn.titleLabel.font = SYS_Font(10);
        btn.frame = CGRectMake(_window_width/2*(0.62 + i * 0.76)-35, 50, 140, 140);
        [btn addTarget:self action:@selector(whiteViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [whiteView addSubview:btn];
        btn = [WYToolClass setUpImgDownText:btn space:10];
        btn.size = CGSizeMake(70, 70);
        
    }
    [self show];
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height-140-ShowDiff;
    }];
}
- (void)whiteViewButtonClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //分享到微信
        [self simplyShare:SSDKPlatformSubTypeWechatSession];

    }else{
        whiteView.y = _window_height;
        [self showShareImagView];
    }
}
- (void)simplyShare:(int)SSDKPlatformType
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    NSURL *ParamsURL;
    //拼装分享地址
    NSString *strFullUrl = @"";
    ParamsURL = [NSURL URLWithString:strFullUrl];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:minstr([roomDic valueForKey:@"title"]) description:minstr([roomDic valueForKey:@"nickname"]) webpageUrl:[NSURL URLWithString:h5url] path:[NSString stringWithFormat:@"pages/newpages/live/index?l=%@&pid=%@",minstr([roomDic valueForKey:@"uid"]),[Config getOwnID]] thumbImage:minstr([roomDic valueForKey:@"thumb"]) hdThumbImage:nil userName:WechatGH_Id withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    [shareParams SSDKSetupShareParamsByText:@""
//                                         images:[roomDic valueForKey:@"avatar"]
//                                            url:ParamsURL
//                                          title:@""
//                                           type:SSDKContentType];
            //进行分享
    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showError:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showError:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
}
- (void)showShareImagView{
    if (!shareImgV) {
        [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"/live/qr/%@",minstr([roomDic valueForKey:@"uid"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 200) {
                shareImgV = [[[NSBundle mainBundle] loadNibNamed:@"shareImageView" owner:nil options:nil] lastObject];
                shareImgV.frame = CGRectMake(0, 0, _window_width, _window_height);
                [self addSubview:shareImgV];
                [shareImgV layoutIfNeeded];
                [shareImgV.codeImgView sd_setImageWithURL:[NSURL URLWithString:minstr([info valueForKey:@"code"])]];
                [shareImgV.iconImgV sd_setImageWithURL:[NSURL URLWithString:minstr([roomDic valueForKey:@"avatar"])]];
                [shareImgV.thumbImgV sd_setImageWithURL:[NSURL URLWithString:minstr([roomDic valueForKey:@"thumb"])]];
                shareImgV.nameL.text = minstr([roomDic valueForKey:@"nickname"]);
                shareImgV.titleL.text = minstr([roomDic valueForKey:@"title"]);
                shareImgV.nameL.text = minstr([roomDic valueForKey:@"nickname"]);
                shareImgV.userNameL.text = [NSString stringWithFormat:@"%@\n邀请您一起看直播\n\n长按识别二维码，进入直播间",minstr([roomDic valueForKey:@"nickname"])];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHideShareImage)];
                [shareImgV addGestureRecognizer:tap];
                UITapGestureRecognizer *nothingTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doNothing)];
                [shareImgV.shareImgV addGestureRecognizer:nothingTap1];
                [shareImgV.wxShareBtn addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
                [shareImgV.wxLineBtn addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
                [shareImgV.downImgBtn addTarget:self action:@selector(saveImageTothumb:) forControlEvents:UIControlEventTouchUpInside];

            }
        } Fail:^{
            
        }];
    }
    shareImgV.hidden = NO;

}
- (UIImage *)getImage:(UIView *)shareView

{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(shareView.frame.size.width,shareView.frame.size.height ), NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //      renderInContext呈现接受者及其子范围到指定的上下文
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    //     UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    
    return viewImage;
    
}

- (void)doHideShareImage{
    shareImgV.hidden = YES;
    [self doHide];
}
- (void)shareImage:(UIButton *)sender{
    if (!shareImage) {
        shareImage = [self getImage:shareImgV.shareImgV];
    }

            //进行分享
    int SSDKPlatformType;
    if (sender == shareImgV.wxShareBtn) {
        SSDKPlatformType = SSDKPlatformSubTypeWechatSession;
    }else{
        SSDKPlatformType = SSDKPlatformSubTypeWechatTimeline;
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
    images:shareImage
       url:nil
     title:nil
      type:SSDKContentTypeImage];

    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showError:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showError:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];

}
- (void)saveImageTothumb:(UIButton *)sender{

    if (!shareImage) {
        shareImage = [self getImage:shareImgV.shareImgV];
    }
    UIImageWriteToSavedPhotosAlbum(shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{

    if (error == NULL) {
        [MBProgressHUD showError:@"保存成功！"];

    }else

    {
        [MBProgressHUD showError:@"保存失败"];

    }

    // NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);

}


@end
