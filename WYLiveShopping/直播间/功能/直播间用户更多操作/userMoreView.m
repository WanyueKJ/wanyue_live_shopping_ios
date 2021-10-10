//
//  userMoreView.m
//  WYLiveShopping
//
//  Created by IOS1 on 2020/6/19.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "userMoreView.h"

@implementation userMoreView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *buttonarray = @[@"举报"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, buttonarray.count * 30)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2.5;
        [self addSubview:view];
        for (int i = 0; i < buttonarray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(0, i * 30, frame.size.width, 30);
            [btn setTitle:buttonarray[i] forState:0];
            [btn setTitleColor:RGB_COLOR(@"#636363", 1) forState:0];
            btn.titleLabel.font = SYS_Font(10);
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            if (i != buttonarray.count - 1) {
                [[WYToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 29.5, btn.width, 0.5) andColor:RGB_COLOR(@"#000000", 0.1) andView:btn];
            }
        }
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/2-4, view.bottom, 8, 4)];
        imgV.image = [UIImage imageNamed:@"menu-sanjiao"];
        [self addSubview:imgV];
    }
    return self;
}
- (void)buttonClick:(UIButton *)sender{
    if (self.block) {
        self.block(sender.titleLabel.text);
    }
}


@end
