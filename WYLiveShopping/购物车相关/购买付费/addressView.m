//
//  addressView.m
//  YBEducation
//
//  Created by IOS1 on 2020/5/7.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "addressView.h"
#import "AddressListViewController.h"

@implementation addressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClick:(id)sender {
    AddressListViewController *vc = [[AddressListViewController alloc]init];
    vc.curAddrID = minstr([_adressDic valueForKey:@"id"]);
    WeakSelf;
    vc.block = ^(NSDictionary * _Nonnull dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.adressDic = dic;
            if (weakSelf.block) {
                weakSelf.block();
            }
        });
    };
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (void)setAdressDic:(NSDictionary *)adressDic{
    _adressDic = adressDic;
    if (_adressDic && _adressDic.count > 0) {
        _nothingLabel.hidden = YES;
        _nameL.hidden = NO;
        _detaileL.hidden = NO;
        _nameL.text = [NSString stringWithFormat:@"%@  %@",minstr([_adressDic valueForKey:@"real_name"]),minstr([_adressDic valueForKey:@"phone"])];
        _detaileL.text = [NSString stringWithFormat:@"%@%@%@%@",minstr([_adressDic valueForKey:@"province"]),minstr([_adressDic valueForKey:@"city"]),minstr([_adressDic valueForKey:@"district"]),minstr([_adressDic valueForKey:@"detail"])];
        _leftImgV.hidden = NO;
    }else{
        _leftImgV.hidden = YES;
        _nothingLabel.hidden = NO;
        _nameL.hidden = YES;
        _detaileL.hidden = YES;
    }
}
@end
