//
//  addAddressVC.m
//  yunbaolive
//
//  Created by IOS1 on 2019/3/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "addAddressVC.h"
#import "MyTextView.h"
@interface addAddressVC ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    UITextField *nameT;
    UITextField *phoneT;
    UITextField *cityL;
    UITextField *addressT;
    UIView *deleteView;
    
    
    UIView *cityPickBack;
    UIPickerView *cityPicker;
    //省市区-数组
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    //省市区-字符串
    NSString *provinceStr;
    NSString *cityStr;
    NSString *districtStr;
    NSString *city_id;
    
    NSDictionary *areaDic;
    NSString *selectedProvince;
    UIButton *defaultBtn;
    NSArray *areaArray;
}

@end

@implementation addAddressVC
- (void)tapClick{
    [phoneT resignFirstResponder];
    [nameT resignFirstResponder];
    [addressT resignFirstResponder];
}
- (void)textFiledEditChanged:(id)sender{
    if (nameT.text.length > 0 && phoneT.text.length > 0 && addressT.text.length > 0 && cityL.text.length > 0 ) {
    }else{
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//    [self.view addGestureRecognizer:tap];
    self.titleL.text = @"添加地址";
    self.view.backgroundColor = colorf0;
    [self creatUI];
    /*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:[NSString stringWithFormat:@"area"] ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    //---> //rk_3-7 修复首次加载问题
    province = [[NSArray alloc] initWithArray: provinceTmp];
    NSString *index = [sortedArray objectAtIndex:0];
    //NSString *selected = [province objectAtIndex:0];
    selectedProvince = [province objectAtIndex:0];
    NSDictionary *proviceDic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selectedProvince]];
    
    NSArray *cityArray = [proviceDic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [proviceDic objectForKey: [cityArray objectAtIndex:0]]];
    //city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    NSArray *citySortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *m_array = [[NSMutableArray alloc] init];
    for (int i=0; i<[citySortedArray count]; i++) {
        NSString *index = [citySortedArray objectAtIndex:i];
        NSArray *temp = [[proviceDic objectForKey: index] allKeys];
        [m_array addObject: [temp objectAtIndex:0]];
    }
    city = [NSArray arrayWithArray:m_array];
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
     */

}
- (void)creatUI{
    NSArray *array = @[@"姓名",@"联系电话",@"所在地区",@"详细地址"];
    NSArray *placeHolderArray = @[@"请输入姓名",@"请输入联系电话",@"省，市，区",@"请填写具体地址"];
    for (int i = 0; i < array.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.view);
            make.top.equalTo(self.naviView.mas_bottom).offset(i * 51 + 5);
//            if (i == array.count - 1) {
//                make.height.mas_equalTo(100);
//            }else{
                make.height.mas_equalTo(51);
//            }
        }];
        UILabel *label = [[UILabel alloc]init];
        label.font = SYS_Font(15);
        label.textColor = color32;
        label.text = array[i];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.equalTo(view);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(50);
        }];
        UITextField *textt = [[UITextField alloc]init];
        textt.font = SYS_Font(15);
        textt.textColor = color32;
        textt.placeholder = placeHolderArray[i];
//        [textt setValue:RGB_COLOR(@"#C7C7C7", 1) forKeyPath:@"_placeholderLabel.textColor"];
        [view addSubview:textt];
        [textt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.height.equalTo(view).offset(-1);
            make.left.equalTo(label.mas_right).offset(3);
            make.right.equalTo(view).offset(-30);
        }];
        switch (i) {
            case 0:
                nameT = textt;
                break;
            case 1:
                phoneT = textt;
                break;
            case 2:
                textt.text = placeHolderArray[i];
                cityL = textt;
                break;
            case 3:
                addressT = textt;
                break;

            default:
                break;
        }
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = colorf0;
        [view addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.right.equalTo(view).offset(-15);
            make.bottom.equalTo(view);
            make.height.mas_equalTo(1);
        }];
        if (i == 2) {
            cityL.userInteractionEnabled = NO;
            UIImageView *rightImgView = [[UIImageView alloc]init];
            rightImgView.image = [UIImage imageNamed:@"address选地址"];
            rightImgView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:rightImgView];
            [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label);
                make.right.equalTo(view).offset(-10);
                make.width.height.mas_equalTo(15);
            }];
            UIButton *btn = [UIButton buttonWithType:0];
            [btn addTarget:self action:@selector(selectCityType) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.width.height.equalTo(view);
            }];
        }
       
    }

    
    UIView *defaultView = [[UIView alloc]init];
    defaultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:defaultView];
    [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom).offset(4 * 51 + 10);
        make.height.mas_equalTo(50);
    }];
    defaultBtn = [UIButton buttonWithType:0];
    [defaultBtn setImage:[UIImage imageNamed:@"jubao_nor"] forState:0];
    [defaultBtn setImage:[UIImage imageNamed:@"cart_sel"] forState:UIControlStateSelected];
    [defaultBtn setTitle:@"  设置为默认地址" forState:0];
    [defaultBtn setTitleColor:color32 forState:0];
    defaultBtn.titleLabel.font = SYS_Font(14);
    [defaultBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [defaultView addSubview:defaultBtn];
    [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(defaultView).offset(15);
        make.centerY.equalTo(defaultView);
    }];
    if (_model) {
        provinceStr = _model.province;
        cityStr = _model.city;
        districtStr = _model.area;
        cityL.text = [NSString stringWithFormat:@"%@%@%@",_model.province,_model.city,_model.area];
        nameT.text = _model.name;
        phoneT.text = _model.mobile;
        addressT.text = _model.detail;
        defaultBtn.selected = [_model.isdef intValue];
    }
    UIButton *saveBtn = [UIButton buttonWithType:0];
    [saveBtn setBackgroundColor:normalColors];
    [saveBtn setTitle:@"立即保存" forState:0];
    saveBtn.titleLabel.font = SYS_Font(15);
    [saveBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.cornerRadius = 20;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(defaultView.mas_bottom).offset(15);
        make.width.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];

}
- (void)defaultBtnClick{
    defaultBtn.selected = !defaultBtn.selected;
}
- (void)selectCityType{
    [self tapClick];
    if (!cityPickBack) {
        cityPickBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        cityPickBack.backgroundColor = RGB_COLOR(@"#000000", 0.3);
        [self.view addSubview:cityPickBack];
        UIView *pickBView = [[UIView alloc]initWithFrame:CGRectMake(15, _window_height-240-ShowDiff, _window_width-30, 230)];
        pickBView.layer.cornerRadius = 10;
        pickBView.backgroundColor = [UIColor whiteColor];
        [cityPickBack addSubview:pickBView];
        UILabel *pickTitleL = [[UILabel alloc]initWithFrame:CGRectMake(pickBView.width/2-50, 0, 100, 40)];
        pickTitleL.textAlignment = NSTextAlignmentCenter;
        pickTitleL.text = @"选择地区";
        pickTitleL.font = SYS_Font(15);
        pickTitleL.textColor = color32;
        [pickBView addSubview:pickTitleL];
        
        UIButton *cancleBtn = [UIButton buttonWithType:0];
        cancleBtn.frame = CGRectMake(0, 0, 60, 40);
        cancleBtn.tag = 100;
        [cancleBtn setTitle:@"取消" forState:0];
        [cancleBtn setTitleColor:color32 forState:0];
        cancleBtn.titleLabel.font = SYS_Font(15);
        [cancleBtn addTarget:self action:@selector(cityCancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [pickBView addSubview:cancleBtn];
        UIButton *sureBtn = [UIButton buttonWithType:0];
        sureBtn.frame = CGRectMake(pickBView.width-70, 0, 80, 40);
        sureBtn.tag = 101;
        [sureBtn setTitle:@"确定" forState:0];
        [sureBtn setTitleColor:color32 forState:0];
        sureBtn.titleLabel.font = SYS_Font(15);
        [sureBtn addTarget:self action:@selector(cityCancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [pickBView addSubview:sureBtn];
        [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 40, pickBView.width, 1) andColor:colorf0 andView:pickBView];
        
        cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, _window_width, 190)];
        cityPicker.backgroundColor = [UIColor clearColor];
        cityPicker.delegate = self;
        cityPicker.dataSource = self;
        cityPicker.showsSelectionIndicator = YES;
//        [cityPicker selectRow: 0 inComponent: 0 animated: YES];

        [pickBView addSubview:cityPicker];
        [self requestArea];
    }else{
        cityPickBack.hidden = NO;
    }

}
                           
- (void)cityCancleOrSure:(UIButton *)button{
    if (button.tag == 100) {
        //return;
    }else{
        NSInteger provinceIndex = [cityPicker selectedRowInComponent: 0];
        NSInteger cityIndex = [cityPicker selectedRowInComponent: 1];
        NSInteger districtIndex = [cityPicker selectedRowInComponent: 2];
        
        provinceStr = minstr([[province objectAtIndex: provinceIndex] valueForKey:@"n"]);
        cityStr = minstr([[city objectAtIndex: cityIndex] valueForKey:@"n"]);
        city_id = minstr([[city objectAtIndex: cityIndex] valueForKey:@"v"]);
        districtStr = minstr([[district objectAtIndex:districtIndex] valueForKey:@"n"]);
        NSString *dizhi = [NSString stringWithFormat:@"%@%@%@",provinceStr,cityStr,districtStr];
        cityL.text = dizhi;
    }
    cityPickBack.hidden = YES;
    [self textFiledEditChanged:nil];
}
- (void)requestArea{
    [WYToolClass getQCloudWithUrl:@"city_list" Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            province = info;
            city = [[province firstObject] valueForKey:@"c"];
            district = [[city firstObject] valueForKey:@"c"];
            [cityPicker reloadAllComponents];
        }
    } Fail:^{
        
    }];
}

#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        if (component == 0) {
            return [province count];
        }
        else if (component == 1) {
            return [city count];
        }
        else {
            return [district count];
        }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        if (component == 0) {
            return minstr([[province objectAtIndex: row] valueForKey:@"n"]);
        }
        else if (component == 1) {
            return minstr([[city objectAtIndex: row] valueForKey:@"n"]);
        }
        else {
            return minstr([[district objectAtIndex: row] valueForKey:@"n"]);
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        if (component == 0) {
//            selectedProvince = [province objectAtIndex: row];
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
//            NSArray *cityArray = [dic allKeys];
//            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;//递减
//                }
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;//上升
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for (int i=0; i<[sortedArray count]; i++) {
//                NSString *index = [sortedArray objectAtIndex:i];
//                NSArray *temp = [[dic objectForKey: index] allKeys];
//                [array addObject: [temp objectAtIndex:0]];
//            }
//
//            city = [[NSArray alloc] initWithArray: array];
//
//            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
//            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
            city = [[province objectAtIndex: row] valueForKey:@"c"];
            district = [[city firstObject] valueForKey:@"c"];

            [cityPicker selectRow: 0 inComponent: 1 animated: YES];
            [cityPicker selectRow: 0 inComponent: 2 animated: YES];
            [cityPicker reloadComponent: 1];
            [cityPicker reloadComponent: 2];
            
        } else if (component == 1) {
//            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [province indexOfObject: selectedProvince]];
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
//            NSArray *dicKeyArray = [dic allKeys];
//            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//
//            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
//            NSArray *cityKeyArray = [cityDic allKeys];
//
//            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
            district = [[city objectAtIndex:row] valueForKey:@"c"];

            [cityPicker selectRow: 0 inComponent: 2 animated: YES];
            [cityPicker reloadComponent: 2];
        }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 80;
    }
    else if (component == 1) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
        if (component == 0) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _window_width/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = minstr([[province objectAtIndex:row] valueForKey:@"n"]);
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        else if (component == 1) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _window_width/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = minstr([[city objectAtIndex:row] valueForKey:@"n"]);
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        else {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _window_width/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = minstr([[district objectAtIndex:row] valueForKey:@"n"]);
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
    return myView;
}
- (void)rightBtnClick{

    if (nameT.text.length == 0) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (phoneT.text.length == 0) {
        [MBProgressHUD showError:@"请输入联系电话"];
        return;
    }
    if (!provinceStr || provinceStr.length == 0) {
        [MBProgressHUD showError:@"请选择所在地区"];
        return;
    }
    if (addressT.text.length == 0) {
        [MBProgressHUD showError:@"请填写具体地址"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSDictionary *dic = @{
        @"is_default":[NSString stringWithFormat:@"%d",defaultBtn.selected],
        @"id":_model?_model.aID:@"",
        @"real_name":nameT.text,
        @"phone":phoneT.text,
        @"address":@{
                @"province":provinceStr,
                @"city":cityStr,
                @"district":districtStr,
                @"city_id":_model ? @"0" : city_id
        },
        @"post_code":@"",
        @"detail":addressT.text,
        @"type":@"0"
        };
    
    [WYToolClass postNetworkWithUrl:@"address/edit" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self doReturn];
            });
        }
    } fail:^{
        
    }];

//    [WYToolClass postNetworkWithUrl:url andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
//        if (code == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        [MBProgressHUD showError:msg];
//    } fail:^{
//
//    }];
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
