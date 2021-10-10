//
//  submitGoodsCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/1.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "submitGoodsCell.h"

@implementation submitGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(cartModel *)model{
    _model = model;
    [_thumbImgV sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    _numsL.text = [NSString stringWithFormat:@"x%@",_model.cart_num];
    _nameL.text = _model.store_name;
    _sukLabel.text = _model.suk;
    _priceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
}

@end
