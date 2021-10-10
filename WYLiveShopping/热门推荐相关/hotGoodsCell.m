//
//  hotGoodsCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/23.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "hotGoodsCell.h"

@implementation hotGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _nameL.text = _model.name;
    _priceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _salesL.text = [NSString stringWithFormat:@"已售%@件",_model.sales];
}

@end
