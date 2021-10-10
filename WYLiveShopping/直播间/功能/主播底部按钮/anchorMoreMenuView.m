//
//  anchorMoreMenuView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/9.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "anchorMoreMenuView.h"

@implementation anchorMoreMenuView{
    UIButton *torchButton;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *buttonarray = @[@"美颜",@"闪光灯",@"翻转",@"分享"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 90)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10.0;
        [self addSubview:view];
        CGFloat speace = (view.width-45*buttonarray.count)/(buttonarray.count + 1);
        for (int i = 0; i < buttonarray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(speace + i * (45+speace), 22.5, 90, 90);
            if ([buttonarray[i] isEqual:@"闪光灯"]) {
                [btn setImage:[UIImage imageNamed:@"功能_闪光灯开"] forState:UIControlStateSelected];
                [btn setImage:[UIImage imageNamed:@"功能_闪光灯关"] forState:0];
                torchButton = btn;
            }else{
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"功能_%@",buttonarray[i]]] forState:0];
            }
            [btn setTitle:buttonarray[i] forState:0];
            [btn setTitleColor:RGB_COLOR(@"#636363", 1) forState:0];
            btn.titleLabel.font = SYS_Font(10);
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            btn = [WYToolClass setUpImgDownText:btn space:8];
            btn.width = 45;
            btn.height = 45;
        }
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(view.right-18-6, view.bottom, 12, 6)];
        imgV.image = [UIImage imageNamed:@"menu-sanjiao"];
        [self addSubview:imgV];
    }
    return self;
}
- (void)setIsTorch:(BOOL)isTorch{
    _isTorch = isTorch;
    torchButton.selected = _isTorch;
}
- (void)buttonClick:(UIButton *)sender{
    if (self.block) {
        self.block(sender.titleLabel.text);
    }
}

@end
