//
//  addTypeView.m
//  yunbaolive
//
//  Created by Boom on 2018/10/11.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "addTypeView.h"

@implementation addTypeView{
    UIView *whiteView;
    UITextField *text1;
    UITextField *text2;
    UITextField *text3;
    UILabel *selectTypeLabel;
    UIImageView *jiantouImg;
    UIView *lineView2;
    int showType;
    UIView *twoBtnView;
}
- (void)hideself{
    if (twoBtnView) {
        [twoBtnView removeFromSuperview];
        twoBtnView = nil;
        return;
    }
    if (text1.isFirstResponder) {
        [text1 resignFirstResponder];
        return;
    }
    if (text2.isFirstResponder) {
        [text2 resignFirstResponder];
        return;
    }
    if (text3.isFirstResponder) {
        [text3 resignFirstResponder];
        return;
    }
    self.hidden = YES;
}
- (void)hideKeyboard{
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
    [text3 resignFirstResponder];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        showType = 1;
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideself)];
        [self addGestureRecognizer:tap];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds  =YES;
    whiteView.layer.cornerRadius = 5.0;
    [self addSubview:whiteView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [whiteView addGestureRecognizer:tap];

    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(_window_height*0.26);
        make.width.equalTo(self).multipliedBy(0.8);
        make.centerX.equalTo(self);
    }];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"添加提现账户";
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(whiteView);
        make.height.mas_equalTo(50);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"账户类型";
    label.font = [UIFont boldSystemFontOfSize:14];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(20);
        make.top.equalTo(titleL.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    jiantouImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profit_right"]];
    [whiteView addSubview:jiantouImg];
    [jiantouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-20);
        make.width.height.mas_equalTo(18);
        make.centerY.equalTo(label);
    }];
    selectTypeLabel = [[UILabel alloc] init];
    selectTypeLabel.text =  @"支付宝";
    selectTypeLabel.font = [UIFont systemFontOfSize:14];
    selectTypeLabel.textColor = RGB_COLOR(@"#333333", 1);
    [whiteView addSubview:selectTypeLabel];
    [selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(label);
        make.right.equalTo(jiantouImg.mas_left).offset(-2);
    }];
    
    UIButton *selectTypebtn = [UIButton buttonWithType:0];
    [selectTypebtn addTarget:self action:@selector(selectTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:selectTypebtn];
    [selectTypebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(selectTypeLabel);
        make.right.equalTo(jiantouImg);
    }];
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    [whiteView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.right.equalTo(jiantouImg);
        make.height.mas_equalTo(1);
    }];
    
    text1 = [[UITextField alloc]init];
    text1.font = [UIFont systemFontOfSize:15];
    text1.backgroundColor = RGB_COLOR(@"#f7f7f7", 1);
    text1.layer.cornerRadius = 5;
    text1.layer.masksToBounds = YES;
    text1.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    text1.leftViewMode = UITextFieldViewModeAlways;
    [whiteView addSubview:text1];
    [text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView1);
        make.top.equalTo(lineView1.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    text2 = [[UITextField alloc]init];
    text2.font = [UIFont systemFontOfSize:15];
    text2.backgroundColor = RGB_COLOR(@"#f7f7f7", 1);
    text2.layer.cornerRadius = 5;
    text2.layer.masksToBounds = YES;
    text2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    text2.leftViewMode = UITextFieldViewModeAlways;
    [whiteView addSubview:text2];
    [text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView1);
        make.top.equalTo(text1.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    text3 = [[UITextField alloc]init];
    text3.font = [UIFont systemFontOfSize:15];
    text3.backgroundColor = RGB_COLOR(@"#f7f7f7", 1);
    text3.layer.cornerRadius = 5;
    text3.layer.masksToBounds = YES;
    text3.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    text3.leftViewMode = UITextFieldViewModeAlways;
    [whiteView addSubview:text3];
    [text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lineView1);
        make.top.equalTo(text2.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = RGB_COLOR(@"#dcddde", 1);
    [whiteView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView);
//        make.top.equalTo(text3.mas_bottom).offset(5);
        make.right.equalTo(whiteView);
        make.height.mas_equalTo(1);
    }];

    UIButton *sureBtn = [UIButton buttonWithType:0];
    [sureBtn setTitle:@"确定" forState:0];
    [sureBtn setTitleColor:normalColors forState:0];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom);
        make.left.width.equalTo(whiteView);
        make.height.mas_equalTo(50);
    }];
    [self updateConstraintsWith:showType];
}
- (void)updateConstraintsWith:(int)type{
    text1.text = @"";
    text2.text = @"";
    text3.text = @"";
    if (type == 1) {
        text1.placeholder = @"请输入支付宝账号";
        text1.keyboardType = UIKeyboardTypeDefault;
        text2.placeholder = @"请输入支付宝账号姓名";
        text2.keyboardType = UIKeyboardTypeDefault;
        text2.hidden = NO;
        text2.delegate = nil;
        text3.hidden = YES;
        [lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(text2.mas_bottom).offset(10);
            make.left.equalTo(whiteView);
            make.right.equalTo(whiteView);
            make.height.mas_equalTo(1);
        }];
        [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(_window_height*0.26);
            make.width.equalTo(self).multipliedBy(0.8);
            make.centerX.equalTo(self);
            make.bottom.equalTo(lineView2.mas_bottom).offset(50);
        }];
    }
    if (type == 2) {
        text1.placeholder = @"请输入微信账号";
        text1.keyboardType = UIKeyboardTypeDefault;
        text2.hidden = YES;
        text2.delegate = nil;
        text3.hidden = YES;
        [lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(text1.mas_bottom).offset(10);
            make.left.equalTo(whiteView);
            make.right.equalTo(whiteView);
            make.height.mas_equalTo(1);
        }];
        [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(_window_height*0.26);
            make.width.equalTo(self).multipliedBy(0.8);
            make.centerX.equalTo(self);
            make.bottom.equalTo(lineView2.mas_bottom).offset(50);
        }];
    }
    if (type == 3) {
        text2.hidden = NO;
        text3.hidden = NO;

        text1.placeholder = @"请输入银行名称";
        text1.keyboardType = UIKeyboardTypeDefault;
        text2.placeholder = @"请输入银行卡账号";
        text2.delegate = self;
        text2.keyboardType = UIKeyboardTypeNumberPad;
        text3.placeholder = @"请输入持卡人姓名";
        text3.keyboardType = UIKeyboardTypeDefault;
        [lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(text3.mas_bottom).offset(10);
            make.left.equalTo(whiteView);
            make.right.equalTo(whiteView);
            make.height.mas_equalTo(1);
        }];
        [whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(_window_height*0.26);
            make.width.equalTo(self).multipliedBy(0.8);
            make.centerX.equalTo(self);
            make.bottom.equalTo(lineView2.mas_bottom).offset(50);
        }];
    }
    [self layoutIfNeeded];
}
- (void)selectTypeBtnClick{
    if (!twoBtnView) {
        twoBtnView = [[UIView alloc]init];
        twoBtnView.backgroundColor = [UIColor whiteColor];
        twoBtnView.layer.cornerRadius = 5;
        twoBtnView.layer.masksToBounds = YES;
        twoBtnView.layer.shadowColor = [UIColor blackColor].CGColor;
        twoBtnView.layer.shadowOpacity = 0.8f;
        twoBtnView.layer.shadowRadius = 2.f;
        twoBtnView.layer.shadowOffset = CGSizeMake(0,2);
        [whiteView addSubview:twoBtnView];
        [twoBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectTypeLabel.mas_bottom).offset(3);
            make.left.equalTo(selectTypeLabel.mas_left).offset(-5);
            make.right.equalTo(jiantouImg.mas_right);
            make.height.mas_equalTo(80);
        }];
        UIButton *btn1 = [UIButton buttonWithType:0];
        [btn1 addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setTitleColor:RGB_COLOR(@"#333333", 1) forState:0];
        [twoBtnView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoBtnView).offset(5);
            make.top.equalTo(twoBtnView);
            make.height.equalTo(twoBtnView).multipliedBy(0.5);
        }];
        
        UIButton *btn2 = [UIButton buttonWithType:0];
        [btn2 addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn2 setTitleColor:RGB_COLOR(@"#333333", 1) forState:0];
        [twoBtnView addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoBtnView).offset(5);
            make.top.equalTo(btn1.mas_bottom);
            make.height.equalTo(twoBtnView).multipliedBy(0.5);
        }];
        if (showType == 1) {
            [btn1 setTitle:@"微信" forState:0];
            [btn2 setTitle:@"银行卡" forState:0];
        }
        if (showType == 2) {
            [btn1 setTitle:@"支付宝" forState:0];
            [btn2 setTitle:@"银行卡" forState:0];
        }
        if (showType == 3) {
            [btn1 setTitle:@"支付宝" forState:0];
            [btn2 setTitle:@"微信" forState:0];
        }
        
    }

}
- (void)changeType:(UIButton *)sender{
    if ([sender.titleLabel.text isEqual:@"支付宝"]) {
        selectTypeLabel.text = @"支付宝";
        showType = 1;
    }
    if ([sender.titleLabel.text isEqual:@"微信"]) {
        selectTypeLabel.text = @"微信";
        showType = 2;
    }
    if ([sender.titleLabel.text isEqual:@"银行卡"]) {
        selectTypeLabel.text = @"银行卡";
        showType = 3;
    }
    [twoBtnView removeFromSuperview];
    twoBtnView = nil;
    [self updateConstraintsWith:showType];
}
- (void)sureBtnClick{
    NSDictionary *subdic;
    if (showType == 1) {
        if (text1.text == nil || text1.text == NULL || text1.text.length == 0) {
            [MBProgressHUD showError:@"请输入支付宝账号"];
            return;
        }
        if (text2.text == nil || text2.text == NULL || text2.text.length == 0) {
            [MBProgressHUD showError:@"请输入支付宝账号姓名"];
            return;
        }
        subdic = @{@"type":@(showType),
                   @"account":text1.text,
                   @"name":text2.text};
    }
    if (showType == 2) {
        if (text1.text == nil || text1.text == NULL || text1.text.length == 0) {
            [MBProgressHUD showError:@"请输入微信账号"];
            return;
        }
        subdic = @{@"type":@(showType),
                   @"account":text1.text,
                   };

    }
    if (showType == 3) {
        if (text1.text == nil || text1.text == NULL || text1.text.length == 0) {
            [MBProgressHUD showError:@"请输入银行名称"];
            return;
        }
        if (text2.text == nil || text2.text == NULL || text2.text.length == 0) {
            [MBProgressHUD showError:@"请输入银行卡账号"];
            return;
        }
        if (text3.text == nil || text3.text == NULL || text3.text.length == 0) {
            [MBProgressHUD showError:@"请输入持卡人姓名"];
            return;
        }
        subdic = @{@"type":@(showType),
                   @"account":text2.text,
                   @"name":text3.text,
                   @"bank":text1.text
                   };

    }

    [WYToolClass postNetworkWithUrl:@"accountadd" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            [MBProgressHUD showError:msg];
            text1.text = @"";
            text2.text = @"";
            text3.text = @"";
            self.block();
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (showType == 3 && textField == text2){
        return [self validateNumber:string];
    }else{
        return YES;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
