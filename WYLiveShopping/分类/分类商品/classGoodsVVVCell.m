//
//  classGoodsVVVCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/28.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "classGoodsVVVCell.h"

@implementation classGoodsVVVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _nameL.text = _model.name;
    _salesL.text = [NSString stringWithFormat:@"已售%@件",_model.sales];
//    _vipPriceL.text = [NSString stringWithFormat:@"¥%@",_model.vip_price];
    if (model.vip_price.length > 0) {
        _priceL.hidden = NO;
        _vipImgV.hidden = NO;
        _vipPriceL.font = [UIFont boldSystemFontOfSize:11];
        _vipPriceL.textColor = color32;
        _vipPriceL.text = [NSString stringWithFormat:@"¥%@",_model.vip_price];
        _priceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
    }else{
        _priceL.hidden = YES;
        _vipImgV.hidden = YES;
        _priceL.text = @"";
        _vipPriceL.font = [UIFont boldSystemFontOfSize:12];
        _vipPriceL.textColor = normalColors;
        _vipPriceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
    }

}

@end
