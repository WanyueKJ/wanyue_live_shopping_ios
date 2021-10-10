//
//  addressCell.m
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "addressCell.h"

@implementation addressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)delateBtnClick:(id)sender {
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除该地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate) {
            [self.delegate delateAddress:_model];
        }
    }];
    [alertContro addAction:sureAction];
    [[MXBADelegate sharedAppDelegate].topViewController presentViewController:alertContro animated:YES completion:nil];

}
- (IBAction)editBtnClick:(id)sender {
    if (self.delegate) {
        [self.delegate editAddress:_model];
    }
}
- (void)setModel:(addressModel *)model{
    _model = model;
    if ([_model.isdef isEqual:@"1"]) {
        _defaultBtn.selected = YES;
    }else{
        _defaultBtn.selected = NO;
    }
    _nameL.text = [NSString stringWithFormat:@"收货人：%@   %@",_model.name,_model.mobile];
    _detaliesL.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",_model.province,_model.city,_model.area,_model.detail];
}
- (IBAction)doSetDefault:(id)sender {
    if ([_model.isdef isEqual:@"1"]) {
        return;
    }
    if (self.delegate) {
        [self.delegate setDefault:_model];
    }

}
@end
