//
//  AddGoodsCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/8.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "AddGoodsCell.h"

@implementation AddGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addGoodsBtnClick:(id)sender {
    
    [MBProgressHUD showMessage:@""];
    if (_model.isAdmin) {
        [WYToolClass postNetworkWithUrl:@"shopadd" andParameter:@{@"productid":_model.goodsID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (self.delegate) {
                        [self.delegate addGoodsChange:_model];
                    }
                });
                
            }
        } fail:^{
            
        }];

    }else{
        NSString *issale;
        if ([_model.is_sale isEqual:@"1"]) {
            issale = @"0";
        }else{
            issale = @"1";
        }
        [WYToolClass postNetworkWithUrl:@"setsale" andParameter:@{@"productid":_model.goodsID,@"issale":issale} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (self.delegate) {
                        [self.delegate addGoodsChange:_model];
                    }
                    _model.is_sale = issale;
                    if ([_model.is_sale isEqual:@"1"]) {
                        _addBtn.selected = YES;
                        _addBtn.layer.borderColor = RGB_COLOR(@"#C8C8C8", 1).CGColor;
                    }else{
                        _addBtn.selected = NO;
                        _addBtn.layer.borderColor = RGB_COLOR(@"#FF5121", 1).CGColor;
                    }
                });
                
            }
        } fail:^{
            
        }];

    }
    

}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _nameLabel.text = _model.name;
    _jiageLabel.text = [NSString stringWithFormat:@"售价：¥ %@",_model.price];
    _priceLabel.text = _model.bring_price;
    if ([_model.is_sale isEqual:@"1"]) {
        _addBtn.selected = YES;
        _addBtn.layer.borderColor = RGB_COLOR(@"#C8C8C8", 1).CGColor;

    }else{
        _addBtn.selected = NO;
        _addBtn.layer.borderColor = RGB_COLOR(@"#FF5121", 1).CGColor;
    }
}

@end
