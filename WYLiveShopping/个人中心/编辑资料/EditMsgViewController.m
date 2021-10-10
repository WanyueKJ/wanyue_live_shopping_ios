//
//  EditMsgViewController.m
//  live1v1
//
//  Created by IOS1 on 2019/4/2.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import "EditMsgViewController.h"

@interface EditMsgViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage *selectImage;
    UITextField *nameT;
    UIButton *photoBtn;
}

@end

@implementation EditMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleL.text = @"编辑资料";
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"保存" forState:0];
    [self creatUI];
}
- (void)creatUI{
    photoBtn = [UIButton buttonWithType:0];
    if ([Config getavatar]) {
        [photoBtn sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]] forState:0];
    }else{
        [photoBtn setImage:[UIImage imageNamed:@"edit_默认头像"] forState:0];
    }
    [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    photoBtn.layer.cornerRadius = 40.0;
    photoBtn.layer.masksToBounds = YES;
    [self.view addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+statusbarHeight+60);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(80);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"点击更换头像";
    label1.textColor = color96;
    label1.font = SYS_Font(10);
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(photoBtn);
        make.top.equalTo(photoBtn.mas_bottom).offset(10);
    }];
    
    nameT = [[UITextField alloc]init];
    nameT.text = [Config getOwnNicename];
//    [nameT setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameT.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameT];
    [nameT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(photoBtn);
        make.top.equalTo(label1.mas_bottom).offset(38);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(140);
    }];
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"edit_编辑"];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameT);
        make.left.equalTo(nameT.mas_right).offset(5);
    }];
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = RGB_COLOR(@"#DCDCDC", 1);
    [self.view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameT);
        make.top.equalTo(nameT.mas_bottom);
        make.height.mas_equalTo(1);
    }];

}
- (void)photoBtnClick
{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectThumbWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    [picAction setValue:color32 forKey:@"_titleTextColor"];
    [alertContro addAction:picAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectThumbWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [photoAction setValue:color32 forKey:@"_titleTextColor"];
    [alertContro addAction:photoAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:color96 forKey:@"_titleTextColor"];
    [alertContro addAction:cancleAction];
    
    [self presentViewController:alertContro animated:YES completion:nil];

}
- (void)selectThumbWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = type;
    imagePickerController.allowsEditing = YES;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        selectImage = image;
        [photoBtn setImage:image forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

- (void)rightBtnClick{
    if (nameT.text == nil || nameT.text == NULL || nameT.text.length == 0) {
        [MBProgressHUD showError:@"名字不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"正在提交"];

    if (selectImage) {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"%@upload/image",purl];
        [session POST:url parameters:nil headers:@{@"Authori-zation":[NSString stringWithFormat:@"Bearer %@",[Config getOwnToken]]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(selectImage,0.5) name:@"file" fileName:[WYToolClass getNameBaseCurrentTime:@"livethumb.png"] mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];

            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([code isEqual:@"200"]) {
                [self uploadEditMessage:minstr([data valueForKey:@"url"])];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }];

    }else{
        [self uploadEditMessage:[Config getavatar]];
    }
}
- (void)uploadEditMessage:(NSString *)headerName{
    NSMutableDictionary *editDic = [NSMutableDictionary dictionary];
    [editDic setObject:headerName forKey:@"avatar"];
    [editDic setObject:nameT.text forKey:@"nickname"];

    [WYToolClass postNetworkWithUrl:@"user/edit" andParameter:editDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            NSString *avatar = [editDic valueForKey:@"avatar"];
            NSString *user_nickname = [editDic valueForKey:@"nickname"];
            LiveUser *user = [[LiveUser alloc]init];
            user.avatar = avatar;
            user.nickname = user_nickname;
            [Config updateProfile:user];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    } fail:^{
        [MBProgressHUD hideHUD];

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
