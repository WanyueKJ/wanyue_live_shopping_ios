//
//  ReplyCell.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "ReplyCell.h"
#import "HZPhotoBrowser.h"

@implementation ReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(replyModel *)model{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _nameLabel.text = _model.nickname;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",_model.add_time,_model.suk];
    _commentLabel.text = _model.comment;
    _starView.currentScore = [_model.star floatValue];
    if (_model.merchant_reply_content.length > 0) {
        _huifuView.hidden = NO;
    }else{
        _huifuView.hidden = YES;
    }
    _huifuLabel.attributedText = _model.merchant_reply_content;
    _picViewHeightCon.constant = _model.picsH;
    [self addPics];
}
- (void)addPics{
    [_picsView removeAllSubViews];
    CGFloat picW = (_window_width - 50)/3;
    for (int i = 0; i < _model.pics.count; i ++) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((i%3) * (picW + 10), (i/3) * (picW + 10), picW, picW)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:_model.pics[i]]];
        imgV.userInteractionEnabled = YES;
        imgV.tag = 10000 + i;
        [_picsView addSubview:imgV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        [imgV addGestureRecognizer:tap];
    }
}
- (void)showBigImage:(UITapGestureRecognizer *)tap{
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.imageArray = _model.pics;
    browserVc.imageCount = _model.pics.count; // 图片总数
    browserVc.currentImageIndex = (int)tap.view.tag - 10000;//当前点击的图片
    [browserVc show];
}
@end
