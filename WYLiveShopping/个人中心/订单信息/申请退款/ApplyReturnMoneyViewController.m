//
//  ApplyReturnMoneyViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ApplyReturnMoneyViewController.h"
#import "MyTextView.h"
#import "cartModel.h"
#import "evaluateWriteViewController.h"
@interface ApplyReturnMoneyViewController ()<TZImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    MyTextView *textT;
    NSMutableArray *picArray;
    NSMutableArray *picImgViewArray;

    UIScrollView *backScrollView;
    UIButton *picBtn;
    UILabel *liyouLabel;
    UIView *picView;
    NSArray *reasonArray;
    
    UIView *pickBackView;
    UIView *pickShowView;
    NSInteger selectIndex;

}

@end

@implementation ApplyReturnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"申请退款";
    picArray = [NSMutableArray array];
    picImgViewArray = [NSMutableArray array];
    [self creatUI];
    [self requestData];
}
- (void)creatUI{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height-self.naviView.bottom)];
    backScrollView.backgroundColor = RGB_COLOR(@"#fafafa", 1);
    [self.view addSubview:backScrollView];
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (NSDictionary *dic in [_orderMessage valueForKey:@"cartInfo"]) {
        cartModel *model = [[cartModel alloc]initWithDic:dic];
        [goodsArray addObject:model];
    }

    UIView *allGoodsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, goodsArray.count * 80)];
    allGoodsView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:allGoodsView];
    for (int i = 0; i < goodsArray.count; i++) {
        cartModel *model = goodsArray[i];
        UIView *goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, i * 80, _window_width, 80)];
        [allGoodsView addSubview:goodsView];
        UIImageView *thumbImgV = [[UIImageView alloc]init];
        thumbImgV.contentMode = UIViewContentModeScaleAspectFill;
        [thumbImgV sd_setImageWithURL:[NSURL URLWithString:model.image]];
        thumbImgV.layer.cornerRadius = 5;
        thumbImgV.layer.masksToBounds = YES;
        [goodsView addSubview:thumbImgV];
        [thumbImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(goodsView).offset(15);
            make.centerY.equalTo(goodsView);
            make.width.height.mas_equalTo(60);
        }];
        UILabel *pricelabel = [[UILabel alloc]init];
        pricelabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        pricelabel.font = SYS_Font(14);
        pricelabel.textColor = color96;
        [goodsView addSubview:pricelabel];
        [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(goodsView).offset(-15);
            make.top.equalTo(thumbImgV).offset(2);
        }];

        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.text = model.store_name;
        namelabel.font = SYS_Font(14);
        namelabel.textColor = color32;
        namelabel.numberOfLines = 2;
        [goodsView addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thumbImgV.mas_right).offset(8);
            make.top.equalTo(thumbImgV).offset(2);
            make.right.lessThanOrEqualTo(pricelabel.mas_left).offset(-10);
        }];
        UILabel *numsLabel = [[UILabel alloc]init];
        numsLabel.text = [NSString stringWithFormat:@"x%@",model.cart_num];
        numsLabel.font = SYS_Font(14);
        numsLabel.textColor = color96;
        [goodsView addSubview:numsLabel];
        [numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pricelabel);
            make.top.equalTo(pricelabel.mas_bottom).offset(8);
        }];

    }
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, allGoodsView.bottom, _window_width, 10) andColor:colorf0 andView:backScrollView];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, allGoodsView.bottom + 10, _window_width, 250)];
    contentView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:contentView];
    NSArray *array = @[@"退货件数",@"退款金额",@"退款原因",@"备注说明"];
    NSArray *array2 = @[minstr([_orderMessage valueForKey:@"total_num"]),[NSString stringWithFormat:@"¥%@",minstr([_orderMessage valueForKey:@"pay_price"])],@"退款原因"];

    for (int i = 0; i < array.count; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, i * 50, _window_width, 50)];
        if (i == 3) {
            view.height = 100;
        }
        [contentView addSubview:view];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, view.height-1, _window_width-30, 1) andColor:RGB_COLOR(@"#fafafa", 1) andView:view];
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.font = SYS_Font(15);
        label.textColor = color32;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.centerY.equalTo(view.mas_top).offset(24.5);
        }];
        if (i < 3) {
            UILabel *rLabel = [[UILabel alloc]init];
            rLabel.text = array2[i];
            rLabel.font = SYS_Font(15);
            rLabel.textColor = color32;
            [view addSubview:rLabel];
            [rLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-15);
                make.centerY.equalTo(label);
            }];
            if ( i == 2) {
                UIImageView *rightImgV2 = [[UIImageView alloc]init];
                rightImgV2.image = [UIImage imageNamed:@"detalies右"];
                [view addSubview:rightImgV2];
                [rightImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-10);
                    make.centerY.equalTo(label);
                    make.width.height.mas_equalTo(15);
                }];
                [rLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(rightImgV2.mas_left).offset(-3);
                    make.centerY.equalTo(label);
                }];
                liyouLabel = rLabel;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedReason)];
                [view addGestureRecognizer:tap];
            }
        }else{
            textT = [[MyTextView alloc]initWithFrame:CGRectMake(10, 45, _window_width-20, 50)];
            textT.placeholder = @"请填写备注信息，100字以内";
            textT.placeholderColor = RGB_COLOR(@"#C8C8C8", 1);
            textT.font = SYS_Font(14);
            textT.textColor = color32;
//            textT.textAlignment = NSTextAlignmentRight;
            textT.backgroundColor = [UIColor clearColor];
            [view addSubview:textT];

        }
    }
    
    picView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.bottom, _window_width, 156)];
    picView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:picView];
    UILabel *picLLabel = [[UILabel alloc]init];
    picLLabel.text = @"上传凭证";
    picLLabel.font = SYS_Font(15);
    picLLabel.textColor = color32;
    [picView addSubview:picLLabel];
    [picLLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(picView).offset(15);
        make.centerY.equalTo(picView.mas_top).offset(24.5);
    }];
    UILabel *picRLabel = [[UILabel alloc]init];
    picRLabel.text = @"（ 最多可上传3张 ）";
    picRLabel.font = SYS_Font(15);
    picRLabel.textColor = color96;
    [picView addSubview:picRLabel];
    [picRLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(picView.mas_right).offset(-15);
        make.centerY.equalTo(picLLabel);
    }];

    
    
    CGFloat btnWidth = (picView.width - 30)/4;
    picBtn = [UIButton buttonWithType:0];
    picBtn.frame = CGRectMake(15, 73, btnWidth-10, btnWidth-10);
    [picBtn addTarget:self action:@selector(showImagePicker:) forControlEvents:UIControlEventTouchUpInside];
    [picBtn setImage:[UIImage imageNamed:@"上传图片"] forState:0];
    [picView addSubview:picBtn];

    UIButton *applyButton = [UIButton buttonWithType:0];
    [applyButton setTitle:@"申请退款" forState:0];
    [applyButton setBackgroundColor:normalColors];
    applyButton.titleLabel.font = SYS_Font(15);
    applyButton.layer.cornerRadius = 20;
    applyButton.layer.masksToBounds = YES;
    [applyButton addTarget:self action:@selector(doApply) forControlEvents:UIControlEventTouchUpInside];
    applyButton.frame = CGRectMake(15, picView.bottom + 10, _window_width-30, 40);
    [backScrollView addSubview:applyButton];
    backScrollView.contentSize = CGSizeMake(0, applyButton.bottom + ShowDiff+20);
}

- (void)showImagePicker:(UIButton *)sender{
    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:3-picArray.count delegate:self];
    imagePC.allowCameraLocation = YES;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
//    imagePC.showSelectBtn = NO;
//    imagePC.allowCrop = YES;
    imagePC.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePC animated:YES completion:nil];

}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (photos.count > 0) {
        [picArray addObjectsFromArray:photos];
        [self addNewPhotoView:photos];
        [self reloadPicView];
    }

}
- (void)addNewPhotoView:(NSArray<UIImage *> *)photos{
    CGFloat btnWidth = (picView.width - 30)/4;

    for (UIImage *image in photos) {
        WYPhotoView *view = [[WYPhotoView alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
        view.thumbImgView.image = image;
        [picView addSubview:view];
        [picImgViewArray addObject:view];
    }
    
}
- (void)reloadPicView{
    if (picImgViewArray.count == 3) {
        picBtn.hidden = YES;
    }else{
        picBtn.hidden = NO;
    }

    CGFloat btnWidth = (picView.width - 20)/4;
    if (picImgViewArray.count > 0) {
        for (int i = 0; i < picImgViewArray.count; i ++) {
            WYPhotoView *view = picImgViewArray[i];
            view.delateBtn.tag = 1000 + i;
            [view.delateBtn removeTarget:self action:@selector(doDelateImage:) forControlEvents:UIControlEventTouchUpInside];
            [view.delateBtn addTarget:self action:@selector(doDelateImage:) forControlEvents:UIControlEventTouchUpInside];
            view.frame = CGRectMake(15 + (i%4) * btnWidth, 68 + i/4*(btnWidth + 5), btnWidth, btnWidth);
            picBtn.frame =  CGRectMake(view.right + 5, 73, btnWidth-10, btnWidth-10);

        }
    }else{
        picBtn.frame = CGRectMake(15, 73, btnWidth-10, btnWidth-10);
    }

}
- (void)doDelateImage:(UIButton *)sender{
    WYPhotoView *view = picImgViewArray[sender.tag - 1000];
    [view removeFromSuperview];
    view = nil;
    [picImgViewArray removeObjectAtIndex:sender.tag - 1000];
    [picArray removeObjectAtIndex:sender.tag - 1000];
    [self reloadPicView];

}
- (void)requestData{
    [WYToolClass getQCloudWithUrl:@"order/refund/reason" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            reasonArray = info;
            if (reasonArray.count > 0) {
                liyouLabel.text = minstr([reasonArray firstObject]);
            }
        }
    } Fail:^{
        
    }];
}
- (void)selectedReason{
    [self.view endEditing:YES];
    if (reasonArray.count == 0) {
        [self requestData];
    }
    if (!pickBackView) {
        pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        pickBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.view addSubview:pickBackView];
        UIButton *hideBtn = [UIButton buttonWithType:0];
        hideBtn.frame = CGRectMake(0, 0, _window_width, _window_height*0.6);
        [hideBtn addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
        [pickBackView addSubview:hideBtn];

        pickShowView =  [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height*0.4)];
        pickShowView.backgroundColor = [UIColor whiteColor];
        [pickBackView addSubview:pickShowView];
       
        UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, _window_width, pickShowView.height-40)];
        pick.backgroundColor = [UIColor whiteColor];
        pick.delegate = self;
        pick.dataSource = self;
        [pickShowView addSubview:pick];
       
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        titleView.backgroundColor = [UIColor clearColor];
        [pickShowView addSubview:titleView];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 39, _window_width, 1) andColor:colorf0 andView:titleView];
        UIButton *cancleBtn = [UIButton buttonWithType:0];
        cancleBtn.frame = CGRectMake(00, 0, 80, 40);
        cancleBtn.tag = 100;
        cancleBtn.titleLabel.font = SYS_Font(15);
        [cancleBtn setTitle:@"取消" forState:0];
        [cancleBtn setTitleColor:color64 forState:0];
        [cancleBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:cancleBtn];
        UIButton *sureBtn = [UIButton buttonWithType:0];
        sureBtn.frame = CGRectMake(titleView.width-80, 0, 80, 40);
        sureBtn.tag = 101;
        sureBtn.titleLabel.font = SYS_Font(15);
        [sureBtn setTitle:@"确定" forState:0];
        [sureBtn setTitleColor:normalColors forState:0];
        [sureBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:sureBtn];
    }
    [self showPicker];
}
- (void)showPicker{
    pickBackView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        pickShowView.bottom = _window_height;
    }];
}
- (void)hidePicker{
    [UIView animateWithDuration:0.2 animations:^{
        pickShowView.y = _window_height;
    }completion:^(BOOL finished) {
        pickBackView.hidden = YES;
    }];
}

- (void)cancleOrSure:(UIButton *)button{
    if (button.tag == 100) {
        //        return;
    }else{
        liyouLabel.text = reasonArray[selectIndex];
    }
    [self hidePicker];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return reasonArray.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return reasonArray[row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component {
    selectIndex = row;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _window_width, 40)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = reasonArray[row];
    myView.textColor = color32;
    myView.font = [UIFont systemFontOfSize:15];
    myView.backgroundColor = [UIColor clearColor];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 39, _window_width, 1) andColor:colorf0 andView:myView];
    return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

- (void)doApply{
    [MBProgressHUD showMessage:@""];
    if (picArray.count > 0) {
        [self doUploadImage];
    }else{
        [self doSubmitReturnMoney:@[]];
    }

}
- (void)doUploadImage{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (UIImage *image in picArray) {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"%@upload/image",purl];
        [session POST:url parameters:nil headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.5) name:@"file" fileName:[WYToolClass getNameBaseCurrentTime:@"livethumb.png"] mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];

            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([code isEqual:@"200"]) {
                [nameArray addObject:minstr([data valueForKey:@"url"])];
                if (nameArray.count == picArray.count) {
                    [self doSubmitReturnMoney:nameArray];
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
- (void)doSubmitReturnMoney:(NSArray *)array{
    NSString *pics = @"";
    for (NSString *str in array) {
        if (pics.length == 0) {
            pics = str;
        }else{
            pics = [NSString stringWithFormat:@"%@,%@",pics,str];
        }
    }
    NSDictionary *dic = @{
        @"uni":minstr([_orderMessage valueForKey:@"order_id"]),
        @"text":liyouLabel.text,
        @"refund_reason_wap_img":pics,
        @"refund_reason_wap_explain":minstr(textT.text)
    };
    [WYToolClass postNetworkWithUrl:@"order/refund/verify" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [MBProgressHUD showError:msg];
            if (self.block) {
                self.block();
            }
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
