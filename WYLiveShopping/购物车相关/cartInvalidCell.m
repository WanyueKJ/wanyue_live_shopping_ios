//
//  cartInvalidCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/30.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "cartInvalidCell.h"

@implementation cartInvalidCell

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
    _nameL.text = _model.store_name;
}

@end
