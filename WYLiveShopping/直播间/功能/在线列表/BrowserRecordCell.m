//
//  BrowserRecordCell.m
//  live1v1
//
//  Created by apple on 2020/2/6.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "BrowserRecordCell.h"
#import "chatModel.h"
@interface BrowserRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation BrowserRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = RGB_COLOR(@"#eeeeee", 1);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserHome)];
    [self.avatarView addGestureRecognizer:tap];
}
- (void)setModel:(chatModel *)model{
    _model = model;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.nameLabel.text = model.userName;
    self.timeLabel.attributedText = [self moneyStr:model.money];
}

- (void)showUserHome{
    if ([self.delegate respondsToSelector:@selector(userToast:)]) {
        [self.delegate userToast:_model];
    }
}
- (NSAttributedString *)moneyStr:(NSString *)money{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",money]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"coin"];
    attach.bounds = CGRectMake(0, -2, 13, 12);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [attStr insertAttributedString:imgStr atIndex:0];
    return attStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
