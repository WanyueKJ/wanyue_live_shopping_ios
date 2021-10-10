//
//  giftCell.m
//  yunbaolive
//
//  Created by Boom on 2018/10/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "giftCell.h"

@implementation giftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(liwuModel *)model{
    _model = model;
    self.giftIcon.yy_imageURL = [NSURL URLWithString:_model.imagePath];
//    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:_model.imagePath] placeholderImage:[UIImage imageNamed:@"mr.png"]];
    _giftNameL.text = _model.giftname;
    _giftCoinL.text = [NSString stringWithFormat:@"%@%@",_model.price,[common name_coin]];
    if ([_model.mark isEqual:@"1"]) {
        _giftTypeImg2.image = [UIImage imageNamed:@"gift_热"];
    }else if ([_model.mark isEqual:@"2"]){
        _giftTypeImg2.image = [UIImage imageNamed:@"gift_守"];
    }else if ([_model.mark isEqual:@"3"]){
        _giftTypeImg2.image = [UIImage imageNamed:@"gift_lucky"];
    }else{
        _giftTypeImg2.image = [UIImage new];
    }
    if ([_model.type isEqual:@"1"]) {
        _giftTypeImg1.hidden = NO;
//        if ([_model.isplatgift isEqual:@"1"]) {
//            _giftTypeImg1.image =[UIImage imageNamed:@"gift_全"];
//        }else{
//            _giftTypeImg1.image =[UIImage imageNamed:@"gift_豪"];
//
//        }
    }else{
        _giftTypeImg1.hidden = YES;
    }

}
@end
