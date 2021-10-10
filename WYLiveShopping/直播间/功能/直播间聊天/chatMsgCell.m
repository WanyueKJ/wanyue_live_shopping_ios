//
//  chatMsgCell.m
//  yunbaolive
//
//  Created by Boom on 2018/10/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "chatMsgCell.h"
#import "SDWebImageManager.h"
@implementation chatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - TODO
-(void)setModel:(chatModel *)model{
    _model = model;
    NSMutableAttributedString *noteStr;
    if ([_model.type isEqual:@"2"]) {//普通聊天
        noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",_model.userName,_model.contentChat] attributes:nil];
        if (_model.isattent) {
            NSRange range = NSMakeRange(0, noteStr.length);
            [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#F6FF5E", 1) range:range];
        }else{
            NSRange range = NSMakeRange(_model.userName.length+1, _model.contentChat.length);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
        }
        
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        if ([_model.userType isEqualToString:kAnchorUser]) {
            attch.image = [UIImage imageNamed:@"主播"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-2.5, 20, 14);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr insertAttributedString:string atIndex:0];
        }else if([_model.userType isEqualToString:kSuperAdminUser]){
            attch.image = [UIImage imageNamed:@"超管"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-2.5, 20, 14);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr insertAttributedString:string atIndex:0];
        }else if ([_model.userType isEqualToString:kAdminUser]){
            attch.image = [UIImage imageNamed:@"管理"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-2, 20, 14);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr insertAttributedString:string atIndex:0];
        }
        
    }else  if ([_model.type isEqual:@"1"]){//系统消息
        noteStr = [[NSMutableAttributedString alloc] initWithString:_model.contentChat attributes:nil];

    }else  if ([_model.type isEqual:@"3"]){//进入房间
        noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",_model.userName,_model.contentChat] attributes:nil];

    }else if ([_model.type isEqual:@"4"]){//点亮
        noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ",_model.userName,_model.contentChat] attributes:nil];
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"likeImage"];
        // 设置图片大小
        attch.bounds = CGRectMake(0,-2.5, 15, 13.5);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [noteStr appendAttributedString:string];

    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];        //设置行间距
    [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteStr length])];

    [self.chatLabel setAttributedText:noteStr];

}

@end
