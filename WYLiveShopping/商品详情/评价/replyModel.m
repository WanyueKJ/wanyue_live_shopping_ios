//
//  replyModel.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/29.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "replyModel.h"

@implementation replyModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.add_time = minstr([dic valueForKey:@"add_time"]);
        self.avatar = minstr([dic valueForKey:@"avatar"]);
        self.comment = minstr([dic valueForKey:@"comment"]);
        self.merchant_reply_time = minstr([dic valueForKey:@"merchant_reply_time"]);
        self.nickname = minstr([dic valueForKey:@"nickname"]);
        self.star = minstr([dic valueForKey:@"star"]);
        self.suk = minstr([dic valueForKey:@"suk"]);
        id picsss = [dic valueForKey:@"pics"];
        if ([picsss isKindOfClass:[NSArray class]]) {
            self.pics = [dic valueForKey:@"pics"];
        }else{
            self.pics = @[];
        }
        if (minstr([dic valueForKey:@"merchant_reply_content"]).length > 0) {
            self.merchant_reply_content = [self stringWithParagraphlineSpeace:[NSString stringWithFormat:@"店小二:%@",minstr([dic valueForKey:@"merchant_reply_content"])]];
        }else{
            self.merchant_reply_content = [NSAttributedString new];
        }
        [self getRowHeight];
    }
    return self;
}
-(NSAttributedString *)stringWithParagraphlineSpeace:(NSString *)str {
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:normalColors};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, 4)];
    return attriStr;
}


- (void)getRowHeight{
    CGFloat contentH = [[WYToolClass sharedInstance] heightOfString:_comment andFont:SYS_Font(15) andWidth:_window_width-30];
    if (_pics.count == 0) {
        _picsH = 0;
        _rowH = 100 + contentH;
    }else{
        if (_pics.count%3 == 0) {
            _picsH = _pics.count/3 * ((_window_width - 50)/3+10);
            _rowH = _pics.count/3 * ((_window_width - 50)/3+10) + 100 + contentH + 10;
        }else{
            _picsH = (_pics.count/3 + 1) * ((_window_width - 50)/3+10);
            _rowH = (_pics.count/3 + 1) * ((_window_width - 50)/3+10) + 100 + contentH + 10;
        }
    }
    if (self.merchant_reply_content.length > 0) {
        CGFloat hhh = [[WYToolClass sharedInstance] getSpaceLabelHeightwithSpeace:5 withFont:SYS_Font(13) withWidth:_window_width-60 andString:[self.merchant_reply_content string]];
        _rowH += (hhh + 35);
    }
}
@end
