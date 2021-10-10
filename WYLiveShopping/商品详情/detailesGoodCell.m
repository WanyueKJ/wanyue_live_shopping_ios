//
//  detailesGoodCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/28.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "detailesGoodCell.h"

@implementation detailesGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _nameL.text = _model.name;
    _priceL.text = [NSString stringWithFormat:@"¥%@",_model.price];
}

@end
