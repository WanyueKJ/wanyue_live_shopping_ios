//
//  anchorMessageView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "anchorMessageView.h"
#import "StoreHomeViewController.h"

@implementation anchorMessageView{
    NSString *anchorId;
    NSDictionary *infoDic;
    NSString *action;
    
}
//action: 0表示自己，30表示普通用户，40表示管理员，501表示主播设置管理员，502表示主播取消管理员，60表示超管管理主播，70表示对方是超管
#pragma mark -  判断是否显示关闭直播
- (void)requestMessage:(NSString *)touid{
    anchorId = touid;
    [WYToolClass getQCloudWithUrl:[NSString stringWithFormat:@"pop?touid=%@&liveuid=%@",touid,touid] Suc:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 200) {
            infoDic = info;
            [_iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([info valueForKey:@"avatar"])]];
            _nameLabel.text = minstr([info valueForKey:@"nickname"]);
            _IDLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([info valueForKey:@"uid"])];
            _followNumsL.text = [NSString stringWithFormat:@"关注 %@",minstr([info valueForKey:@"follows"])];
            _fanNumsL.text = [NSString stringWithFormat:@"粉丝 %@",minstr([info valueForKey:@"fans"])];
            action = minstr(info[@"action"]);
            if (action.integerValue == 60) {
                _followBtn.hidden = YES;
                _messageBtn.hidden = YES;
                _closeLiveBtn.hidden = NO;
                _shopBtn.hidden = YES;
            }
        }
    } Fail:^{
        
    }];

}

- (IBAction)messageBtnClick:(id)sender {
    [MBProgressHUD showError:@"敬请期待"];
}
- (IBAction)doFollow:(id)sender {
    _followBtn.userInteractionEnabled = NO;

    if (_followBtn.selected) {
        _followBtn.selected = !_followBtn.selected;
        [WYToolClass postNetworkWithUrl:@"attent/del" andParameter:@{@"touid":anchorId} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            _followBtn.userInteractionEnabled = YES;
            if (code == 200) {
                [MBProgressHUD showError:msg];
                if (self.block) {
                    self.block(NO);
                }
            }else{
                _followBtn.selected = YES;

            }
        } fail:^{
            _followBtn.userInteractionEnabled = YES;
            _followBtn.selected = YES;

        }];

    }else{
        _followBtn.selected = !_followBtn.selected;
        [WYToolClass postNetworkWithUrl:@"attent/add" andParameter:@{@"touid":anchorId} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            _followBtn.userInteractionEnabled = YES;
            if (code == 200) {
                [MBProgressHUD showError:msg];
                if (self.block) {
                    self.block(YES);
                }
            }else{
                _followBtn.selected = NO;

            }
        } fail:^{
            _followBtn.userInteractionEnabled = YES;
            _followBtn.selected = NO;
        }];

    }

}
- (IBAction)doShop:(id)sender {
    StoreHomeViewController *vc = [[StoreHomeViewController alloc]init];
    vc.liveUid = anchorId;
    vc.avatar = minstr([infoDic valueForKey:@"avatar"]);
    vc.nickname = minstr([infoDic valueForKey:@"nickname"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
}
- (IBAction)doClose:(id)sender {
    self.hidden = YES;
}

- (IBAction)closeLiveAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeLive)]) {
        [self.delegate closeLive];
    }
}
@end
