//
//  evaluateWriteViewController.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "evaluateWriteViewController.h"
#import "WYStarView.h"
#import "MyTextView.h"

@implementation WYPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _thumbImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
        _thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImgView.clipsToBounds = YES;
        [self addSubview:_thumbImgView];
        _delateBtn = [UIButton buttonWithType:0];
        [_delateBtn setBackgroundImage:[UIImage imageNamed:@"photo_delate"] forState:0];
        _delateBtn.frame = CGRectMake(self.width-10, 0, 10, 10);
        [self addSubview:_delateBtn];
    }
    return self;
}
@end



@interface evaluateWriteViewController ()<WYStarViewClickDelegate,TZImagePickerControllerDelegate>{
    WYStarView *zhiliangStar;
    UILabel *zhiliangLabel;
    WYStarView *fuwuStar;
    UILabel *fuwuLabel;
    UIView *wordAndPicView;
    MyTextView *textT;
    NSMutableArray *picArray;
    NSMutableArray *picImgViewArray;

    UIScrollView *backScrollView;
    UIButton *picBtn;
    
}

@end

@implementation evaluateWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"商品评价";
    picArray = [NSMutableArray array];
    picImgViewArray = [NSMutableArray array];
    [self creatUI];
}
- (void)creatUI{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.naviView.bottom, _window_width, _window_height-self.naviView.bottom)];
    [self.view addSubview:backScrollView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 83)];
    [backScrollView addSubview:view];
    UIImageView *thumbImgV = [[UIImageView alloc]init];
    thumbImgV.contentMode = UIViewContentModeScaleAspectFill;
    [thumbImgV sd_setImageWithURL:[NSURL URLWithString:_goodsModel.image]];
    thumbImgV.layer.cornerRadius = 5;
    thumbImgV.layer.masksToBounds = YES;
    [view addSubview:thumbImgV];
    [thumbImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.width.height.mas_equalTo(60);
    }];
    UILabel *pricelabel = [[UILabel alloc]init];
    pricelabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.price];
    pricelabel.font = SYS_Font(14);
    pricelabel.textColor = color96;
    [view addSubview:pricelabel];
    [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.top.equalTo(thumbImgV).offset(2);
    }];

    
    UILabel *namelabel = [[UILabel alloc]init];
    namelabel.text = _goodsModel.store_name;
    namelabel.font = SYS_Font(14);
    namelabel.textColor = color32;
    namelabel.numberOfLines = 2;
    [view addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thumbImgV.mas_right).offset(8);
        make.top.equalTo(thumbImgV).offset(2);
        make.right.lessThanOrEqualTo(pricelabel.mas_left).offset(-10);
    }];
    UILabel *numsLabel = [[UILabel alloc]init];
    numsLabel.text = [NSString stringWithFormat:@"x%@",_goodsModel.cart_num];
    numsLabel.font = SYS_Font(14);
    numsLabel.textColor = color96;
    [view addSubview:numsLabel];
    [numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pricelabel);
        make.top.equalTo(pricelabel.mas_bottom).offset(8);
    }];
    [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, view.height-1, _window_width, 1) andColor:colorf0 andView:view];
    NSArray *array = @[@"商品质量",@"服务态度"];
    for (int i = 0; i < array.count; i ++) {
        UIView *starView = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom + 15 + i * 40, _window_width, 40)];
        [backScrollView addSubview:starView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 40)];
        label.text = array[i];
        label.font = SYS_Font(14);
        label.textColor = color32;
        [starView addSubview:label];
        WYStarView *vvvv = [[WYStarView alloc]initWithFrame:CGRectMake(label.right + 10, 10, 150, 20) starCount:5 starStyle:0 isAllowScroe:YES];
        vvvv.delegate = self;
        [starView addSubview:vvvv];
        UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(vvvv.right+10, 0, 65, 40)];
        showLabel.font = SYS_Font(12);
        showLabel.textColor = RGB_COLOR(@"#C8C8C8", 1);
        [starView addSubview:showLabel];
        if (i == 0) {
            zhiliangStar = vvvv;
            zhiliangLabel = showLabel;
        }else{
            fuwuStar = vvvv;
            fuwuLabel = showLabel;
        }
    }
    wordAndPicView = [[UIView alloc]initWithFrame:CGRectMake(15, view.bottom + 100, _window_width-30, 180)];
    wordAndPicView.backgroundColor = RGB_COLOR(@"#FAFAFA", 1);
    wordAndPicView.layer.cornerRadius = 5;
    [backScrollView addSubview:wordAndPicView];
    textT = [[MyTextView alloc]initWithFrame:CGRectMake(15, 15, wordAndPicView.width-30, 45)];
    textT.placeholder = @"商品满足你的期待么？说说你的想法，分享给想买的他们吧～";
    textT.placeholderColor = RGB_COLOR(@"#C8C8C8", 1);
    textT.font = SYS_Font(14);
    textT.textColor = color32;
    textT.backgroundColor = [UIColor clearColor];
    [wordAndPicView addSubview:textT];
    CGFloat btnWidth = (wordAndPicView.width - 20)/4;
    picBtn = [UIButton buttonWithType:0];
    picBtn.frame = CGRectMake(10, 90, btnWidth-10, btnWidth-10);
    [picBtn addTarget:self action:@selector(showImagePicker:) forControlEvents:UIControlEventTouchUpInside];
    [picBtn setImage:[UIImage imageNamed:@"上传图片"] forState:0];
    [wordAndPicView addSubview:picBtn];
    
    UIView *submitView = [[UIView alloc]init];
    submitView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:submitView];
    [submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(backScrollView);
        make.top.equalTo(wordAndPicView.mas_bottom);
        make.height.mas_equalTo(80);
    }];
    UIButton *creatButton = [UIButton buttonWithType:0];
    [creatButton setTitle:@"立即评价" forState:0];
    [creatButton setBackgroundColor:normalColors];
    creatButton.titleLabel.font = SYS_Font(15);
    creatButton.layer.cornerRadius = 20;
    creatButton.layer.masksToBounds = YES;
    [creatButton addTarget:self action:@selector(doSubmitPingjia) forControlEvents:UIControlEventTouchUpInside];
    creatButton.frame = CGRectMake(15, 20, _window_width-30, 40);
    [submitView addSubview:creatButton];

    
}
- (void)didClickStarView:(WYStarView *)starView andCurrentScore:(CGFloat)score{
    if (starView == zhiliangStar) {
        zhiliangLabel.text = [NSString stringWithFormat:@"%.0f分",score];
    }else{
        fuwuLabel.text = [NSString stringWithFormat:@"%.0f分",score];
    }
}
- (void)showImagePicker:(UIButton *)sender{
    TZImagePickerController *imagePC = [[TZImagePickerController alloc]initWithMaxImagesCount:8-picArray.count delegate:self];
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
    CGFloat btnWidth = (wordAndPicView.width - 20)/4;

    for (UIImage *image in photos) {
        WYPhotoView *view = [[WYPhotoView alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
        view.thumbImgView.image = image;
        [wordAndPicView addSubview:view];
        [picImgViewArray addObject:view];
    }
    
}
- (void)reloadPicView{
    if (picImgViewArray.count == 8) {
        picBtn.hidden = YES;
    }else{
        picBtn.hidden = NO;
    }

    CGFloat btnWidth = (wordAndPicView.width - 20)/4;
    if (picImgViewArray.count > 0) {
        for (int i = 0; i < picImgViewArray.count; i ++) {
            WYPhotoView *view = picImgViewArray[i];
            view.delateBtn.tag = 1000 + i;
            [view.delateBtn removeTarget:self action:@selector(doDelateImage:) forControlEvents:UIControlEventTouchUpInside];
            [view.delateBtn addTarget:self action:@selector(doDelateImage:) forControlEvents:UIControlEventTouchUpInside];
            view.frame = CGRectMake(10 + (i%4) * btnWidth, 85 + i/4*(btnWidth + 5), btnWidth, btnWidth);
            if (i == picImgViewArray.count-1) {
                picBtn.frame =  CGRectMake(10 + ((i+1)%4) * btnWidth+5, 85 + (i+1)/4*(btnWidth + 5)+5, btnWidth-10, btnWidth-10);
                if (picBtn.bottom > 180) {
                    if (i == 7) {
                        wordAndPicView.height = view.bottom + 20;
                    }else{
                        wordAndPicView.height = picBtn.bottom + 20;
                    }
                }else{
                    wordAndPicView.height = 180;
                }
            }
        }
    }else{
        picBtn.frame = CGRectMake(10, 90, btnWidth-10, btnWidth-10);
        wordAndPicView.height = 180;
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
- (void)doSubmitPingjia{
    if (zhiliangStar.currentScore == 0) {
        [MBProgressHUD showError:@"请为商品评分"];
        return;

    }
    if (fuwuStar.currentScore == 0) {
        [MBProgressHUD showError:@"请为服务评分"];
        return;

    }

    if (textT.text.length == 0) {
        [MBProgressHUD showError:@"请输入评价内容"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    if (picArray.count > 0) {
        [self doUploadImage];
    }else{
        [self doPingjia:@[]];
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
                    [self doPingjia:nameArray];
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
- (void)doPingjia:(NSArray *)array{
    NSString *pics = @"";
    for (NSString *str in array) {
        if (pics.length == 0) {
            pics = str;
        }else{
            pics = [NSString stringWithFormat:@"%@,%@",pics,str];
        }
    }
    NSDictionary *dic = @{
        @"unique":_goodsModel.unique,
        @"comment":textT.text,
        @"pics":pics,
        @"product_score":[NSString stringWithFormat:@"%.0f",zhiliangStar.currentScore],//zhiliangStar.currentScore == 0 ? @"5" :
        @"service_score":[NSString stringWithFormat:@"%.0f",fuwuStar.currentScore],//fuwuStar.currentScore == 0 ? @"5" :
    };
    [WYToolClass postNetworkWithUrl:@"order/comment" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 200) {
            [MBProgressHUD showSuccess:@"感谢您的评价!"];
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
