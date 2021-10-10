//
//  adminGoodsCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/22.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "adminGoodsCell.h"

@implementation adminGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightBtnClick:(id)sender {
    if (self.delegate) {
        if (_delateBtn.hidden) {
            [self.delegate xiajiaGoods:_model];
        }else{
            [self.delegate shangjiaGoods:_model];
        }
    }
}
- (IBAction)doDelate:(id)sender {
    if (self.delegate) {
        [self.delegate delateGoods:_model];
    }
}
-(void)setModel:(liveGoodsModel *)model{
    _model = model;
    [_thumbImgV sd_setImageWithURL:[NSURL URLWithString:_model.thumb]];
    _titleL.text = _model.name;
    _priceL.text = [NSString stringWithFormat:@"售价：¥ %@",_model.price];
    _salesL.text = [NSString stringWithFormat:@"已售%@件",_model.salenums];
    _profitL.text = _model.bring_price;
}

@end
