//
//  goodsShareView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/4.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "goodsShareView.h"

@implementation goodsShareView{
    NSDictionary *shareDic;
    UIView *whiteView;
    UIView *codeBackView;
    UIView *codeView;
    UIImageView *routineImgView;
}
- (instancetype)initWithFrame:(CGRect)frame andRoomMessage:(NSDictionary *)shareMsg{
    if (self = [super initWithFrame:frame]) {
        shareDic = shareMsg;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHide)];
        [self addGestureRecognizer:tap];

        [self creatUI];
    }
    return self;

}
- (void)doHide{
    if (codeBackView) {
        codeBackView.hidden = YES;
    }

    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)doNothing{
    
}
- (void)creatUI{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, 110+ShowDiff)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    whiteView.layer.mask = [[WYToolClass sharedInstance] setViewLeftTop:10 andRightTop:10 andView:whiteView];
    UITapGestureRecognizer *nothingTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doNothing)];
    [whiteView addGestureRecognizer:nothingTap1];
//    UILabel *titleL = [[UILabel alloc]init];
//    titleL.font = SYS_Font(13);
//    titleL.textColor = color32;
//    titleL.text = @"";
//    [whiteView addSubview:titleL];
//    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(whiteView).offset(13);
//        make.centerX.equalTo(whiteView);
//    }];
    NSArray *array = @[@"login_wx",@"生成海报"];
    NSArray *array2 = @[@"发送给朋友",@"生成海报"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array2[i] forState:0];
        [btn setImage:[UIImage imageNamed:array[i]] forState:0];
        [btn setTitleColor:color32 forState:0];
        btn.titleLabel.font = SYS_Font(10);
        btn.frame = CGRectMake(_window_width/2*(0.62 + i * 0.76)-35, 20, 140, 140);
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
        whiteView.y = _window_height-110-ShowDiff;
    }];
}
- (void)whiteViewButtonClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //分享到微信
        [self simplyShare:SSDKPlatformSubTypeWechatSession];

    }else{
        whiteView.y = _window_height;
        if (!codeBackView) {
            codeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
            [self addSubview:codeBackView];
            codeView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.10, 100, _window_width*0.8, _window_width*0.8+165)];
            codeView.backgroundColor = [UIColor whiteColor];
            [codeBackView addSubview:codeView];
            codeView.centerY = codeBackView.centerY-20;
            UIImageView *thumbImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, codeView.width, codeView.width)];
            [thumbImgView sd_setImageWithURL:[NSURL URLWithString:minstr([shareDic valueForKey:@"image"])]];
            [codeView addSubview:thumbImgView];
            routineImgView = [[UIImageView alloc]init];
            [codeView addSubview:routineImgView];
            [routineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(60);
                make.left.equalTo(codeView).offset(30);
                make.bottom.equalTo(codeView).offset(-15);
            }];
            UILabel *label = [[UILabel alloc]init];
            label.text = @"长按识别小程序  立即购买";
            label.font = SYS_Font(12);
            label.textColor = color64;
            [codeView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(routineImgView);
                make.left.equalTo(routineImgView.mas_right).offset(16);
            }];
            UIImageView *lineImgV = [[UIImageView alloc]init];
            lineImgV.image = [UIImage imageNamed:@"share_虚线"];
            lineImgV.contentMode = UIViewContentModeScaleAspectFill;
            [codeView addSubview:lineImgV];
            [lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.equalTo(codeView);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(routineImgView.mas_top).offset(-11);
            }];
            UILabel *nameL = [[UILabel alloc]init];
            nameL.font = SYS_Font(13);
            nameL.textColor = color32;
            nameL.numberOfLines = 2;
            nameL.attributedText = [self setAttText:minstr([shareDic valueForKey:@"store_name"])];
            [codeView addSubview:nameL];
            [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(codeView).offset(15);
                make.width.equalTo(codeView).offset(-30);
                make.top.equalTo(thumbImgView.mas_bottom).offset(8);
            }];
            
            UILabel *priceL = [[UILabel alloc]init];
            priceL.font = [UIFont boldSystemFontOfSize:15];
            priceL.textColor = color32;
            priceL.text = [NSString stringWithFormat:@"¥%@",minstr([shareDic valueForKey:@"price"])];
            priceL.textColor = normalColors;
            [codeView addSubview:priceL];
            [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameL);
                make.bottom.equalTo(lineImgV.mas_top).offset(-7);
            }];

            UIButton *closeBtn = [UIButton buttonWithType:0];
            [closeBtn addTarget:self action:@selector(doHide) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setImage:[UIImage imageNamed:@"share_关闭"] forState:0];
            closeBtn.frame = CGRectMake(codeView.right-11, codeView.top-11, 22, 22);
            [codeBackView addSubview:closeBtn];
            
            UIButton *saveBtn = [UIButton buttonWithType:0];
            saveBtn.frame = CGRectMake(codeView.left, codeView.bottom, codeView.width, 35);
            [saveBtn setTitle:@"保存到手机" forState:0];
            [saveBtn setBackgroundColor:normalColors];
            saveBtn.titleLabel.font = SYS_Font(14);
            [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
            [codeBackView addSubview:saveBtn];
            [self requestData];
        }
        codeBackView.hidden = NO;

    }
}
- (NSAttributedString *)setAttText:(NSString *)str{

    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [muStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, muStr.length)];
    return muStr;
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
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:minstr([shareDic valueForKey:@"store_name"]) description:[Config getOwnNicename] webpageUrl:[NSURL URLWithString:@"https://malls.sdwanyue.com"] path:[NSString stringWithFormat:@"/pages/goods_details/index?id=%@&spid=%@&liveuid=%@",minstr([shareDic valueForKey:@"id"]),[Config getOwnID],_liveUid] thumbImage:minstr([shareDic valueForKey:@"image"]) hdThumbImage:nil userName:WechatGH_Id withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
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



- (void)requestData{
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"product/code/%@?user_type=routine",minstr([shareDic valueForKey:@"id"])] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [routineImgView sd_setImageWithURL:[NSURL URLWithString:minstr([info valueForKey:@"code"])]];
        }
    } Fail:^{
        
    }];
}
- (void)saveImage{
    UIImage * shareImage = [self getImage:codeView];
    if (shareImage) {
        UIImageWriteToSavedPhotosAlbum(shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
