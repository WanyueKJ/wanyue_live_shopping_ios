//
//  collectGoodsCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/7/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "collectGoodsCell.h"

@implementation collectGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)doDelate:(id)sender {
    if (self.delegate) {
        [self.delegate removeCollected:_model];
    }
}
- (void)setModel:(collectGoodsModel *)model{
    _model = model;
    [_thumbImgV sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    _nameL.text = _model.store_name;
    _priceL.text = [NSString stringWithFormat:@"¥ %@",_model.price];
}
@end
