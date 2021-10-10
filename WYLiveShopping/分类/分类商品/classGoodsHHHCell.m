//
//  classGoodsHHHCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "classGoodsHHHCell.h"

@implementation classGoodsHHHCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImgV sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _titleL.text = _model.name;
    _salesL.text = [NSString stringWithFormat:@"已售%@件",_model.sales];
    if (model.vip_price.length > 0) {
        _priceL.hidden = NO;
        _vipImgV.hidden = NO;
        _vipPriceL.font = [UIFont boldSystemFontOfSize:15];
        _vipPriceL.textColor = color32;
        _vipPriceL.text = [NSString stringWithFormat:@"¥%@",_model.vip_price];
        _priceL.text = [NSString stringWithFormat:@"¥%@",_model.price];

    }else{
        _priceL.text = @"";
        _priceL.hidden = YES;
        _vipImgV.hidden = YES;
        _vipPriceL.font = [UIFont boldSystemFontOfSize:17];
        _vipPriceL.textColor = normalColors;
        _vipPriceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
    }
}

@end
