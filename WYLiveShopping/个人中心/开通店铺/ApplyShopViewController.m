//
//  ApplyShopViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ApplyShopViewController.h"
#import "MineShopViewController.h"

@interface ApplyShopViewController ()<TZImagePickerControllerDelegate>{
    UIView *applyView;
    UIScrollView *backScrollView;
    UITextField *nameTextT;
    UITextField *phoneTextT;
    UITextField *cardTextT;
    NSInteger selectBtnTag;
    UIImage *positiveImage;
    UIImage *backImage;
    UIImage *handImage;
    UIImage *businessImage;
    UIImage *licenceImage;
    UIImage *otherImage;
    NSMutableDictionary *parametersDic;
    UIView *failView;
}

@end

@implementation ApplyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"开通店铺";
    [self requestData];
    
    
}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"shopstatus" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            int status = [minstr([info valueForKey:@"status"]) intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                  if (status == -2) {
                      [self creatApplyUI];
                  }else if (status == 0){
                      [self showSuccessView];
                  }else if (status == -1){
                      [self showFailView:minstr([info valueForKey:@"reason"])];
                  }else if (status == 1){
                      MineShopViewController *vc = [[MineShopViewController alloc]init];
                      [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
                  }
            });
        }else{
            [super doReturn];
        }
    } Fail:^{
        
    }];
}

- (void)creatApplyUI{
    applyView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight))];
    applyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:applyView];

    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height-(64+statusbarHeight+75+ShowDiff))];
    backScrollView.backgroundColor = colorf0;
    [applyView addSubview:backScrollView];
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(backScrollView);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"店主信息";
    label1.font = [UIFont boldSystemFontOfSize:15];
    label1.textColor = color32;
    [view1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1).offset(15);
        make.top.equalTo(view1);
        make.height.mas_equalTo(50);
    }];
    NSArray *array = @[@"姓名",@"手机号",@"身份证号"];
    for (int i = 0; i < array.count; i ++) {
        UITextField *textT = [[UITextField alloc]init];
        textT.font = SYS_Font(14);
        textT.placeholder = array[i];
        [view1 addSubview:textT];
        [textT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(i*51);
            make.left.equalTo(label1);
            make.right.equalTo(view1).offset(-15);
            make.height.mas_equalTo(50);
        }];
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGB_COLOR(@"#E6E6E6", 1);
        [view1 addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(textT);
            make.top.equalTo(textT.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        if (i == 0) {
            nameTextT = textT;
        }else if (i == 1){
            phoneTextT = textT;
        }else {
            cardTextT = textT;
        }
    }
    
    NSArray *array2 = @[@"身份证正面照",@"身份证背面照",@"手持身份证照"];
    
    CGFloat www = (IS_IPHONE_5 ? 90 : 100);
    CGFloat speace = (_window_width -30 -3*www)/2;
    for (int i = 0; i < array2.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setImage:[UIImage imageNamed:@"photo"] forState:0];
        [btn addTarget:self action:@selector(showImagePicker:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [view1 addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(173);
            make.left.equalTo(view1).offset(15+i*(www + speace));
            make.width.mas_equalTo(www);
            make.height.equalTo(btn.mas_width).multipliedBy(0.75);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = array2[i];
        label.textColor = color64;
        label.font = SYS_Font(12);
        [view1 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(10);
            make.centerX.equalTo(btn);
        }];
        if (i == array2.count - 1) {
            [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.width.equalTo(backScrollView);
                make.bottom.equalTo(label.mas_bottom).offset(20);
            }];
        }
    }
    
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(view1);
        make.top.equalTo(view1.mas_bottom).offset(5);
    }];
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"资质证明";
    label2.font = [UIFont boldSystemFontOfSize:15];
    label2.textColor = color32;
    [view2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2).offset(15);
        make.top.equalTo(view2);
        make.height.mas_equalTo(50);
    }];
    NSArray *array3 = @[@"营业执照",@"许可证",@"其他证件"];
    
    for (int i = 0; i < array3.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setImage:[UIImage imageNamed:@"photo"] forState:0];
        [btn addTarget:self action:@selector(showImagePicker:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1003 + i;
        [view2 addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset(5);
            make.left.equalTo(view2).offset(15+i*(www + speace));
            make.width.mas_equalTo(www);
            make.height.equalTo(btn.mas_width).multipliedBy(0.75);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = array3[i];
        label.textColor = color64;
        label.font = SYS_Font(12);
        [view2 addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(10);
            make.centerX.equalTo(btn);
        }];
        if (i == array3.count - 1) {
            [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.width.equalTo(view1);
                make.top.equalTo(view1.mas_bottom).offset(5);
                make.bottom.equalTo(label.mas_bottom).offset(20);
            }];
        }
    }
    [backScrollView layoutIfNeeded];
    backScrollView.contentSize = CGSizeMake(0, view2.bottom + 20);
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, applyView.height-75-ShowDiff, _window_width, 75 + ShowDiff)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [applyView addSubview:bottomView];
    UIButton *addBtn = [UIButton buttonWithType:0];
    addBtn.frame = CGRectMake(15, 17.5, _window_width - 30, 40);
    [addBtn setTitle:@"提交" forState:0];
    [addBtn setBackgroundColor:normalColors];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    addBtn.layer.cornerRadius = 20;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];

}
- (void)showImagePicker:(UIButton *)sender{
    [self.view endEditing:YES];
    selectBtnTag = sender.tag;
    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePC.allowCameraLocation = YES;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.showSelectBtn = NO;
    imagePC.allowCrop = YES;
    imagePC.allowPickingOriginalPhoto = NO;
    imagePC.scaleAspectFillCrop = YES;
    imagePC.photoWidth = 350;
    imagePC.photoPreviewMaxWidth = 300;
    imagePC.cropRect = CGRectMake(0, (_window_height-_window_width*0.75)/2, _window_width, _window_width*0.75);
    [self presentViewController:imagePC animated:YES completion:nil];

}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (photos.count > 0) {
        UIImage *image = [photos firstObject];
        UIButton *btn = (UIButton *)[backScrollView viewWithTag:selectBtnTag];
        [btn setImage:image forState:UIControlStateNormal];

        switch (selectBtnTag) {
            case 1000:
                positiveImage = image;
                break;
            case 1001:
                backImage = image;
                break;
            case 1002:
                handImage = image;
                break;
            case 1003:
                businessImage = image;
                break;
            case 1004:
                licenceImage = image;
                break;
            case 1005:
                otherImage = image;
                break;
            default:
                break;
        }
        

    }

}

- (void)addBtnClick:(UIButton *)sender{
    if (nameTextT.text.length == 0 || phoneTextT.text.length == 0 || cardTextT.text.length == 0 || !positiveImage || !backImage || !handImage) {
        [MBProgressHUD showError:@"请填写店主信息"];
        return;
    }
    if (!businessImage) {
        [MBProgressHUD showError:@"请上传营业执照"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    [self uploadImage];
}
- (void)uploadImage{
    NSMutableArray *imageArray = @[
        @{@"key":@"cer_f",@"image":positiveImage},
        @{@"key":@"cer_b",@"image":backImage},
        @{@"key":@"cer_h",@"image":handImage},
        @{@"key":@"business",@"image":businessImage}
    ].mutableCopy;
    if (licenceImage) [imageArray addObject:@{@"key":@"license",@"image":licenceImage}];
    if (otherImage) [imageArray addObject:@{@"key":@"other",@"image":otherImage}];
    parametersDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in imageArray) {
        NSString *keyStr = minstr([dic valueForKey:@"key"]);
        UIImage *image = [dic valueForKey:@"image"];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"%@upload/image",purl];
        [session POST:url parameters:nil headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.5) name:@"file" fileName:[WYToolClass getNameBaseCurrentTime:@"livethumb.png"] mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];

            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([code isEqual:@"200"]) {
                [parametersDic setObject:minstr([data valueForKey:@"url"]) forKey:keyStr];
                if (parametersDic.count == imageArray.count) {
                    NSLog(@"%@",parametersDic);
                    [self doApply];
                }
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }];
    }

}
- (void)doApply{
    [parametersDic setObject:minstr(nameTextT.text) forKey:@"realname"];
    [parametersDic setObject:minstr(phoneTextT.text) forKey:@"tel"];
    [parametersDic setObject:minstr(cardTextT.text) forKey:@"cer_no"];
    [WYToolClass postNetworkWithUrl:@"shopapply" andParameter:parametersDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [self showSuccessView];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

}
- (void)showSuccessView{
    if (applyView) {
        applyView.hidden = YES;
    }
    UIView *examineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight))];
    examineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:examineView];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width * 0.32, 35, _window_width*0.36, _window_width * 0.306)];
    imgV.image = [UIImage imageNamed:@"shop-tips"];
    [examineView addSubview:imgV];
    UILabel *label1 = [[UILabel alloc]init];
    label1.font = SYS_Font(16);
    label1.textColor = color32;
    label1.text = @"信息审核中...";
    [examineView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(examineView);
        make.top.equalTo(imgV.mas_bottom).offset(38);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = SYS_Font(13);
    label2.textColor = color64;
    label2.text = @"3个工作日内会有审核结果，请耐心等待";
    [examineView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(examineView);
        make.top.equalTo(label1.mas_bottom).offset(13);
    }];
}

- (void)showFailView:(NSString *)reason{
    failView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight))];
    failView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:failView];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width * 0.32, 35, _window_width*0.36, _window_width * 0.306)];
    imgV.image = [UIImage imageNamed:@"shop-tips"];
    [failView addSubview:imgV];
    UILabel *label1 = [[UILabel alloc]init];
    label1.font = SYS_Font(16);
    label1.textColor = normalColors;
    label1.text = @"身份信息审核未通过";
    [failView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(failView);
        make.top.equalTo(imgV.mas_bottom).offset(38);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = SYS_Font(13);
    label2.textColor = color64;
    label2.text = reason;
    [failView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(failView);
        make.top.equalTo(label1.mas_bottom).offset(13);
    }];
    UIButton *againBtn = [UIButton buttonWithType:0];
    [againBtn setTitle:@"重新申请" forState:0];
    [againBtn setBackgroundColor:normalColors];
    againBtn.titleLabel.font = SYS_Font(16);
    againBtn.layer.cornerRadius = 20;
    againBtn.layer.masksToBounds = YES;
    [againBtn addTarget:self action:@selector(aginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [failView addSubview:againBtn];
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(failView);
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.width.equalTo(failView).multipliedBy(0.55);
        make.height.mas_equalTo(40);
    }];

}
-(void)aginBtnClick{
    [failView removeFromSuperview];
    failView = nil;
    [self creatApplyUI];
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
