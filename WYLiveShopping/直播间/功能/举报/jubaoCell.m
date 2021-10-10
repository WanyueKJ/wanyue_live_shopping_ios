//
//  jubaoCell.m
//  iphoneLive
//
//  Created by Boom on 2017/7/14.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "jubaoCell.h"

@implementation jubaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createTableViewCellSubview];
        
    }
    return self;
    
}
-(void)createTableViewCellSubview{
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, _window_width-80, 30)];
    _leftLabel.textColor = RGB_COLOR(@"#333333", 1);
    _leftLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_leftLabel];
    _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(15,17.5, 15, 15)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_rightImage];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 49, _window_width-30, 1)];
    line.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    [self.contentView addSubview:line];
}
@end
